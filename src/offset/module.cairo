#[starknet::contract]
mod Offset {
    use starknet::{get_caller_address, get_block_timestamp, ContractAddress};
    use debug::PrintTrait;

    // ERC20
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};

    // Farm
    use protocol::farm::interface::IFarm;
    use protocol::farm::module::Farm;

    // Offset
    use protocol::offset::interface::IOffset;

    #[storage]
    struct Storage {
        _total_claimed: u256,
        _claimed: LegacyMap::<ContractAddress, u256>,
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
    fn constructor(ref self: ContractState, project: ContractAddress, slot: u256) {
        self.initializer(project, slot);
    }

    #[external(v0)]
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

        fn get_total_sale(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_total_sale(@unsafe_state)
        }

        fn get_max_sale(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_max_sale(@unsafe_state)
        }

        fn get_deposited_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_deposited_of(@unsafe_state, account)
        }

        fn get_absorption_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_absorption_of(@unsafe_state, account)
        }

        fn get_sale_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_sale_of(@unsafe_state, account)
        }

        fn get_current_price(self: @ContractState) -> u256 {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_current_price(@unsafe_state)
        }

        fn get_prices(self: @ContractState) -> (Span<u64>, Span<u256>) {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_prices(@unsafe_state)
        }

        fn get_cumsales(self: @ContractState) -> (Span<u64>, Span<u256>, Span<u256>) {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_cumsales(@unsafe_state)
        }

        fn get_apr(self: @ContractState, minter: ContractAddress) -> (u256, u256) {
            let unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::get_apr(@unsafe_state, minter)
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

        fn add_price(ref self: ContractState, time: u64, price: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::add_price(ref unsafe_state, time, price);
        }

        fn update_last_price(ref self: ContractState, time: u64, price: u256) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::update_last_price(ref unsafe_state, time, price);
        }

        fn set_prices(ref self: ContractState, times: Span<u64>, prices: Span<u256>) {
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::set_prices(ref unsafe_state, times, prices);
        }
    }

    #[external(v0)]
    impl OffsetImpl of IOffset<ContractState> {
        fn get_total_claimable(self: @ContractState) -> u256 {
            let total_absorption = self.get_total_absorption();
            let claimed = self._total_claimed.read();
            total_absorption + claimed
        }

        fn get_total_claimed(self: @ContractState) -> u256 {
            self._total_claimed.read()
        }

        fn get_claimable_of(self: @ContractState, account: ContractAddress) -> u256 {
            let absorption = self.get_absorption_of(account);
            let claimed = self._claimed.read(account);
            absorption - claimed
        }

        fn get_claimed_of(self: @ContractState, account: ContractAddress) -> u256 {
            self._claimed.read(account)
        }

        fn claim(ref self: ContractState, amount: u256) {
            // [Check] Check amount
            let caller = get_caller_address();
            let claimable = self.get_claimable_of(caller);
            assert(amount <= claimable, 'Claim amount is too high');

            // [Effect] Update user claimed
            let stored_amount = self._claimed.read(caller);
            self._claimed.write(caller, stored_amount + amount);

            // [Effect] Update total claimed
            let total_claimed = self._total_claimed.read();
            self._total_claimed.write(total_claimed + amount);

            // [Event] Emit event
            let current_time = get_block_timestamp();
            self.emit(Event::Claim(Claim { address: caller, amount: amount, time: current_time }));
        }

        fn claim_all(ref self: ContractState) {
            // [Effect] Claim max amount
            let caller = get_caller_address();
            let amount = self.get_claimable_of(caller);
            self.claim(amount);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(ref self: ContractState, project: ContractAddress, slot: u256) {
            // [Effect] Initialize farm
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::InternalImpl::initializer(ref unsafe_state, project, slot);
        }
    }
}
