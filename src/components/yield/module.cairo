#[starknet::contract]
mod Yield {
    use starknet::{get_caller_address, get_block_timestamp, ContractAddress};
    use debug::PrintTrait;

    // ERC20
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};

    // Farm
    use carbon::components::farm::interface::{IFarm, IYieldFarm};
    use carbon::components::farm::module::Farm;

    // Yield
    use carbon::components::yield::interface::IYield;

    #[storage]
    struct Storage {
        _yield_erc20: IERC20CamelDispatcher,
        _yield_total_claimed: u256,
        _yield_claimed: LegacyMap::<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Claim: Claim,
    }

    #[derive(Drop, starknet::Event)]
    struct Claim {
        address: ContractAddress,
        amount: u256,
        time: u64,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, project: ContractAddress, slot: u256, erc20: ContractAddress
    ) {
        self.initializer(project, slot, erc20);
    }

    impl FarmImpl of IFarm<ContractState> {
        fn get_carbonable_project_address(self: @ContractState) -> ContractAddress {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_carbonable_project_address(@unsafe_state)
        }

        fn get_carbonable_project_slot(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_carbonable_project_slot(@unsafe_state)
        }

        fn get_total_deposited(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_total_deposited(@unsafe_state)
        }

        fn get_total_absorption(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_total_absorption(@unsafe_state)
        }

        fn get_max_absorption(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_max_absorption(@unsafe_state)
        }

        fn get_deposited_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_deposited_of(@unsafe_state, account)
        }

        fn get_absorption_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_absorption_of(@unsafe_state, account)
        }

        fn deposit(ref self: ContractState, token_id: u256, value: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::deposit(ref unsafe_state, token_id, value);
        }

        fn withdraw_to(ref self: ContractState, value: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::withdraw_to(ref unsafe_state, value);
        }

        fn withdraw_to_token(ref self: ContractState, token_id: u256, value: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::withdraw_to_token(ref unsafe_state, token_id, value);
        }
    }

    impl YieldFarmImpl of IYieldFarm<ContractState> {
        fn get_total_sale(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_total_sale(@unsafe_state)
        }

        fn get_max_sale(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_max_sale(@unsafe_state)
        }

        fn get_sale_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_sale_of(@unsafe_state, account)
        }

        fn get_current_price(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_current_price(@unsafe_state)
        }

        fn get_prices(self: @ContractState) -> (Span<u64>, Span<u256>) {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_prices(@unsafe_state)
        }

        fn get_cumsales(self: @ContractState) -> (Span<u64>, Span<u256>, Span<u256>) {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_cumsales(@unsafe_state)
        }

        fn get_apr(self: @ContractState, minter: ContractAddress) -> (u256, u256) {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::get_apr(@unsafe_state, minter)
        }

        fn add_price(ref self: ContractState, time: u64, price: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::add_price(ref unsafe_state, time, price);
        }

        fn update_last_price(ref self: ContractState, time: u64, price: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::update_last_price(ref unsafe_state, time, price);
        }

        fn set_prices(ref self: ContractState, times: Span<u64>, prices: Span<u256>) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::YieldFarmImpl::set_prices(ref unsafe_state, times, prices);
        }
    }

    impl YieldImpl of IYield<ContractState> {
        fn get_payment_token_address(self: @ContractState) -> ContractAddress {
            self._yield_erc20.read().contract_address
        }

        fn get_total_claimable(self: @ContractState) -> u256 {
            let total_sale = self.get_total_sale();
            let claimed = self._yield_total_claimed.read();
            total_sale + claimed
        }

        fn get_total_claimed(self: @ContractState) -> u256 {
            self._yield_total_claimed.read()
        }

        fn get_claimable_of(self: @ContractState, account: ContractAddress) -> u256 {
            let sale = self.get_sale_of(account);
            let claimed = self._yield_claimed.read(account);
            sale - claimed
        }

        fn get_claimed_of(self: @ContractState, account: ContractAddress) -> u256 {
            self._yield_claimed.read(account)
        }

        fn claim(ref self: ContractState) {
            // [Effect] Update user claimed
            let caller = get_caller_address();
            let amount = self.get_claimable_of(caller);
            let stored_amount = self._yield_claimed.read(caller);
            self._yield_claimed.write(caller, stored_amount + amount);

            // [Effect] Update total claimed
            let total_claimed = self._yield_total_claimed.read();
            self._yield_total_claimed.write(total_claimed + amount);

            // [Interaction] ERC20 transfer
            let erc20 = self._yield_erc20.read();
            let success = erc20.transfer(caller, amount);

            // [Check] Transfer successful
            assert(success, 'Transfer failed');

            // [Event] Emit event
            let current_time = get_block_timestamp();
            self.emit(Event::Claim(Claim { address: caller, amount: amount, time: current_time }));
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState, project: ContractAddress, slot: u256, erc20: ContractAddress
        ) {
            // [Effect] Initialize farm
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::InternalImpl::initializer(ref unsafe_state, project, slot);
            // [Effect] Initialize yield
            self._yield_erc20.write(IERC20CamelDispatcher { contract_address: erc20 });
        }
    }
}
