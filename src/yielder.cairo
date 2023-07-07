use core::traits::TryInto;

#[starknet::contract]
mod yielder {
    use zeroable::Zeroable;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use array::{Array, ArrayTrait};
    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};
    use alexandria_numeric::interpolate::{interpolate, Interpolation, Extrapolation};
    use alexandria_numeric::cumsum::cumsum;
    use alexandria_storage::list::{List, ListTrait};
    use protocol::interfaces::ownable::IOwnable;
    use protocol::interfaces::farmer::IFarmer;
    use protocol::interfaces::yielder::IYielder;
    use protocol::interfaces::erc20::{IERC20Dispatcher, IERC20DispatcherTrait};
    use protocol::interfaces::erc721::{IERC721Dispatcher, IERC721DispatcherTrait};
    use protocol::interfaces::erc3525::{IERC3525Dispatcher, IERC3525DispatcherTrait};
    use protocol::interfaces::project::{IProjectDispatcher, IProjectDispatcherTrait};
    use protocol::interfaces::minter::{IMinterDispatcher, IMinterDispatcherTrait};

    const YEAR_SECONDS: u64 = 31556925;

    #[storage]
    struct Storage {
        // Ownable module
        _owner: ContractAddress,
        // Farmer module
        _project: IProjectDispatcher,
        _slot: u256,
        _total_absorption: u256,
        _total_sale: u256,
        _total_registered_value: u256,
        _total_registered_time: u64,
        _absorption: LegacyMap::<ContractAddress, u256>,
        _sale: LegacyMap::<ContractAddress, u256>,
        _registered_value: LegacyMap::<ContractAddress, u256>,
        _registered_time: LegacyMap::<ContractAddress, u64>,
        _times: List::<u64>,
        _prices: List::<u256>,
        // Yielder module
        _erc20: IERC20Dispatcher,
        _total_claimed: u256,
        _claimed: LegacyMap::<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Deposit: Deposit,
        Withdraw: Withdraw,
        Claim: Claim,
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
    fn constructor(
        ref self: ContractState,
        project: ContractAddress,
        slot: u256,
        token: ContractAddress,
        owner: ContractAddress,
    ) {
        // [Check] Inputs
        assert(!project.is_zero(), 'Projects contract cannot be 0');
        assert(slot != 0_u256, 'Slot cannot be 0');
        assert(!owner.is_zero(), 'Owner cannot be 0');

        // [Effect] Store inputs
        self._project.write(IProjectDispatcher { contract_address: project });
        self._slot.write(slot);
        self._erc20.write(IERC20Dispatcher { contract_address: token });
        self._owner.write(owner);
    }

    #[external(v0)]
    impl OwnableImpl of IOwnable<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self._owner.read()
        }
        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            // [Check] Caller is owner
            let caller = get_caller_address();
            let owner = self._owner.read();
            assert(caller == owner, 'Caller is not owner');

            // [Check] New owner is not 0
            assert(!new_owner.is_zero(), 'New owner cannot be 0');

            // [Effect] Transfer ownership
            self._owner.write(new_owner);
        }
        fn renounce_ownership(ref self: ContractState) {
            // [Check] Caller is owner
            let caller = get_caller_address();
            let owner = self._owner.read();
            assert(caller == owner, 'Caller is not owner');

            // [Effect] Renounce ownership
            self._owner.write(Zeroable::zero());
        }
    }

    #[external(v0)]
    impl FarmerImpl of IFarmer<ContractState> {
        fn get_carbonable_project_address(self: @ContractState) -> ContractAddress {
            self._project.read().contract_address
        }
        fn get_carbonable_project_slot(self: @ContractState) -> u256 {
            self._slot.read()
        }
        fn get_total_deposited(self: @ContractState) -> u256 {
            self._total_registered_value.read()
        }
        fn get_total_absorption(self: @ContractState) -> u256 {
            // [Compute] Total absorption
            let value = self._total_registered_value.read();
            let time = self._total_registered_time.read();
            let current_time = get_block_timestamp();
            let computed = self._compute_absorption(value, time, current_time);
            let stored = self._total_absorption.read();
            let total_absorption = computed + stored;

            // [Check] Overflow
            assert(total_absorption <= self.get_max_absorption(), 'Total abs exceeds max abs');
            total_absorption
        }
        fn get_max_absorption(self: @ContractState) -> u256 {
            let project = self._project.read();
            let slot = self._slot.read();
            project.get_current_absorption(slot).into()
        }
        fn get_total_sale(self: @ContractState) -> u256 {
            // [Compute] Total sale
            let value = self._total_registered_value.read();
            let time = self._total_registered_time.read();
            let current_time = get_block_timestamp();
            let computed = self._compute_sale(value, time, current_time);
            let stored = self._total_sale.read();
            let total_sale = computed + stored;

            // [Check] Overflow
            assert(total_sale <= self.get_max_sale(), 'Total sale exceeds max sale');
            total_sale
        }
        fn get_max_sale(self: @ContractState) -> u256 {
            let project = self._project.read();
            let slot = self._slot.read();
            let ton_equivalent = project.get_ton_equivalent(slot);
            let project_value = project.get_project_value(slot);
            let start_time = project.get_start_time(slot);
            let current_time = get_block_timestamp();
            self._compute_sale(project_value, start_time, current_time)

        }
        fn get_deposited_of(self: @ContractState, account: ContractAddress) -> u256 {
            self._registered_value.read(account)
        }
        fn get_absorption_of(self: @ContractState, account: ContractAddress) -> u256 {
            // [Compute] Account absorption
            let value = self._registered_value.read(account);
            let time = self._registered_time.read(account);
            let current_time = get_block_timestamp();
            let computed = self._compute_absorption(value, time, current_time);
            let stored = self._absorption.read(account);
            let absorption = computed + stored;

            // [Check] Overflow
            assert(absorption <= self.get_total_absorption(), 'Abs exceeds total abs');
            absorption
        }
        fn get_sale_of(self: @ContractState, account: ContractAddress) -> u256 {
            // [Compute] Account sale
            let value = self._registered_value.read(account);
            let time = self._registered_time.read(account);
            let current_time = get_block_timestamp();
            let computed = self._compute_sale(value, time, current_time);
            let stored = self._sale.read(account);
            let sale = computed + stored;

            // [Check] Overflow
            assert(sale <= self.get_total_sale(), 'Sale exceeds total sale');
            sale
        }
        fn get_current_price(self: @ContractState) -> u256 {
            let mut times = self._times.read();
            let mut prices = self._prices.read();
            let current_time: u256 = get_block_timestamp().into();

            let mut times_u256 = ArrayTrait::<u256>::new();
            let mut index = 0;
            loop {
                if index >= times.len() {
                    break ();
                }
                times_u256.append(times[index].into());
                index += 1;
            };
            interpolate(current_time, @times_u256, @prices.array(), Interpolation::Linear(()), Extrapolation::Constant(()))
        }
        fn get_prices(self: @ContractState) -> (Array<u64>, Array<u256>, Array<u256>, Array<u256>) {
            let times = self._times.read().array();
            let prices = self._prices.read().array();
            let (_, updated_prices, cumsales) = self._compute_cumsales();
            (times, prices, updated_prices, cumsales)
        }
        fn get_apr(self: @ContractState, minter: ContractAddress) -> (u256, u256) {
            // [Check] Arrays are defined
            let times = self._times.read();
            let times_len = times.len();
            if times_len == 0 {
                return (0_u256, 0_u256);
            }

            // [Check] Current time is not later than the latest time
            let current_time = get_block_timestamp();
            let latest_time = times[times_len - 1];
            if  latest_time <= current_time {
                return (0_u256, 0_u256);
            }

            // [Compute] Current cumsale
            let (times_u256, _, cumsales) = self._compute_cumsales();
            let current_cumsale = interpolate(current_time.into(), @times_u256, @cumsales, Interpolation::Linear(()), Extrapolation::Constant(()));

            // [Compute] Next cumsale
            let mut index = 0;
            let closet_index = loop {
                if index == times_len {
                    break index - 1;
                }
                if current_time < times[index] {
                    break index;
                }
                index += 1;
            };
            let next_time = *times_u256.at(index);
            let next_cumsale = *cumsales.at(index);

            // [Check] Overflow
            assert(current_time.into() < next_time, 'Time overflow');
            assert(current_cumsale <= next_cumsale , 'Cumsale overflow');

            // [Compute] Total investement
            let project = self._project.read();
            let slot = self._slot.read();
            let project_value = project.get_project_value(slot);
            let unit_price = IMinterDispatcher { contract_address: minter }.getUnitPrice();
            let ton_equivalent = project.get_ton_equivalent(slot);

            // [Compute] APR
            let num = (next_cumsale - current_cumsale) * YEAR_SECONDS.into();
            let den = project_value * unit_price * (next_time - current_time.into()) * ton_equivalent.into();
            (num, den)
        }
        fn deposit(ref self: ContractState, token_id: u256, value: u256) {
            // [Check] Value is not null
            assert(value != 0_u256, 'Value cannot be 0');

            // [Check] Caller is owner
            let erc721 = IERC721Dispatcher { contract_address: self._project.read().contract_address };
            let caller = get_caller_address();
            let owner = erc721.ownerOf(self._slot.read());
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
            let erc721 = IERC721Dispatcher { contract_address: self._project.read().contract_address };
            let caller = get_caller_address();
            let owner = erc721.ownerOf(self._slot.read());
            assert(caller == owner, 'Caller is not owner');

            // [Effect] Withdraw
            self._withdraw(to_token_id: token_id, to: Zeroable::zero(), value: value);
        }
        fn add_price(ref self: ContractState, time: u64, price: u256) {
            // [Check] Time is later than the project start time
            let project = self._project.read();
            let slot = self._slot.read();
            let start_time = project.get_start_time(slot);
            assert(time > start_time, 'Time is before start time');

            // [Check] First time to store
            let mut stored_times = self._times.read();
            let mut stored_prices = self._prices.read();
            if stored_times.len() == 0 {
                stored_times.append(start_time);
                stored_times.append(time);
                stored_prices.append(price);
                stored_prices.append(price);
                return;
            }

            // [Check] Time is later than the last stored time
            let last_time = stored_times[stored_times.len() - 1];
            assert(time > last_time, 'Time is before last time');

            // [Check] Absorption is stored between these times
            let initial_absorption = project.get_absorption(slot, last_time);
            let final_absorption = project.get_absorption(slot, time);
            assert(final_absorption > initial_absorption, 'No absorption captured');

            // [Effect] Update storage
            stored_times.append(time);
            stored_prices.append(price);
        }
        fn update_last_price(ref self: ContractState, time: u64, price: u256) {
            // [Check] At least 2 prices stored
            let mut stored_times = self._times.read();
            let mut stored_prices = self._prices.read();
            assert(stored_times.len() > 1, 'Not enough prices stored');

            // [Check] Current time is sooner than the last 2 stored times
            let current_time = get_block_timestamp();
            let before_last_time = stored_times[stored_times.len() - 2];
            assert(current_time < before_last_time, 'Current time is too late');

            // [Check] Specified time is later than the before last stored time
            assert(time > before_last_time, 'Time is before the last 2 times');

            // [Check] Absorption is captured between the 2 new last times
            let slot = self._slot.read();
            let project = self._project.read();
            let initial_absorption = project.get_absorption(slot, before_last_time);
            let final_absorption = project.get_absorption(slot, time);
            assert(final_absorption > initial_absorption, 'No absorption captured');

            // [Effect] Update storage
            stored_times.set(stored_times.len() - 1, time);
            stored_prices.set(stored_prices.len() - 1, price);
        }
        fn set_prices(ref self: ContractState, times: Array<u64>, prices: Array<u256>) {
            // [Check] Times and prices are defined
            assert(times.len() == prices.len(), 'Times and prices mismatch');
            assert(times.len() > 0, 'Times or prices cannot be empty');

            // [Effect] Clean times and prices
            let mut stored_times = self._times.read();
            let mut stored_prices = self._prices.read();
            let mut index = stored_times.len();
            loop {
                if index == 0 {
                    break;
                }
                stored_times.pop_front();
                stored_prices.pop_front();
                index -= 1;
            };

            // [Effect] Store new times and prices
            let mut index = 0;
            loop {
                if index == times.len() {
                    break;
                }
                stored_times.append(*times[index - 1]);
                stored_prices.append(*prices[index - 1]);
                index += 1;
            };
        }
    }

    #[external(v0)]
    impl YielderImpl of IYielder<ContractState> {
        fn get_payment_token_address(self: @ContractState) -> ContractAddress {
            self._erc20.read().contract_address
        }

        fn get_total_claimable(self: @ContractState) -> u256 {
            let total_sale = self.get_total_sale();
            let claimed = self._total_claimed.read();
            total_sale + claimed
        }
        fn get_total_claimed(self: @ContractState) -> u256 {
            self._total_claimed.read()
        }
        fn get_claimable_of(self: @ContractState, account: ContractAddress) -> u256 {
            let sale = self.get_sale_of(account);
            let claimed = self._claimed.read(account);
            sale - claimed
        }
        fn get_claimed_of(self: @ContractState, account: ContractAddress) -> u256 {
            self._claimed.read(account)
        }
        fn claim(ref self: ContractState, token_id: u256) {
            // [Effect] Update user claimed
            let caller = get_caller_address();
            let amount = self.get_claimable_of(caller);
            let stored_amount = self._claimed.read(caller);
            self._claimed.write(caller, stored_amount + amount);

            // [Effect] Update total claimed
            let total_claimed = self._total_claimed.read();
            self._total_claimed.write(total_claimed + amount);

            // [Interaction] ERC20 transfer
            let erc20 = self._erc20.read();
            let success = erc20.transfer(caller, amount);

            // [Check] Transfer successful
            assert(success, 'Transfer failed');

            // [Event] Emit event
            let current_time = get_block_timestamp();
            self.emit(Event::Claim(Claim { address: caller, amount: amount, time: current_time }));
        }
    }

    #[generate_trait]
    impl Internal of InternalTrait {
        fn _get_token_id(self: @ContractState) -> u256 {
            let erc721 = IERC721Dispatcher { contract_address: self._project.read().contract_address };
            let contract_address = get_contract_address();
            let balance = erc721.balanceOf(contract_address);
            if balance == 0_u256 {
                return 0_u256;
            }
            erc721.tokenOfOwnerByIndex(contract_address, 0_u256)
        }
        fn _deposit(ref self: ContractState, from_token_id: u256, to: ContractAddress, value: u256) {
            // [Effect] Store caller and total absorptions
            let caller = get_caller_address();
            let absorption = self.get_absorption_of(caller);
            self._absorption.write(caller, absorption);
            let total_absorption = self.get_total_absorption();
            self._total_absorption.write(total_absorption);

            // [Effect] Store caller and total sales
            let sale = self.get_sale_of(caller);
            self._sale.write(caller, sale);
            let total_sale = self.get_total_sale();
            self._total_sale.write(total_sale);

            // [Effect] Register the new caller value and the current timestamp
            let current_time = get_block_timestamp();
            let stored_value = self._registered_value.read(caller);
            self._registered_time.write(caller, current_time);
            self._registered_value.write(caller, stored_value + value);

            // [Effect] Register the new total value and the current timestamp
            let stored_total_value = self._total_registered_value.read();
            self._total_registered_time.write(current_time);
            self._total_registered_value.write(stored_total_value + value);

            // [Interaction] Transfer value from from_token_id to to_token_id
            let to_token_id = self._get_token_id();
            let project = self._project.read();
            IERC3525Dispatcher { contract_address: project.contract_address }.transferValueFrom(
                from_token_id,
                to_token_id,
                to,
                value
            );

            // [Event] Emit event
            self.emit(Event::Deposit(Deposit { address: caller, value: value, time: current_time }));
        }
        fn _withdraw(ref self: ContractState, to_token_id: u256, to: ContractAddress, value: u256) {
            // [Effect] Store caller and total absorptions
            let caller = get_caller_address();
            let absorption = self.get_absorption_of(caller);
            self._absorption.write(caller, absorption);
            let total_absorption = self.get_total_absorption();
            self._total_absorption.write(total_absorption);
            // [Effect] Store caller and total sales
            let sale = self.get_sale_of(caller);
            self._sale.write(caller, sale);
            let total_sale = self.get_total_sale();
            self._total_sale.write(total_sale);
            
            // [Check] Value is less than or equal to the registered values
            let current_time = get_block_timestamp();
            let stored_value = self._registered_value.read(caller);
            assert(value <= stored_value, 'Value exceeds internal balance');
            let stored_total_value = self._total_registered_value.read();
            assert(value <= stored_total_value, 'Value exceeds internal balance');
            // [Effect] Register the new caller value and the current timestamp
            self._registered_time.write(caller, current_time);
            self._registered_value.write(caller, stored_value - value);
            // [Effect] Register the new total value and current timestamp
            self._total_registered_time.write(current_time);
            self._total_registered_value.write(stored_total_value - value);

            // [Interaction] Transfer value from contract to caller
            let from_token_id = self._get_token_id();
            let project = self._project.read();
            IERC3525Dispatcher { contract_address: project.contract_address }.transferValueFrom(
                from_token_id,
                to_token_id,
                to,
                value
            );

            // [Event] Emit event
            self.emit(Event::Withdraw(Withdraw { address: caller, value: value, time: current_time }));
        }
        fn _compute_absorption(self: @ContractState, value: u256, start_time: u64, end_time: u64) -> u256 {
            // [Check] Value is not null, otherwise return 0
            if value == 0_u256 {
                return 0_u256;
            }

            // [Check] Project vlaue is not null, otherwise return 0
            let project = self._project.read();
            let slot = self._slot.read();
            let project_value = project.get_project_value(slot);
            if project_value == 0_u256 {
                return 0_u256;
            }

            // [Compute] Interpolated absorptions
            let initial_absorption = project.get_absorption(slot, start_time);
            let final_absorption = project.get_absorption(slot, end_time);

            // [Check] Overflow
            assert(initial_absorption <= final_absorption, 'Overflow');

            // [Compute] Absorption corresponding to the ratio
            value  * (final_absorption - initial_absorption).into() / project_value
        }
        fn _compute_sale(self: @ContractState, value: u256, start_time: u64, end_time: u64) -> u256 {
            // [Check] Value is not null, otherwise return 0
            if value == 0_u256 {
                return 0_u256;
            }

            // [Check] Project vlaue is not null, otherwise return 0
            let project = self._project.read();
            let slot = self._slot.read();
            let project_value = project.get_project_value(slot);
            if project_value == 0_u256 {
                return 0_u256;
            }

            // [Compute] Interpolated sales
            let (times, _, cumsales) = self._compute_cumsales();
            let initial_cumsale = interpolate(start_time.into(), @times, @cumsales, Interpolation::Linear(()), Extrapolation::Constant(()));
            let final_cumsale = interpolate(end_time.into(), @times, @cumsales, Interpolation::Linear(()), Extrapolation::Constant(()));

            // [Check] Overflow
            assert(initial_cumsale <= final_cumsale, 'Overflow');

            // [Compute] Total sale, if null then return 0
            if final_cumsale == initial_cumsale {
                return 0_u256;
            }
            // [Compute] Otherwise returns the sale corresponding to the ratio
            value  * (final_cumsale - initial_cumsale) / project_value
        }
        fn _compute_cumsales(self: @ContractState) -> (Array<u256>, Array<u256>, Array<u256>) {
            // [Check] Times are set
            let times = self._times.read();
            if times.len() == 0 {
                return (ArrayTrait::<u256>::new(), ArrayTrait::<u256>::new(), ArrayTrait::<u256>::new());
            }

            // [Check] Prices are set
            let prices = self._prices.read();
            if prices.len() == 0 {
                return (ArrayTrait::<u256>::new(), ArrayTrait::<u256>::new(), ArrayTrait::<u256>::new());
            }

            // [Compute] Sales
            let mut times_u256 = ArrayTrait::<u256>::new();
            let mut sales = ArrayTrait::<u256>::new();
            let mut updated_prices = ArrayTrait::<u256>::new();
            let mut index = 0;
            let project = self._project.read();
            let slot = self._slot.read();
            let mut absorption : u256 = 0;
            let mut negative_delta : u256 = 0;
            let mut positive_delta : u256 = 0;
            loop {
                // [Check] End criteria
                if index == times.len() {
                    break ();
                }

                // [Check] First iteration (special case)
                if index == 0 {
                    // [Compute] Interpolated absorptions
                    let start_time = project.get_start_time(slot);
                    let end_time = times.get(index).expect('Index out of bounds');
                    let price = prices.get(index).expect('Index out of bounds');
                    let initial_absorption = project.get_absorption(slot, start_time);
                    let final_absorption = project.get_absorption(slot, end_time);
                    let sale : u256 = (final_absorption - initial_absorption).into() * price;
                    sales.append(sale);
                    updated_prices.append(price);
                }

                // [Compute] Interpolated absorptions
                let start_time = times.get(index - 1).expect('Index out of bounds');
                let end_time = times.get(index).expect('Index out of bounds');
                let price = prices.get(index).expect('Index out of bounds');
                let initial_absorption = project.get_absorption(slot, start_time);
                let final_absorption = project.get_absorption(slot, end_time);

                // [Check] Absorption is not null
                assert(initial_absorption < final_absorption, 'No absorption');
                let new_absorption : u256 = (final_absorption - initial_absorption).into();

                // [Compute] Delta to compensate from the previous sale
                let real_sale = absorption * price;
                let previous_sale = *sales.at(index - 1);
                if real_sale > previous_sale {
                    positive_delta += real_sale - previous_sale;
                } else {
                    negative_delta += real_sale - previous_sale;
                }
                let add_price = positive_delta / new_absorption;
                let sub_price = negative_delta / new_absorption;

                // [Compute] Update price, drop to zero if negative
                let mut updated_price = 0;
                if sub_price < price + add_price {
                    let updated_price = price + add_price - sub_price;
                }
                let updated_price = price * (positive_delta + 1) / (negative_delta + 1);

                // [Compute] Store results and update variables for the next iter
                times_u256.append(end_time.into());
                sales.append(new_absorption * updated_price);
                updated_prices.append(updated_price);
                absorption = new_absorption;
                index += 1;
            };
            let cumsales = cumsum(@sales);
            (times_u256, updated_prices, cumsales)
        }
    }
}
