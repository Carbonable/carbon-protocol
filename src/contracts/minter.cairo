use starknet::ContractAddress;

#[starknet::contract]
mod Minter {
    use starknet::{get_caller_address, ContractAddress, ClassHash};

    // Ownable
    use openzeppelin::access::ownable::interface::IOwnable;
    use openzeppelin::access::ownable::ownable::Ownable;

    // Upgradable
    use openzeppelin::upgrades::interface::IUpgradeable;
    use openzeppelin::upgrades::upgradeable::Upgradeable;

    // Mint
    use carbon::components::mint::interface::{IMint, IL1Mint, IL1Handler};
    use carbon::components::mint::module::Mint;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(
        ref self: ContractState,
        carbonable_project_address: ContractAddress,
        carbonable_project_slot: u256,
        payment_token_address: ContractAddress,
        public_sale_open: bool,
        max_value_per_tx: u256,
        min_value_per_tx: u256,
        max_value: u256,
        unit_price: u256,
        reserved_value: u256,
        owner: ContractAddress
    ) {
        self
            .initializer(
                carbonable_project_address,
                carbonable_project_slot,
                payment_token_address,
                public_sale_open,
                max_value_per_tx,
                min_value_per_tx,
                max_value,
                unit_price,
                reserved_value,
                owner
            );
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

    // Access control

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

    // Externals

    #[external(v0)]
    impl MintImpl of IMint<ContractState> {
        fn get_carbonable_project_address(self: @ContractState) -> ContractAddress {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_carbonable_project_address(@unsafe_state)
        }

        fn get_carbonable_project_slot(self: @ContractState) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_carbonable_project_slot(@unsafe_state)
        }

        fn get_payment_token_address(self: @ContractState) -> ContractAddress {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_payment_token_address(@unsafe_state)
        }

        fn is_pre_sale_open(self: @ContractState) -> bool {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::is_pre_sale_open(@unsafe_state)
        }

        fn is_public_sale_open(self: @ContractState) -> bool {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::is_public_sale_open(@unsafe_state)
        }

        fn get_min_value_per_tx(self: @ContractState) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_min_value_per_tx(@unsafe_state)
        }

        fn get_max_value_per_tx(self: @ContractState) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_max_value_per_tx(@unsafe_state)
        }

        fn get_unit_price(self: @ContractState) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_unit_price(@unsafe_state)
        }

        fn get_reserved_value(self: @ContractState) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_reserved_value(@unsafe_state)
        }

        fn get_remaining_value(self: @ContractState) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_remaining_value(@unsafe_state)
        }

        fn get_whitelist_merkle_root(self: @ContractState) -> felt252 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_whitelist_merkle_root(@unsafe_state)
        }
        fn get_whitelist_allocation(
            self: @ContractState,
            account: ContractAddress,
            allocation: felt252,
            proof: Span<felt252>
        ) -> felt252 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_whitelist_allocation(@unsafe_state, account, allocation, proof)
        }

        fn get_claimed_value(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::get_claimed_value(@unsafe_state, account)
        }

        fn is_sold_out(self: @ContractState) -> bool {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::is_sold_out(@unsafe_state)
        }

        fn set_whitelist_merkle_root(ref self: ContractState, whitelist_merkle_root: felt252) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set whitelist merkle root
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::set_whitelist_merkle_root(ref unsafe_state, whitelist_merkle_root)
        }

        fn set_public_sale_open(ref self: ContractState, public_sale_open: bool) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set public sale open
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::set_public_sale_open(ref unsafe_state, public_sale_open)
        }

        fn set_max_value_per_tx(ref self: ContractState, max_value_per_tx: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set max value per tx
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::set_max_value_per_tx(ref unsafe_state, max_value_per_tx)
        }

        fn set_min_value_per_tx(ref self: ContractState, min_value_per_tx: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set min value per tx
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::set_min_value_per_tx(ref unsafe_state, min_value_per_tx)
        }

        fn set_unit_price(ref self: ContractState, unit_price: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set unit price
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::set_unit_price(ref unsafe_state, unit_price)
        }

        fn decrease_reserved_value(ref self: ContractState, value: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Decrease reserved value
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::decrease_reserved_value(ref unsafe_state, value)
        }

        fn airdrop(ref self: ContractState, to: ContractAddress, value: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Airdrop
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::airdrop(ref unsafe_state, to, value)
        }

        fn withdraw(ref self: ContractState) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Withdraw
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::withdraw(ref unsafe_state)
        }

        fn transfer(
            ref self: ContractState,
            token_address: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Transfer
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::transfer(ref unsafe_state, token_address, recipient, amount)
        }

        fn prebook(
            ref self: ContractState,
            allocation: felt252,
            proof: Span<felt252>,
            value: u256,
            force: bool
        ) {
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::prebook(ref unsafe_state, allocation, proof, value, force)
        }

        fn book(ref self: ContractState, value: u256, force: bool) {
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::book(ref unsafe_state, value, force)
        }

        fn claim(ref self: ContractState, user_address: ContractAddress, id: u32) {
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::claim(ref unsafe_state, user_address, id)
        }

        fn refund(ref self: ContractState, user_address: ContractAddress, id: u32) {
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::refund(ref unsafe_state, user_address, id)
        }

        fn refund_to(
            ref self: ContractState, to: ContractAddress, user_address: ContractAddress, id: u32
        ) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Refund to address
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::MintImpl::refund_to(ref unsafe_state, to, user_address, id)
        }
    }

    #[external(v0)]
    impl L1MintImpl of IL1Mint<ContractState> {
        fn get_l1_minter_address(self: @ContractState) -> ContractAddress {
            let unsafe_state = Mint::unsafe_new_contract_state();
            Mint::L1MintImpl::get_l1_minter_address(@unsafe_state)
        }

        fn set_l1_minter_address(ref self: ContractState, l1_address: ContractAddress) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set L1 minter address
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::L1MintImpl::set_l1_minter_address(ref unsafe_state, l1_address)
        }
    }

    #[l1_handler]
    impl L1HandlerImpl of IL1Handler<ContractState> {
        fn book_from_l1(
            ref self: ContractState,
            from_address: ContractAddress,
            user_address: ContractAddress,
            value: u256,
            amount: u256,
        ) {
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::L1HandlerImpl::book_from_l1(
                ref unsafe_state, from_address, user_address, value, amount
            )
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState,
            carbonable_project_address: ContractAddress,
            carbonable_project_slot: u256,
            payment_token_address: ContractAddress,
            public_sale_open: bool,
            max_value_per_tx: u256,
            min_value_per_tx: u256,
            max_value: u256,
            unit_price: u256,
            reserved_value: u256,
            owner: ContractAddress
        ) {
            // Access control
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::initializer(ref unsafe_state, owner);

            // Mint
            let mut unsafe_state = Mint::unsafe_new_contract_state();
            Mint::InternalImpl::initializer(
                ref unsafe_state,
                carbonable_project_address,
                carbonable_project_slot,
                payment_token_address,
                public_sale_open,
                max_value_per_tx,
                min_value_per_tx,
                max_value,
                unit_price,
                reserved_value
            );
        }
    }
}
