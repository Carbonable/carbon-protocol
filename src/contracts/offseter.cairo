#[starknet::contract]
mod Offseter {
    use starknet::{get_caller_address, ContractAddress, ClassHash};

    // Ownable
    use openzeppelin::access::ownable::interface::IOwnable;
    use openzeppelin::access::ownable::ownable::Ownable;

    // Upgradable
    use openzeppelin::upgrades::interface::IUpgradeable;
    use openzeppelin::upgrades::upgradeable::Upgradeable;

    // Security
    use openzeppelin::security::pausable::{Pausable, IPausable};
    use openzeppelin::security::reentrancyguard::ReentrancyGuard;

    // SRC5
    use openzeppelin::introspection::interface::{ISRC5, ISRC5Camel};
    use openzeppelin::introspection::src5::SRC5;

    // Farm
    use carbon::components::farm::interface::IFarm;
    use carbon::components::farm::module::Farm;

    // Offset
    use carbon::components::offset::interface::IOffset;
    use carbon::components::offset::module::Offset;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(
        ref self: ContractState, project: ContractAddress, slot: u256, owner: ContractAddress,
    ) {
        self.initializer(project, slot, owner);
    }

    // Upgradable

    #[external(v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, impl_hash: ClassHash) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Upgrade
            let mut unsafe_state = Upgradeable::unsafe_new_contract_state();
            Upgradeable::InternalImpl::_upgrade(ref unsafe_state, impl_hash)
        }
    }

    // Ownable

    #[external(v0)]
    impl OwnableImpl of IOwnable<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::OwnableImpl::owner(@unsafe_state)
        }

        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::OwnableImpl::transfer_ownership(ref unsafe_state, new_owner)
        }

        fn renounce_ownership(ref self: ContractState) {
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::OwnableImpl::renounce_ownership(ref unsafe_state)
        }
    }

    // Pausable

    #[external(v0)]
    impl PausableImpl of IPausable<ContractState> {
        fn is_paused(self: @ContractState) -> bool {
            let unsafe_state = Pausable::unsafe_new_contract_state();
            Pausable::PausableImpl::is_paused(@unsafe_state)
        }
    }

    #[external(v0)]
    #[generate_trait]
    impl PausableExtraImpl of PausableTrait {
        fn pause(ref self: ContractState) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Check] Not paused
            let mut unsafe_state = Pausable::unsafe_new_contract_state();
            Pausable::InternalImpl::assert_not_paused(@unsafe_state);
            // [Effect] Pause
            Pausable::InternalImpl::_pause(ref unsafe_state)
        }

        fn unpause(ref self: ContractState) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Check] Paused
            let mut unsafe_state = Pausable::unsafe_new_contract_state();
            Pausable::InternalImpl::assert_paused(@unsafe_state);
            // [Effect] Unpause
            Pausable::InternalImpl::_unpause(ref unsafe_state)
        }
    }

    // SRC5

    #[external(v0)]
    impl SRC5Impl of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            let unsafe_state = SRC5::unsafe_new_contract_state();
            SRC5::SRC5Impl::supports_interface(@unsafe_state, interface_id)
        }
    }

    #[external(v0)]
    impl SRC5CamelImpl of ISRC5Camel<ContractState> {
        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            self.supports_interface(interfaceId)
        }
    }

    // Farming

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
            // [Security] ReentrancyGuard
            let mut unsafe_rg_state = ReentrancyGuard::unsafe_new_contract_state();
            ReentrancyGuard::InternalImpl::start(ref unsafe_rg_state);
            // [Effect] Deposit
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::deposit(ref unsafe_state, token_id, value);
            // [Security] ReentrancyGuard
            ReentrancyGuard::InternalImpl::end(ref unsafe_rg_state);
        }

        fn withdraw_to(ref self: ContractState, value: u256) {
            // [Security] ReentrancyGuard
            let mut unsafe_rg_state = ReentrancyGuard::unsafe_new_contract_state();
            ReentrancyGuard::InternalImpl::start(ref unsafe_rg_state);
            // [Effect] Withdraw
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::withdraw_to(ref unsafe_state, value);
            // [Security] ReentrancyGuard
            ReentrancyGuard::InternalImpl::end(ref unsafe_rg_state);
        }

        fn withdraw_to_token(ref self: ContractState, token_id: u256, value: u256) {
            // [Security] ReentrancyGuard
            let mut unsafe_rg_state = ReentrancyGuard::unsafe_new_contract_state();
            ReentrancyGuard::InternalImpl::start(ref unsafe_rg_state);
            // [Effect] Withdraw
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::withdraw_to_token(ref unsafe_state, token_id, value);
            // [Security] ReentrancyGuard
            ReentrancyGuard::InternalImpl::end(ref unsafe_rg_state);
        }

        fn add_price(ref self: ContractState, time: u64, price: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Add price
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::add_price(ref unsafe_state, time, price);
        }

        fn update_last_price(ref self: ContractState, time: u64, price: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Update last price
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::update_last_price(ref unsafe_state, time, price);
        }

        fn set_prices(ref self: ContractState, times: Span<u64>, prices: Span<u256>) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set prices
            let mut unsafe_state = Farm::unsafe_new_contract_state();
            Farm::FarmImpl::set_prices(ref unsafe_state, times, prices);
        }
    }

    // Offset

    #[external(v0)]
    impl OffsetImpl of IOffset<ContractState> {
        fn get_total_claimable(self: @ContractState) -> u256 {
            let unsafe_state = Offset::unsafe_new_contract_state();
            Offset::OffsetImpl::get_total_claimable(@unsafe_state)
        }

        fn get_total_claimed(self: @ContractState) -> u256 {
            let unsafe_state = Offset::unsafe_new_contract_state();
            Offset::OffsetImpl::get_total_claimed(@unsafe_state)
        }

        fn get_claimable_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Offset::unsafe_new_contract_state();
            Offset::OffsetImpl::get_claimable_of(@unsafe_state, account)
        }

        fn get_claimed_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Offset::unsafe_new_contract_state();
            Offset::OffsetImpl::get_claimed_of(@unsafe_state, account)
        }

        fn claim(ref self: ContractState, amount: u256) {
            // [Security] ReentrancyGuard
            let mut unsafe_rg_state = ReentrancyGuard::unsafe_new_contract_state();
            ReentrancyGuard::InternalImpl::start(ref unsafe_rg_state);
            // [Effect] Claim
            let mut unsafe_state = Offset::unsafe_new_contract_state();
            Offset::OffsetImpl::claim(ref unsafe_state, amount);
            // [Security] ReentrancyGuard
            ReentrancyGuard::InternalImpl::end(ref unsafe_rg_state);
        }

        fn claim_all(ref self: ContractState) {
            // [Security] ReentrancyGuard
            let mut unsafe_rg_state = ReentrancyGuard::unsafe_new_contract_state();
            ReentrancyGuard::InternalImpl::start(ref unsafe_rg_state);
            // [Effect] Claim
            let mut unsafe_state = Offset::unsafe_new_contract_state();
            Offset::OffsetImpl::claim_all(ref unsafe_state);
            // [Security] ReentrancyGuard
            ReentrancyGuard::InternalImpl::end(ref unsafe_rg_state);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState, project: ContractAddress, slot: u256, owner: ContractAddress,
        ) {
            // [Check] Inputs
            assert(!owner.is_zero(), 'Owner cannot be 0');

            // [Effect] Ownable control
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::initializer(ref unsafe_state, owner);
            // [Effect] Offset
            let mut unsafe_state = Offset::unsafe_new_contract_state();
            Offset::InternalImpl::initializer(ref unsafe_state, project, slot);
        }
    }
}
