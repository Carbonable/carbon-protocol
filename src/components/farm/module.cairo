#[starknet::contract]
mod Farm {
    // Starknet imports

    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};

    // External imports

    use alexandria_numeric::interpolate::{
        interpolate_fast as interpolate, Interpolation, Extrapolation
    };
    use alexandria_numeric::cumsum::cumsum;
    use alexandria_storage::list::{List, ListTrait};
    use cairo_erc_3525::interface::{IERC3525Dispatcher, IERC3525DispatcherTrait};
    use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};

    // Internal imports

    use carbon::components::mint::interface::{IMintDispatcher, IMintDispatcherTrait};
    use carbon::components::farm::interface::{IFarm, IYieldFarm};
    use carbon::components::absorber::interface::{IAbsorberDispatcher, IAbsorberDispatcherTrait};

    // Constants

    const YEAR_SECONDS: u64 = 31556925;

    #[storage]
    struct Storage {
        _farm_project: IAbsorberDispatcher,
        _farm_slot: u256,
        _farm_token_id: u256,
        _farm_total_absorption: u256,
        _farm_total_sale: u256,
        _farm_total_registered_value: u256,
        _farm_total_registered_time: u64,
        _farm_absorption: LegacyMap::<ContractAddress, u256>,
        _farm_sale: LegacyMap::<ContractAddress, u256>,
        _farm_registered_value: LegacyMap::<ContractAddress, u256>,
        _farm_registered_time: LegacyMap::<ContractAddress, u64>,
        _farm_times: List::<u64>,
        _farm_prices: List::<u256>,
        _farm_updated_prices: List::<u256>,
        _farm_cumsales: List::<u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Deposit: Deposit,
        Withdraw: Withdraw,
        PriceUpdate: PriceUpdate,
    }

    #[derive(Drop, starknet::Event)]
    struct Deposit {
        address: ContractAddress,
        value: u256,
        time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct Withdraw {
        address: ContractAddress,
        value: u256,
        time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct Claim {
        address: ContractAddress,
        amount: u256,
        time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct PriceUpdate {
        price: u256,
        time: u64,
    }

    #[constructor]
    fn constructor(ref self: ContractState, project: ContractAddress, slot: u256,) {
        self.initializer(project, slot);
    }

    impl FarmImpl of IFarm<ContractState> {
        fn get_carbonable_project_address(self: @ContractState) -> ContractAddress {
            self._farm_project.read().contract_address
        }

        fn get_carbonable_project_slot(self: @ContractState) -> u256 {
            self._farm_slot.read()
        }

        fn get_total_deposited(self: @ContractState) -> u256 {
            self._farm_total_registered_value.read()
        }

        fn get_total_absorption(self: @ContractState) -> u256 {
            // [Compute] Total absorption
            let value = self._farm_total_registered_value.read();
            let time = self._farm_total_registered_time.read();
            let current_time = get_block_timestamp();
            let computed = self._compute_absorption(value, time, current_time);
            let stored = self._farm_total_absorption.read();
            let total_absorption = computed + stored;

            // [Check] Overflow
            assert(total_absorption <= self.get_max_absorption(), 'Total abs exceeds max abs');
            total_absorption
        }

        fn get_max_absorption(self: @ContractState) -> u256 {
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            project.get_current_absorption(slot).into()
        }

        fn get_deposited_of(self: @ContractState, account: ContractAddress) -> u256 {
            self._farm_registered_value.read(account)
        }

        fn get_absorption_of(self: @ContractState, account: ContractAddress) -> u256 {
            // [Compute] Account absorption
            let value = self._farm_registered_value.read(account);
            let time = self._farm_registered_time.read(account);
            let current_time = get_block_timestamp();
            let computed = self._compute_absorption(value, time, current_time);
            let stored = self._farm_absorption.read(account);
            let absorption = computed + stored;

            // [Check] Overflow
            assert(absorption <= self.get_total_absorption(), 'Abs exceeds total abs');
            absorption
        }

        fn deposit(ref self: ContractState, token_id: u256, value: u256) {
            // [Check] Value is not null
            assert(value != 0_u256, 'Value cannot be 0');

            // [Check] Caller is owner
            let erc721 = IERC721Dispatcher {
                contract_address: self._farm_project.read().contract_address
            };
            let caller = get_caller_address();
            let owner = erc721.owner_of(token_id);
            assert(caller == owner, 'Caller is not owner');

            // [Effect] Deposit
            self._deposit(token_id, get_contract_address(), value);
        }

        fn withdraw_to(ref self: ContractState, value: u256) {
            // [Effect] Withdraw
            let caller = get_caller_address();
            self._withdraw(to_token_id: 0_u256, to: caller, value: value);
        }

        fn withdraw_to_token(ref self: ContractState, token_id: u256, value: u256) {
            // [Check] Caller is owner
            let erc721 = IERC721Dispatcher {
                contract_address: self._farm_project.read().contract_address
            };
            let caller = get_caller_address();
            let owner = erc721.owner_of(token_id);
            assert(caller == owner, 'Caller is not owner');

            // [Effect] Withdraw
            self._withdraw(to_token_id: token_id, to: Zeroable::zero(), value: value);
        }
    }

    impl YieldFarmImpl of IYieldFarm<ContractState> {
        fn get_total_sale(self: @ContractState) -> u256 {
            // [Check] Prices are set, return 0 otherwise
            let prices = self._farm_prices.read();
            if prices.len() == 0 {
                return 0_u256;
            }

            // [Compute] Total sale
            let value = self._farm_total_registered_value.read();
            let time = self._farm_total_registered_time.read();
            let current_time = get_block_timestamp();
            let computed = self._compute_sale(value, time, current_time);
            let stored = self._farm_total_sale.read();
            let total_sale = computed + stored;

            // [Check] Overflow
            assert(total_sale <= self.get_max_sale(), 'Total sale exceeds max sale');
            total_sale
        }

        fn get_max_sale(self: @ContractState) -> u256 {
            // [Check] Prices are set, return 0 otherwise
            let prices = self._farm_prices.read();
            if prices.len() == 0 {
                return 0_u256;
            }

            // [Compute] Max possible sale
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            let ton_equivalent = project.get_ton_equivalent(slot);
            let project_value = project.get_project_value(slot);
            let start_time = project.get_start_time(slot);
            let current_time = get_block_timestamp();
            self._compute_sale(project_value, start_time, current_time)
        }

        fn get_sale_of(self: @ContractState, account: ContractAddress) -> u256 {
            // [Check] Prices are set, return 0 otherwise
            let prices = self._farm_prices.read();
            if prices.len() == 0 {
                return 0_u256;
            }

            // [Compute] Account sale
            let value = self._farm_registered_value.read(account);
            let time = self._farm_registered_time.read(account);
            let current_time = get_block_timestamp();
            let computed = self._compute_sale(value, time, current_time);
            let stored = self._farm_sale.read(account);
            let sale = computed + stored;

            // [Check] Overflow
            assert(sale <= self.get_total_sale(), 'Sale exceeds total sale');
            sale
        }

        fn get_current_price(self: @ContractState) -> u256 {
            let mut times = self._farm_times.read();
            let mut prices = self._farm_prices.read();
            let current_time: u256 = get_block_timestamp().into();
            let times_u256: Span<u256> = self.__list_u64_into_u256(@times);
            interpolate(
                current_time,
                times_u256,
                prices.array().span(),
                Interpolation::ConstantLeft,
                Extrapolation::Constant
            )
        }

        fn get_price_times(self: @ContractState) -> Span<u64> {
            let times = self._farm_times.read().array().span();
            times
        }

        fn get_prices(self: @ContractState) -> Span<u256> {
            self._farm_prices.read().array().span()
        }

        fn get_cumsale_times(self: @ContractState) -> Span<u64> {
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            let absorption_times = project.get_times(slot);
            let price_times = self._farm_times.read().array().span();
            self.__merge_and_sort(absorption_times, price_times)
        }

        fn get_updated_prices(self: @ContractState) -> Span<u256> {
            self._farm_updated_prices.read().array().span()
        }

        fn get_cumsales(self: @ContractState) -> Span<u256> {
            self._farm_cumsales.read().array().span()
        }

        fn get_apr(self: @ContractState, minter: ContractAddress) -> (u256, u256) {
            let times = self.get_cumsale_times();
            let times_len = times.len();
            if times_len == 0 {
                return (0_u256, 0_u256);
            }

            // [Check] Current time is not later than the latest time
            let current_time = get_block_timestamp();
            let latest_time = *times.at(times_len - 1);
            if latest_time <= current_time {
                return (0_u256, 0_u256);
            }

            // [Compute] Current cumsale

            let times_u256: Span<u256> = self.__span_u64_into_u256(times);
            let cumsales = self._farm_cumsales.read().array();
            let current_cumsale = interpolate(
                current_time.into(),
                times_u256,
                cumsales.span(),
                Interpolation::Linear,
                Extrapolation::Constant
            );

            // [Compute] Next cumsale
            let mut index = 0;
            let closet_index = loop {
                if index == times_len {
                    break index - 1;
                }
                if current_time < *times.at(index) {
                    break index;
                }
                index += 1;
            };
            let next_time = *times_u256.at(index);
            let next_cumsale = *cumsales.at(index);

            // [Check] Overflow
            assert(current_time.into() < next_time, 'Time overflow');
            assert(current_cumsale <= next_cumsale, 'Cumsale overflow');

            // [Compute] Total investement
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            let project_value = project.get_project_value(slot);
            let unit_price = IMintDispatcher { contract_address: minter }.get_unit_price();
            let ton_equivalent = project.get_ton_equivalent(slot);

            // [Compute] APR
            let num = (next_cumsale - current_cumsale) * YEAR_SECONDS.into();
            let den = project_value
                * unit_price
                * (next_time - current_time.into())
                * ton_equivalent.into();
            (num, den)
        }

        fn set_prices(ref self: ContractState, times: Span<u64>, prices: Span<u256>) {
            // [Check] Times and prices are defined
            assert(times.len() == prices.len(), 'Times and prices mismatch');
            assert(times.len() > 0, 'Times or prices cannot be empty');

            // [Effect] Update times, prices, updated_prices and cumsales
            self._set_prices(times, prices);
            self._update_cumsales();
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(ref self: ContractState, project: ContractAddress, slot: u256) {
            // [Check] Inputs
            assert(!project.is_zero(), 'Projects contract cannot be 0');
            assert(slot != 0_u256, 'Slot cannot be 0');

            // [Effect] Store inputs
            self._farm_project.write(IAbsorberDispatcher { contract_address: project });
            self._farm_slot.write(slot);
        }

        fn _deposit(
            ref self: ContractState, from_token_id: u256, to: ContractAddress, value: u256
        ) {
            // [Effect] Store caller and total absorptions
            let caller = get_caller_address();
            let absorption = self.get_absorption_of(caller);
            self._farm_absorption.write(caller, absorption);
            let total_absorption = self.get_total_absorption();
            self._farm_total_absorption.write(total_absorption);

            // [Effect] Store caller and total sales
            let sale = self.get_sale_of(caller);
            self._farm_sale.write(caller, sale);
            let total_sale = self.get_total_sale();
            self._farm_total_sale.write(total_sale);

            // [Effect] Register the new caller value and the current timestamp
            let current_time = get_block_timestamp();
            let stored_value = self._farm_registered_value.read(caller);
            self._farm_registered_time.write(caller, current_time);
            self._farm_registered_value.write(caller, stored_value + value);

            // [Effect] Register the new total value and the current timestamp
            let stored_total_value = self._farm_total_registered_value.read();
            self._farm_total_registered_time.write(current_time);
            self._farm_total_registered_value.write(stored_total_value + value);

            // [Interaction] Transfer value from from_token_id to to_token_id
            let to_token_id = self._farm_token_id.read();
            let project = self._farm_project.read();
            if to_token_id == 0 {
                // [Effect] If first time, store the new token_id
                let token_id = IERC3525Dispatcher { contract_address: project.contract_address }
                    .transfer_value_from(from_token_id, to_token_id, to, value);
                self._farm_token_id.write(token_id);
            } else {
                let zero = starknet::contract_address_const::<0>();
                IERC3525Dispatcher { contract_address: project.contract_address }
                    .transfer_value_from(from_token_id, to_token_id, zero, value);
            }

            // [Event] Emit event
            let event = Deposit { address: caller, value: value, time: current_time };
            self.emit(event);
        }

        fn _withdraw(ref self: ContractState, to_token_id: u256, to: ContractAddress, value: u256) {
            // [Effect] Store caller and total absorptions
            let caller = get_caller_address();
            let absorption = self.get_absorption_of(caller);
            self._farm_absorption.write(caller, absorption);
            let total_absorption = self.get_total_absorption();
            self._farm_total_absorption.write(total_absorption);
            // [Effect] Store caller and total sales
            let sale = self.get_sale_of(caller);
            self._farm_sale.write(caller, sale);
            let total_sale = self.get_total_sale();
            self._farm_total_sale.write(total_sale);

            // [Check] Value is less than or equal to the registered values
            let current_time = get_block_timestamp();
            let stored_value = self._farm_registered_value.read(caller);
            assert(value <= stored_value, 'Value exceeds internal balance');
            let stored_total_value = self._farm_total_registered_value.read();
            assert(value <= stored_total_value, 'Value exceeds internal balance');
            // [Effect] Register the new caller value and the current timestamp
            self._farm_registered_time.write(caller, current_time);
            self._farm_registered_value.write(caller, stored_value - value);
            // [Effect] Register the new total value and current timestamp
            self._farm_total_registered_time.write(current_time);
            self._farm_total_registered_value.write(stored_total_value - value);

            // [Interaction] Transfer value from contract to caller
            let from_token_id = self._farm_token_id.read();
            let project = self._farm_project.read();
            IERC3525Dispatcher { contract_address: project.contract_address }
                .transfer_value_from(from_token_id, to_token_id, to, value);

            // [Event] Emit event
            let withdraw = Withdraw { address: caller, value: value, time: current_time };
            self.emit(withdraw);
        }

        fn _set_prices(ref self: ContractState, times: Span<u64>, prices: Span<u256>) {
            // [Effect] Clean times and prices
            let mut stored_times = self._farm_times.read();
            stored_times.len = 0;
            let mut stored_prices = self._farm_prices.read();
            stored_prices.len = 0;

            // [Effect] Store new times and prices
            let mut index = 0;
            loop {
                if index == times.len() {
                    break;
                }
                stored_times.append(*times[index]);
                stored_prices.append(*prices[index]);
                index += 1;
            };
        }

        fn _compute_absorption(
            self: @ContractState, value: u256, start_time: u64, end_time: u64
        ) -> u256 {
            // [Compute] Project value
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            let project_value = project.get_project_value(slot);

            // [Compute] Interpolated absorptions
            let initial_absorption = project.get_absorption(slot, start_time);
            let final_absorption = project.get_absorption(slot, end_time);

            // [Compute] Absorption corresponding to the share
            self.__compute_absorption(value, project_value, initial_absorption, final_absorption)
        }

        fn _compute_sale(
            self: @ContractState, value: u256, start_time: u64, end_time: u64
        ) -> u256 {
            // [Check] Value is not null, otherwise return 0
            if value == 0_u256 {
                return 0_u256;
            }

            // [Check] Project value is not null, otherwise return 0
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            let project_value = project.get_project_value(slot);
            if project_value == 0_u256 {
                return 0_u256;
            }

            // [Compute] Interpolated sales
            let cumsales = self._farm_cumsales.read().array().span();
            let times = self._farm_times.read();

            // [Compute] Convert times from Array<u64> into Array<u256>
            let times = self.get_cumsale_times();
            let cumsales = self.get_cumsales();
            let times_u256: Span<u256> = self.__span_u64_into_u256(times);

            // [Compute] Sale
            let initial_cumsale = interpolate(
                start_time.into(),
                times_u256,
                cumsales,
                Interpolation::Linear,
                Extrapolation::Constant
            );
            let final_cumsale = interpolate(
                end_time.into(),
                times_u256,
                cumsales,
                Interpolation::Linear,
                Extrapolation::Constant
            );

            // [Check] Overflow
            assert(initial_cumsale <= final_cumsale, 'Overflow');

            // [Compute] Total sale, if null then return 0
            if final_cumsale == initial_cumsale {
                return 0_u256;
            }
            // [Compute] Otherwise returns the sale corresponding to the ratio
            value * (final_cumsale - initial_cumsale) / project_value
        }

        fn _update_cumsales(self: @ContractState) {
            // [Effect] Clean updated_prices and cumsales
            let mut updated_prices = self._farm_updated_prices.read();
            updated_prices.len = 0;
            let mut cumsales = self._farm_cumsales.read();
            cumsales.len = 0;

            // [Effect] Compute sales and store updated prices
            let project = self._farm_project.read();
            let slot = self._farm_slot.read();
            let absorption_times = project.get_times(slot);
            let absorption_times_u256 = self.__span_u64_into_u256(absorption_times);
            let absorptions = project.get_absorptions(slot);
            let absorptions_u256 = self.__span_u64_into_u256(absorptions);

            let price_times = self._farm_times.read().array().span();
            let price_times_u256 = self.__span_u64_into_u256(price_times);
            let times: Span<u64> = self.__merge_and_sort(absorption_times, price_times);
            let times_u256: Span<u256> = self.__span_u64_into_u256(times);

            let prices = self._farm_prices.read().array().span();
            let mut sales = ArrayTrait::<u256>::new();
            let mut index = 0;

            let mut updated_prices_array: Array<u256> = Default::default();
            loop {
                // [Check] End criteria
                if index == times.len() {
                    break ();
                }

                let time = *times.at(index);
                let current_price = interpolate(
                    time.into(),
                    price_times_u256,
                    prices,
                    Interpolation::ConstantLeft,
                    Extrapolation::Constant
                );

                // [Check] First iteration (special case)
                if index == 0 {
                    sales.append(0);
                    updated_prices_array.append(current_price);
                    index += 1;
                    continue;
                }

                // [Compute] Interpolated absorptions
                let previous_time = *times.at(index - 1);

                let previous_absorption = interpolate(
                    previous_time.into(),
                    absorption_times_u256,
                    absorptions_u256,
                    Interpolation::Linear,
                    Extrapolation::Constant
                );

                let current_absorption = interpolate(
                    time.into(),
                    absorption_times_u256,
                    absorptions_u256,
                    Interpolation::Linear,
                    Extrapolation::Constant
                );

                // [Check] Absorption is not null otherwise return 0
                assert(previous_absorption < current_absorption, 'No absorption');
                let new_absorption: u256 = current_absorption - previous_absorption;

                // [Compute] Store results and update variables for the next iter
                sales.append(new_absorption * current_price);
                updated_prices_array.append(current_price);
                index += 1;
            };
            // [Effect] Store cumsales and prices
            let cumulative_sales = cumsum(sales.span()).span();

            let mut index = 0;
            loop {
                if index == times.len() {
                    break ();
                }
                cumsales.append(*cumulative_sales.at(index));
                updated_prices.append(*updated_prices_array.span().at(index));
                index += 1;
            };
        }
    }

    #[generate_trait]
    impl PrivateImpl of PrivateTrait {
        #[inline(always)]
        fn __compute_absorption(
            self: @ContractState,
            value: u256,
            project_value: u256,
            initial_absorption: u64,
            final_absorption: u64
        ) -> u256 {
            // [Check] Value is not null, otherwise return 0
            if value == 0_u256 {
                return 0_u256;
            }

            // [Check] Project value is not null, otherwise return 0
            if project_value == 0_u256 {
                return 0_u256;
            }

            // [Check] Overflow
            assert(initial_absorption <= final_absorption, 'Overflow');

            // [Compute] Absorption corresponding to the ratio
            value * (final_absorption - initial_absorption).into() / project_value
        }

        fn __list_u64_into_u256(self: @ContractState, list: @List<u64>) -> Span<u256> {
            let mut array = ArrayTrait::<u256>::new();
            let mut index = 0;
            loop {
                if index == list.len() {
                    break ();
                }
                array.append(list[index].into());
                index += 1;
            };
            array.span()
        }

        fn __span_u64_into_u256(self: @ContractState, span: Span<u64>) -> Span<u256> {
            let mut array = ArrayTrait::<u256>::new();
            let mut index = 0;
            loop {
                if index == span.len() {
                    break ();
                }
                array.append((*span[index]).into());
                index += 1;
            };
            array.span()
        }

        fn __merge_and_sort(self: @ContractState, arr1: Span<u64>, arr2: Span<u64>) -> Span<u64> {
            let mut values: Felt252Dict<felt252> = Default::default();
            let mut array: Array<u64> = Default::default();
            let mut index1 = 0;
            let mut index2 = 0;
            loop {
                if index1 == arr1.len() || index2 == arr2.len() {
                    break ();
                }
                let value1 = *arr1[index1];
                let value2 = *arr2[index2];
                if value1 < value2 {
                    if !(values.get(value1.into()) == 1) {
                        array.append(value1);
                        values.insert(value1.into(), 1);
                    }
                    index1 += 1;
                } else {
                    if !(values.get(value2.into()) == 1) {
                        array.append(value2);
                        values.insert(value2.into(), 1);
                    }
                    index2 += 1;
                };
            };
            loop {
                if index1 == arr1.len() {
                    break ();
                }
                let value1 = *arr1[index1];
                if !(values.get(value1.into()) == 1) {
                    array.append(value1);
                    values.insert(value1.into(), 1);
                }
                index1 += 1;
            };
            loop {
                if index2 == arr2.len() {
                    break ();
                }
                let value2 = *arr2[index2];
                if !(values.get(value2.into()) == 1) {
                    array.append(value2);
                    values.insert(value2.into(), 1);
                }
                index2 += 1;
            };
            array.span()
        }
    }
}


#[cfg(test)]
mod Test {
    use starknet::{ContractAddress, get_contract_address};
    use starknet::testing::set_block_timestamp;

    use alexandria_storage::list::{List, ListTrait};

    use super::Farm;
    use super::Farm::_farm_token_id::InternalContractMemberStateTrait as TokenIdTrait;
    use super::Farm::_farm_total_absorption::InternalContractMemberStateTrait as TotalAbsorptionTrait;
    use super::Farm::_farm_total_sale::InternalContractMemberStateTrait as TotalSaleTrait;
    use super::Farm::_farm_total_registered_value::InternalContractMemberStateTrait as TotalRegisteredValueTrait;
    use super::Farm::_farm_total_registered_time::InternalContractMemberStateTrait as TotalRegisteredTimeTrait;
    use super::Farm::_farm_absorption::InternalContractMemberStateTrait as AbsorptionTrait;
    use super::Farm::_farm_sale::InternalContractMemberStateTrait as SaleTrait;
    use super::Farm::_farm_registered_value::InternalContractMemberStateTrait as RegisteredValueTrait;
    use super::Farm::_farm_registered_time::InternalContractMemberStateTrait as RegisteredTimeTrait;
    use super::Farm::_farm_times::InternalContractMemberStateTrait as TimesTrait;
    use super::Farm::_farm_prices::InternalContractMemberStateTrait as PricesTrait;

    const SLOT: u256 = 1;
    const VALUE: u256 = 1000;

    fn STATE() -> Farm::ContractState {
        Farm::unsafe_new_contract_state()
    }

    fn PROJECT() -> ContractAddress {
        starknet::contract_address_const::<'PROJECT'>()
    }

    fn OWNER() -> ContractAddress {
        starknet::contract_address_const::<'OWNER'>()
    }

    fn ANYONE() -> ContractAddress {
        starknet::contract_address_const::<'ANYONE'>()
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_initializer() {
        // [Setup]
        let mut state = STATE();
        Farm::InternalImpl::initializer(ref state, PROJECT(), SLOT);
        // [Assert] Project and slot are stored
        assert(
            Farm::FarmImpl::get_carbonable_project_address(@state) == PROJECT(),
            'Wrong project address'
        );
        assert(Farm::FarmImpl::get_carbonable_project_slot(@state) == SLOT, 'Wrong slot');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_set_prices() {
        // [Setup]
        let mut state = STATE();
        Farm::InternalImpl::initializer(ref state, PROJECT(), SLOT);
        // [Assert] Prices
        let times = array![10, 20, 30, 40, 50].span();
        let prices = array![100, 200, 300, 400, 500].span();
        Farm::InternalImpl::_set_prices(ref state, times, prices);
        assert(state._farm_times.read().array().span() == times, 'Wrong times');
        assert(state._farm_prices.read().array().span() == prices, 'Wrong prices');
    }

    use debug::PrintTrait;

    #[test]
    #[available_gas(999_666_777)]
    fn test_set_prices_n() {
        // [Setup]
        let mut state = STATE();
        Farm::InternalImpl::initializer(ref state, PROJECT(), SLOT);
        // [Assert] Prices
        let mut i = 1;
        let n: u64 = 25;
        let mut times: Array<u64> = Default::default();
        let mut prices: Array<u256> = Default::default();
        loop {
            if i > n {
                break;
            }
            times.append(i * 1000);
            prices.append((i * 10).into());
            i += 1;
        };
        let prices = prices.span();
        let times = times.span();
        Farm::InternalImpl::_set_prices(ref state, times, prices);
        assert(state._farm_times.read().array().span() == times, 'Wrong times');
        assert(state._farm_prices.read().array().span() == prices, 'Wrong prices');
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Times and prices mismatch',))]
    fn test_set_prices_revert_mismatch() {
        // [Setup]
        let mut state = STATE();
        Farm::InternalImpl::initializer(ref state, PROJECT(), SLOT);
        // [Assert] Prices
        let times = array![10, 20, 30, 40, 50].span();
        let prices = array![].span();
        Farm::YieldFarmImpl::set_prices(ref state, times, prices);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Times or prices cannot be empty',))]
    fn test_set_prices_revert_empty() {
        // [Setup]
        let mut state = STATE();
        Farm::InternalImpl::initializer(ref state, PROJECT(), SLOT);
        // [Assert] Prices
        let times = array![].span();
        let prices = array![].span();
        Farm::YieldFarmImpl::set_prices(ref state, times, prices);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_current_price() {
        // [Setup]
        let mut state = STATE();
        let times = array![10, 20, 30, 40, 50].span();
        let prices = array![100, 200, 300, 400, 500].span();
        let ton_equivalent = 1000000;
        Farm::InternalImpl::_set_prices(ref state, times, prices);
        // [Assert] Before start, price = prices[0]
        set_block_timestamp(*times.at(0) - 5);
        let price = Farm::YieldFarmImpl::get_current_price(@state);
        assert(price == *prices.at(0), 'Wrong price');
        // [Assert] At start, price = prices[0]
        set_block_timestamp(*times.at(0));
        let price = Farm::YieldFarmImpl::get_current_price(@state);
        assert(price == *prices.at(0), 'Wrong price');
        // [Assert] After start, prices[0] < price < prices[1]
        set_block_timestamp(*times.at(0) + 5);
        let price = Farm::YieldFarmImpl::get_current_price(@state);
        assert(price > *prices.at(0), 'Wrong price');
        assert(price < *prices.at(1), 'Wrong price');
        // [Assert] Before end, prices[-2] < price < prices[-1]
        set_block_timestamp(*times.at(times.len() - 1) - 5);
        let price = Farm::YieldFarmImpl::get_current_price(@state);
        assert(price > *prices.at(prices.len() - 2), 'Wrong price');
        assert(price < *prices.at(prices.len() - 1), 'Wrong price');
        // [Assert] At end, price = prices[-1]
        set_block_timestamp(*times.at(times.len() - 1));
        let price = Farm::YieldFarmImpl::get_current_price(@state);
        assert(price == *prices.at(prices.len() - 1), 'Wrong price');
        // [Assert] After end, price = prices[-1]
        set_block_timestamp(*times.at(times.len() - 1) + 5);
        let price = Farm::YieldFarmImpl::get_current_price(@state);
        assert(price == *prices.at(prices.len() - 1), 'Wrong price');
    }

    #[test]
    #[available_gas(350_000)]
    fn test_merge_and_sort() {
        // [Setup]
        let mut state = STATE();
        let absorption_times = array![10, 20, 30, 40, 50].span();
        let price_times = array![12, 20, 33].span();
        // [Assert] Merged and sorted
        let times = Farm::PrivateImpl::__merge_and_sort(@state, absorption_times, price_times);
        assert(times == array![10, 12, 20, 30, 33, 40, 50].span(), 'Wrong times');
    }

    fn get_test_array(length: u64, mul: u64) -> Array<u64> {
        let mut test: Array<u64> = Default::default();
        let mut i = 1;
        loop {
            if i > length {
                break;
            }
            test.append(i * mul);
            i += 1;
        };
        test
    }

    #[test]
    #[available_gas(999_350_000)]
    fn test_merge_and_sort_n() {
        // [Setup]
        let mut state = STATE();
        let n = 25;
        let absorption_times = get_test_array(n, 1).span();
        let price_times = get_test_array(n, 2).span();

        let times = Farm::PrivateImpl::__merge_and_sort(@state, absorption_times, price_times);
    }
}
