#[starknet::contract]
mod Mint {
    use zeroable::Zeroable;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use array::{Array, ArrayTrait};
    use debug::PrintTrait;
    use hash::HashStateTrait;
    use poseidon::PoseidonTrait;

    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};

    use alexandria_data_structures::merkle_tree::{
        Hasher, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait,
    };

    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
    use cairo_erc_3525::interface::{IERC3525Dispatcher, IERC3525DispatcherTrait};

    use carbon::components::mint::interface::IMint;
    use carbon::components::absorber::interface::{IAbsorberDispatcher, IAbsorberDispatcherTrait};
    use carbon::contracts::project::{
        IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };

    #[storage]
    struct Storage {
        _mint_carbonable_project_address: ContractAddress,
        _mint_carbonable_project_slot: u256,
        _mint_payment_token_address: ContractAddress,
        _mint_public_sale_open: bool,
        _mint_max_value_per_tx: u256,
        _mint_min_value_per_tx: u256,
        _mint_max_value: u256,
        _mint_unit_price: u256,
        _mint_reserved_value: u256,
        _mint_whitelist_merkle_root: felt252,
        _mint_claimed_value: LegacyMap<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PreSaleOpen: PreSaleOpen,
        PreSaleClose: PreSaleClose,
        PublicSaleOpen: PublicSaleOpen,
        PublicSaleClose: PublicSaleClose,
        SoldOut: SoldOut,
        Airdrop: Airdrop,
        Buy: Buy,
    }

    #[derive(Drop, starknet::Event)]
    struct PreSaleOpen {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PreSaleClose {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PublicSaleOpen {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct PublicSaleClose {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct SoldOut {
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct Airdrop {
        to: ContractAddress,
        value: u256,
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct Buy {
        address: ContractAddress,
        value: u256,
        time: u64
    }

    impl MintImpl of IMint<ContractState> {
        fn get_carbonable_project_address(self: @ContractState) -> ContractAddress {
            self._mint_carbonable_project_address.read()
        }

        fn get_carbonable_project_slot(self: @ContractState) -> u256 {
            self._mint_carbonable_project_slot.read()
        }

        fn get_payment_token_address(self: @ContractState) -> ContractAddress {
            self._mint_payment_token_address.read()
        }

        fn is_pre_sale_open(self: @ContractState) -> bool {
            let merkle_root = self._mint_whitelist_merkle_root.read();
            merkle_root != 0
        }

        fn is_public_sale_open(self: @ContractState) -> bool {
            self._mint_public_sale_open.read()
        }

        fn get_min_value_per_tx(self: @ContractState) -> u256 {
            self._mint_min_value_per_tx.read()
        }

        fn get_max_value_per_tx(self: @ContractState) -> u256 {
            self._mint_max_value_per_tx.read()
        }

        fn get_unit_price(self: @ContractState) -> u256 {
            self._mint_unit_price.read()
        }

        fn get_reserved_value(self: @ContractState) -> u256 {
            self._mint_reserved_value.read()
        }

        fn get_max_value(self: @ContractState) -> u256 {
            self._mint_max_value.read()
        }

        fn get_whitelist_merkle_root(self: @ContractState) -> felt252 {
            self._mint_whitelist_merkle_root.read()
        }

        fn get_whitelist_allocation(
            self: @ContractState,
            account: ContractAddress,
            allocation: felt252,
            proof: Span<felt252>
        ) -> felt252 {
            let root = self._mint_whitelist_merkle_root.read();
            let mut state = PoseidonTrait::new();
            state = state.update(account.into());
            state = state.update(allocation);
            let leaf = state.finalize();
            let mut tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
            let whitelisted = tree.verify(root, leaf, proof);
            allocation * if whitelisted {
                1
            } else {
                0
            }
        }

        fn get_claimed_value(self: @ContractState, account: ContractAddress) -> u256 {
            self._mint_claimed_value.read(account)
        }

        fn is_sold_out(self: @ContractState) -> bool {
            let project_address = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let max_value = IAbsorberDispatcher { contract_address: project_address }
                .get_project_value(slot);
            let reserved_value = self._mint_reserved_value.read();
            let total_value = IProjectDispatcher { contract_address: project_address }
                .total_value(slot);
            total_value + reserved_value >= max_value
        }

        fn set_whitelist_merkle_root(ref self: ContractState, whitelist_merkle_root: felt252) {
            // [Effect] Update storage
            self._mint_whitelist_merkle_root.write(whitelist_merkle_root);

            // [Event] Emit event
            let current_time = get_block_timestamp();
            if whitelist_merkle_root != 0 {
                self.emit(Event::PreSaleOpen(PreSaleOpen { time: current_time }));
            } else {
                self.emit(Event::PreSaleClose(PreSaleClose { time: current_time }));
            };
        }

        fn set_public_sale_open(ref self: ContractState, public_sale_open: bool) {
            // [Effect] Update storage
            self._mint_public_sale_open.write(public_sale_open);

            // [Event] Emit event
            let current_time = get_block_timestamp();
            if public_sale_open {
                self.emit(Event::PublicSaleOpen(PublicSaleOpen { time: current_time }));
            } else {
                self.emit(Event::PublicSaleClose(PublicSaleClose { time: current_time }));
            };
        }

        fn set_max_value_per_tx(ref self: ContractState, max_value_per_tx: u256) {
            // [Check] Value in range
            let max_value = self._mint_max_value.read();
            assert(max_value_per_tx <= max_value, 'Invalid max value per tx');
            let min_value_per_tx = self._mint_min_value_per_tx.read();
            assert(max_value_per_tx >= min_value_per_tx, 'Invalid max value per tx');
            // [Effect] Store value
            self._mint_max_value_per_tx.write(max_value_per_tx);
        }

        fn set_min_value_per_tx(ref self: ContractState, min_value_per_tx: u256) {
            // [Check] Value in range
            let max_value_per_tx = self._mint_max_value_per_tx.read();
            assert(max_value_per_tx >= min_value_per_tx, 'Invalid min value per tx');
            // [Effect] Store value
            self._mint_min_value_per_tx.write(min_value_per_tx);
        }

        fn set_unit_price(ref self: ContractState, unit_price: u256) {
            // [Check] Value not null
            assert(unit_price > 0, 'Invalid unit price');
            // [Effect] Store value
            self._mint_unit_price.write(unit_price);
        }

        fn decrease_reserved_value(ref self: ContractState, value: u256) {
            // [Check] Value not null
            assert(value > 0, 'Invalid value');
            // [Check] Enough reserved value available
            let reserved_value = self._mint_reserved_value.read();
            assert(reserved_value >= value, 'Not enough reserved value');
            // [Effect] Update reserved value
            self._mint_reserved_value.write(reserved_value - value);
        }

        fn airdrop(ref self: ContractState, to: ContractAddress, value: u256) {
            // [Check] Caller is not null
            let caller_address = get_caller_address();
            assert(!caller_address.is_zero(), 'Invalid caller');

            // [Check] Value not null
            assert(value > 0, 'Invalid value');

            // [Check] Enough value available
            let project_address = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let project = IProjectDispatcher { contract_address: project_address };
            let total_value = project.total_value(slot);
            let absorber = IAbsorberDispatcher { contract_address: project_address };
            let project_value = absorber.get_project_value(slot);
            assert(total_value + value <= project_value, 'Not enough value');

            // [Check] Enough reserved value available
            let reserved_value = self._mint_reserved_value.read();
            assert(value <= reserved_value, 'Not enough reserved value');

            // [Effect] Update reserved value
            self._mint_reserved_value.write(reserved_value - value);

            // [Interaction] Mint
            project.mint(to, slot, value);

            // [Event] Emit event
            let current_time = get_block_timestamp();
            self.emit(Event::Airdrop(Airdrop { to: to, value: value, time: current_time }));
        }

        fn withdraw(ref self: ContractState) {
            // [Compute] Balance to withdraw
            let token_address = self._mint_payment_token_address.read();
            let erc20 = IERC20CamelDispatcher { contract_address: token_address };
            let contract_address = get_contract_address();
            let balance = erc20.balanceOf(contract_address);

            // [Interaction] Transfer tokens
            let caller_address = get_caller_address();
            let success = erc20.transfer(caller_address, balance);
            assert(success, 'Transfer failed');
        }

        fn transfer(
            ref self: ContractState,
            token_address: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {
            let erc20 = IERC20CamelDispatcher { contract_address: token_address };
            let success = erc20.transfer(recipient, amount);
            assert(success, 'Transfer failed');
        }

        fn pre_buy(
            ref self: ContractState,
            allocation: felt252,
            proof: Span<felt252>,
            value: u256,
            force: bool
        ) {
            // [Check] Pre sale is open
            let merkle_root = self._mint_whitelist_merkle_root.read();
            assert(merkle_root != 0, 'Pre sale is closed');

            // [Check] Caller is whitelisted
            let caller_address = get_caller_address();
            let allocation = self.get_whitelist_allocation(caller_address, allocation, proof);
            assert(allocation.into() > 0_u256, 'Caller is not whitelisted');

            // [Check] Enough allocation value available
            let claimed_value = self._mint_claimed_value.read(caller_address);
            assert(claimed_value + value <= allocation.into(), 'Not enough allocation value');

            // [Interaction] Buy
            let minted_value = self.buy(value, force);

            // [Effect] Update claimed value
            self._mint_claimed_value.write(caller_address, claimed_value + minted_value);
        }

        fn public_buy(ref self: ContractState, value: u256, force: bool) {
            // [Check] Public sale is open
            let public_sale_open = self._mint_public_sale_open.read();
            assert(public_sale_open, 'Sale is closed');

            // [Interaction] Buy
            self.buy(value, force);
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
        ) {
            // [Check] Input consistency
            assert(max_value_per_tx > 0, 'Invalid max value per tx');
            assert(min_value_per_tx > 0, 'Invalid min value per tx');
            assert(max_value_per_tx >= min_value_per_tx, 'Invalid max/min value per tx');
            assert(max_value_per_tx <= max_value, 'Invalid max value');
            assert(unit_price > 0, 'Invalid unit price');
            assert(reserved_value <= max_value, 'Invalid reserved value');

            // [Effect] Update storage
            self._mint_carbonable_project_address.write(carbonable_project_address);
            self._mint_carbonable_project_slot.write(carbonable_project_slot);

            // [Check] Max value is valid
            let remaining_value = self.project_remaining_value();
            assert(max_value <= remaining_value, 'Invalid max value');

            // [Effect] Update storage
            self._mint_payment_token_address.write(payment_token_address);
            self._mint_max_value_per_tx.write(max_value_per_tx);
            self._mint_min_value_per_tx.write(min_value_per_tx);
            self._mint_max_value.write(max_value);
            self._mint_unit_price.write(unit_price);
            self._mint_reserved_value.write(reserved_value);

            // [Effect] Use dedicated function to emit corresponding events
            self.set_public_sale_open(public_sale_open);
        }

        fn buy(ref self: ContractState, value: u256, force: bool) -> u256 {
            // [Check] Value not null
            assert(value > 0, 'Invalid value');

            // [Check] Caller is not zero
            let caller_address = get_caller_address();
            assert(!caller_address.is_zero(), 'Invalid caller');

            // [Check] Allowed value
            let min_value_per_tx = self._mint_min_value_per_tx.read();
            assert(value >= min_value_per_tx, 'Value too low');
            let max_value_per_tx = self._mint_max_value_per_tx.read();
            assert(value <= max_value_per_tx, 'Value too high');

            // [Compute] If remaining value is lower than specified value and force is enabled
            // Then replace the specified value by the remaining value otherwize keep the value unchanged
            let max_value = self._mint_max_value.read();
            let reserved_value = self._mint_reserved_value.read();
            let available_value = max_value - reserved_value;

            let project_address = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let project = IProjectDispatcher { contract_address: project_address };
            let total_value = project.total_value(slot);
            let remaining_value = available_value - total_value;

            let value = if remaining_value < value && force {
                remaining_value
            } else {
                value
            };

            // [Check] Value after buy
            assert(value <= remaining_value, 'Not enough value');

            // [Interaction] Pay
            let unit_price = self._mint_unit_price.read();
            let amount = value * unit_price;
            let token_address = self._mint_payment_token_address.read();
            let erc20 = IERC20CamelDispatcher { contract_address: token_address };
            let contract_address = get_contract_address();
            let success = erc20.transferFrom(caller_address, contract_address, amount);

            // [Check] Transfer successful
            assert(success, 'Transfer failed');

            // [Interaction] Mint
            project.mint(caller_address, slot, value);

            // [Event] Emit event
            let current_time = get_block_timestamp();
            self
                .emit(
                    Event::Buy(Buy { address: caller_address, value: value, time: current_time })
                );

            // [Effect] Close the sale if sold out
            if self.is_sold_out() {
                // [Effect] Close pre sale
                self.set_whitelist_merkle_root(0);

                // [Effect] Close public sale
                self.set_public_sale_open(false);

                // [Event] Emit sold out event
                self.emit(Event::SoldOut(SoldOut { time: current_time }));
            };

            // [Return] Value
            value
        }

        fn project_remaining_value(self: @ContractState) -> u256 {
            // [Compute] Total remaining value
            let project_address = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let project = IProjectDispatcher { contract_address: project_address };
            let total_value = project.total_value(slot);
            let absorber = IAbsorberDispatcher { contract_address: project_address };
            let project_value = absorber.get_project_value(slot);
            project_value - total_value
        }
    }
}


#[cfg(test)]
mod Test {
    use array::ArrayTrait;
    use traits::TryInto;
    use starknet::ContractAddress;
    use starknet::testing::set_block_timestamp;
    use super::Mint;
    use super::Mint::_mint_max_value_per_tx::InternalContractMemberStateTrait as MintMaxValuePerTxTrait;
    use super::Mint::_mint_max_value::InternalContractMemberStateTrait as MintMaxValueTrait;

    const MAX_VALUE_PER_TX: u256 = 100;
    const MIN_VALUE_PER_TX: u256 = 5;
    const UNIT_PRICE: u256 = 10;
    const MERKLE_ROOT: felt252 =
        3236969588476960619958150604131083087415975923122021901088942336874683133579;
    const ALLOCATION: felt252 = 5;
    const PROOF: felt252 =
        1489335374474017495857579265074565262713421005832572026644103123081435719307;

    fn STATE() -> Mint::ContractState {
        Mint::contract_state_for_testing()
    }

    fn ACCOUNT() -> starknet::ContractAddress {
        starknet::contract_address_const::<1001>()
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_public_sale() {
        // [Setup]
        let mut state = STATE();
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Storage
        let public_sale_open = Mint::MintImpl::is_public_sale_open(@state);
        assert(public_sale_open, 'Public sale is not open');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_merkle_root() {
        // [Setup]
        let mut state = STATE();
        Mint::MintImpl::set_whitelist_merkle_root(ref state, MERKLE_ROOT);
        // [Assert] Storage
        let merkle_root = Mint::MintImpl::get_whitelist_merkle_root(@state);
        assert(merkle_root == MERKLE_ROOT, 'Invalid merkle root');
        // [Assert] Verify
        let proof = array![PROOF].span();
        let allocation = Mint::MintImpl::get_whitelist_allocation(
            @state, ACCOUNT(), ALLOCATION, proof
        );
        assert(allocation == ALLOCATION, 'Invalid allocation');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_max_value_per_tx() {
        // [Setup]
        let mut state = STATE();
        state._mint_max_value.write(1000);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        // [Assert] Storage
        let max_value_per_tx = Mint::MintImpl::get_max_value_per_tx(@state);
        assert(max_value_per_tx == MAX_VALUE_PER_TX, 'Invalid max value per tx');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_min_value_per_tx() {
        // [Setup]
        let mut state = STATE();
        state._mint_max_value_per_tx.write(100);
        Mint::MintImpl::set_min_value_per_tx(ref state, MIN_VALUE_PER_TX);
        // [Assert] Storage
        let min_value_per_tx = Mint::MintImpl::get_min_value_per_tx(@state);
        assert(min_value_per_tx == MIN_VALUE_PER_TX, 'Invalid min value per tx');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_unit_price() {
        // [Setup]
        let mut state = STATE();
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        // [Assert] Storage
        let unit_price = Mint::MintImpl::get_unit_price(@state);
        assert(unit_price == UNIT_PRICE, 'Invalid unit price');
    }
}
