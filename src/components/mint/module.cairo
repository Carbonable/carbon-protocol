#[starknet::contract]
mod Mint {
    // Core imports

    use zeroable::Zeroable;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use array::{Array, ArrayTrait};
    use hash::HashStateTrait;
    use poseidon::PoseidonTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};

    // External imports

    use alexandria_data_structures::merkle_tree::{
        Hasher, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait,
    };
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
    use cairo_erc_3525::interface::{IERC3525Dispatcher, IERC3525DispatcherTrait};

    // Internal imports

    use carbon::components::mint::interface::{IMint, IL1Mint, IL1Handler};
    use carbon::components::mint::booking::{Booking, BookingStatus, BookingTrait, StoreBooking};
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
        _mint_remaining_value: u256,
        _mint_l1_minter_address: ContractAddress,
        _mint_count: LegacyMap::<ContractAddress, u32>,
        _mint_booked_values: LegacyMap::<(ContractAddress, u32), Booking>,
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
        BookingClaimed: BookingClaimed,
        BookingHandled: BookingHandled,
        BookingRefund: BookingRefund,
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
    struct BookingHandled {
        address: ContractAddress,
        id: u32,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct BookingClaimed {
        address: ContractAddress,
        id: u32,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct BookingRefund {
        address: ContractAddress,
        id: u32,
        value: u256,
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
            self._mint_whitelist_merkle_root.read() != 0
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

        fn get_remaining_value(self: @ContractState) -> u256 {
            self._mint_reserved_value.read()
        }

        fn get_available_value(self: @ContractState) -> u256 {
            self._mint_remaining_value.read() - self._mint_reserved_value.read()
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
            self.get_available_value() == 0
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
            let remaining_value = self._mint_remaining_value.read();
            assert(value <= remaining_value, 'Not enough available value');

            // [Check] Enough reserved value available
            let reserved_value = self._mint_reserved_value.read();
            assert(value <= reserved_value, 'Not enough reserved value');

            // [Effect] Update remaining value and reserved value
            self._mint_remaining_value.write(remaining_value - value);
            self._mint_reserved_value.write(reserved_value - value);

            // [Interaction] Mint
            let project_address = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let project = IProjectDispatcher { contract_address: project_address };
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

        fn prebook(
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
            let minted_value = self._safe_book(value, force);

            // [Effect] Update claimed value
            self._mint_claimed_value.write(caller_address, claimed_value + minted_value);
        }

        fn book(ref self: ContractState, value: u256, force: bool) {
            // [Check] Public sale is open
            let public_sale_open = self._mint_public_sale_open.read();
            assert(public_sale_open, 'Sale is closed');

            // [Interaction] Buy
            self._safe_book(value, force);
        }

        fn claim(ref self: ContractState, user_address: ContractAddress, id: u32) {
            // [Check] Project is sold out
            assert(self.is_sold_out(), 'Contract not sold out');

            // [Check] Booking
            let mut booking = self._mint_booked_values.read((user_address, id));
            assert(booking.is_status(BookingStatus::Booked), 'Booking not found');

            // [Effect] Update Booking status
            booking.set_status(BookingStatus::Minted);
            self._mint_booked_values.write((user_address.into(), id), booking);

            // [Interaction] Mint
            let projects_contract = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let project = IProjectDispatcher { contract_address: projects_contract };
            project.mint(user_address.into(), slot, booking.value);

            // [Event] Emit
            let event = BookingClaimed { address: user_address, id, value: booking.value, };
            self.emit(Event::BookingClaimed(event));
        }

        fn refund(ref self: ContractState, user_address: ContractAddress, id: u32) {
            // [Check] Booking
            let mut booking = self._mint_booked_values.read((user_address, id));
            assert(booking.is_status(BookingStatus::Failed), 'Booking not found');

            // [Effect] Update Booking status
            booking.set_status(BookingStatus::Refunded);
            self._mint_booked_values.write((user_address.into(), id), booking);

            // [Interaction] Refund
            let token_address = self._mint_payment_token_address.read();
            let erc20 = IERC20CamelDispatcher { contract_address: token_address };
            let contract_address = get_contract_address();
            let success = erc20.transfer(user_address, booking.value);
            assert(success, 'Transfer failed');

            // [Event] Emit
            let event = BookingRefund { address: user_address, id, value: booking.value, };
            self.emit(Event::BookingRefund(event));
        }

        fn refund_to(
            ref self: ContractState, to: ContractAddress, user_address: ContractAddress, id: u32
        ) {
            // [Check] To address connot be zero
            assert(!to.is_zero(), 'Invalid to address');

            // [Check] Booking
            let mut booking = self._mint_booked_values.read((user_address, id));
            assert(booking.is_status(BookingStatus::Failed), 'Booking not found');

            // [Effect] Update Booking status
            booking.set_status(BookingStatus::Refunded);
            self._mint_booked_values.write((user_address.into(), id), booking);

            // [Interaction] Refund
            let token_address = self._mint_payment_token_address.read();
            let erc20 = IERC20CamelDispatcher { contract_address: token_address };
            let contract_address = get_contract_address();
            let success = erc20.transfer(to, booking.value);
            assert(success, 'Transfer failed');

            // [Event] Emit
            let event = BookingRefund { address: user_address, id, value: booking.value, };
            self.emit(Event::BookingRefund(event));
        }
    }

    impl L1MintImpl of IL1Mint<ContractState> {
        fn get_l1_minter_address(self: @ContractState) -> ContractAddress {
            self._mint_l1_minter_address.read()
        }

        fn set_l1_minter_address(ref self: ContractState, l1_address: ContractAddress) {
            assert(!l1_address.is_zero(), 'L1 address cannot be zero');
            let _l1_address = self._mint_l1_minter_address.read();
            assert(_l1_address.is_zero(), 'L1 address already set');
            self._mint_l1_minter_address.write(l1_address);
        }
    }

    impl L1HandlerImpl of IL1Handler<ContractState> {
        fn book_from_l1(
            ref self: ContractState,
            from_address: ContractAddress,
            user_address: ContractAddress,
            value: u256,
            amount: u256,
        ) {
            // [Check] Can only be called by L1 minter, this method shouldn't fail otherwise.
            assert(
                from_address == self._mint_l1_minter_address.read(), 'Only L1 minter can mint value'
            );

            // [Effect] Assert booking status and update remaining supply
            let public_sale_open = self._mint_public_sale_open.read();
            let unit_price = self._mint_unit_price.read();
            let remaining_value = self._mint_remaining_value.read();
            let max_value_per_tx = self._mint_max_value_per_tx.read();
            let min_value_per_tx = self._mint_min_value_per_tx.read();
            let mut status = if (!user_address.is_zero()
                && public_sale_open
                && value <= max_value_per_tx
                && value >= min_value_per_tx
                && amount == unit_price
                * value && value <= remaining_value) {
                BookingStatus::Booked
            } else {
                BookingStatus::Failed
            };

            self._book(user_address, amount, value, status);
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
            assert(max_value >= max_value_per_tx, 'Invalid max value');
            assert(unit_price > 0, 'Invalid unit price');
            assert(reserved_value <= max_value, 'Invalid reserved value');

            // [Effect] Update storage
            self._mint_carbonable_project_address.write(carbonable_project_address);
            self._mint_carbonable_project_slot.write(carbonable_project_slot);

            // [Check] Max value is valid
            let remaining_value = self._project_remaining_value();
            assert(max_value <= remaining_value, 'Invalid max value');

            // [Effect] Update storage
            self._mint_payment_token_address.write(payment_token_address);
            self._mint_max_value_per_tx.write(max_value_per_tx);
            self._mint_min_value_per_tx.write(min_value_per_tx);
            self._mint_unit_price.write(unit_price);
            self._mint_reserved_value.write(reserved_value);
            self._mint_remaining_value.write(max_value);

            // [Effect] Use dedicated function to emit corresponding events
            self.set_public_sale_open(public_sale_open);
        }

        fn _safe_book(ref self: ContractState, value: u256, force: bool) -> u256 {
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

            // [Compute] If available value is lower than specified value and force is enabled
            // Then replace the specified value by the remaining value otherwize keep the value unchanged
            let available_value = self._available_public_value();
            let value = if available_value < value && force {
                available_value
            } else {
                value
            };

            // [Check] Value after buy
            assert(value <= available_value, 'Not enough available value');

            // [Interaction] Pay
            let unit_price = self._mint_unit_price.read();
            let amount = value * unit_price;
            let token_address = self._mint_payment_token_address.read();
            let erc20 = IERC20CamelDispatcher { contract_address: token_address };
            let contract_address = get_contract_address();
            let success = erc20.transferFrom(caller_address, contract_address, amount);

            // [Check] Transfer successful
            assert(success, 'Transfer failed');

            // [Effect] Book
            self._book(caller_address, amount, value, BookingStatus::Booked);

            // [Return] Value
            value
        }

        fn _book(
            ref self: ContractState,
            user_address: ContractAddress,
            amount: u256,
            value: u256,
            status: BookingStatus
        ) {
            // [Effect] Compute and update user mint count
            let mint_id = self._mint_count.read(user_address) + 1_u32;
            self._mint_count.write(user_address, mint_id);

            // [Effect] Update remaining value if booked
            let mut booking = BookingTrait::new(value, amount, status);
            if booking.is_status(BookingStatus::Booked) {
                self._mint_remaining_value.write(self._mint_remaining_value.read() - value);
            };

            // [Effect] Store booking
            self._mint_booked_values.write((user_address, mint_id), booking);

            // [Event] Emit event
            let event = BookingHandled { address: user_address, id: mint_id, value };
            self.emit(Event::BookingHandled(event));

            // [Effect] Close the sale if sold out
            if self.is_sold_out() {
                // [Effect] Close pre sale
                self.set_whitelist_merkle_root(0);

                // [Effect] Close public sale
                self.set_public_sale_open(false);

                // [Event] Emit sold out event
                let event = SoldOut { time: get_block_timestamp() };
                self.emit(Event::SoldOut(event));
            };
        }

        fn _project_remaining_value(self: @ContractState) -> u256 {
            // [Compute] Total remaining value
            let project_address = self._mint_carbonable_project_address.read();
            let slot = self._mint_carbonable_project_slot.read();
            let project = IProjectDispatcher { contract_address: project_address };
            let total_value = project.total_value(slot);
            let absorber = IAbsorberDispatcher { contract_address: project_address };
            let project_value = absorber.get_project_value(slot);
            project_value - total_value
        }

        fn _available_public_value(self: @ContractState) -> u256 {
            // [Compute] Available value
            let remaining_value = self._mint_remaining_value.read();
            let reserved_value = self._mint_reserved_value.read();
            remaining_value - reserved_value
        }
    }
}


#[cfg(test)]
mod Test {
    // Core imports

    use array::ArrayTrait;
    use traits::TryInto;
    use poseidon::PoseidonTrait;
    use hash::HashStateTrait;
    use debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::testing::{set_block_timestamp, set_caller_address, set_contract_address};

    // External imports

    use alexandria_data_structures::merkle_tree::{
        Hasher, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait,
    };

    // Internal imports

    use super::Mint;
    use super::Mint::_mint_max_value_per_tx::InternalContractMemberStateTrait as MintMaxValuePerTxTrait;
    use super::Mint::_mint_carbonable_project_address::InternalContractMemberStateTrait as MintProjectAddressTrait;
    use super::Mint::_mint_remaining_value::InternalContractMemberStateTrait as MintRemainingValueTrait;
    use super::Mint::_mint_payment_token_address::InternalContractMemberStateTrait as MintPaymentTokenAddressTrait;

    // Constants

    const MAX_VALUE_PER_TX: u256 = 100;
    const MIN_VALUE_PER_TX: u256 = 5;
    const UNIT_PRICE: u256 = 10;
    const MERKLE_ROOT: felt252 = 0x6a60c7ba8f69a71bdb100454e45ea29dc3474e6a0718039c957282f25897422;
    const ALLOCATION: felt252 = 5;
    const PROOF: felt252 = 0x58f605c335d6edee10b834aedf74f8ed903311799ecde69461308439a4537c7;
    const BILION: u256 = 1000000000;

    fn STATE() -> Mint::ContractState {
        Mint::contract_state_for_testing()
    }

    fn ACCOUNT() -> ContractAddress {
        starknet::contract_address_const::<1001>()
    }

    fn ZERO() -> ContractAddress {
        starknet::contract_address_const::<0>()
    }

    // Mocks

    #[starknet::contract]
    mod ProjectMock {
        use starknet::ContractAddress;

        #[storage]
        struct Storage {}

        #[generate_trait]
        #[external(v0)]
        impl MockImpl of MockTrait {
            fn get_project_value(self: @ContractState, slot: u256) -> u256 {
                super::BILION
            }
            fn total_value(self: @ContractState, slot: u256) -> u256 {
                0
            }
            fn mint(ref self: ContractState, to: ContractAddress, slot: u256, value: u256) -> u256 {
                0
            }
        }
    }

    #[starknet::contract]
    mod ERC20Mock {
        use starknet::ContractAddress;

        #[storage]
        struct Storage {}

        #[generate_trait]
        #[external(v0)]
        impl ERC20Impl of ERC20Trait {
            fn balanceOf(self: @ContractState, owner: ContractAddress) -> u256 {
                100
            }
            fn transferFrom(
                ref self: ContractState, from: ContractAddress, to: ContractAddress, value: u256
            ) -> bool {
                true
            }
            fn transfer(ref self: ContractState, to: ContractAddress, value: u256) -> bool {
                true
            }
        }
    }

    fn project_mock() -> ContractAddress {
        // [Deploy]
        let class_hash = ProjectMock::TEST_CLASS_HASH.try_into().unwrap();
        let (address, _) = starknet::deploy_syscall(class_hash, 0, array![].span(), false)
            .expect('Project deploy failed');
        address
    }

    fn erc20_mock() -> ContractAddress {
        // [Deploy]
        let class_hash = ERC20Mock::TEST_CLASS_HASH.try_into().unwrap();
        let (address, _) = starknet::deploy_syscall(class_hash, 0, array![].span(), false)
            .expect('ERC20 deploy failed');
        address
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
        assert(merkle_root == merkle_root, 'Invalid merkle root');
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

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Sale is closed',))]
    fn test_mint_book_revert_sale_closed() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Book
        Mint::MintImpl::book(ref state, 10, false);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Invalid caller',))]
    fn test_mint_book_revert_invalid_caller() {
        // [Setup]
        let mut state = STATE();
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        Mint::MintImpl::book(ref state, 10, false);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Value too high',))]
    fn test_mint_book_value_too_high() {
        // [Setup]
        let mut state = STATE();
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        set_caller_address(ACCOUNT());
        Mint::MintImpl::book(ref state, 10, false);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Not enough available value',))]
    fn test_mint_book_not_enough_available_value() {
        // [Setup]
        let mut state = STATE();
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        set_caller_address(ACCOUNT());
        Mint::MintImpl::book(ref state, 10, false);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_book() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        set_caller_address(ACCOUNT());
        Mint::MintImpl::book(ref state, 10, false);
    // [Assert] Events - Enable when test is contract
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_book_from_l1() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, value * UNIT_PRICE);
        // [Assert] Sold out
        set_caller_address(ACCOUNT());
        assert(Mint::MintImpl::is_sold_out(@state), 'Contract not sold out');
    // [Assert] Events - Enable when test is contract
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_booking_failed_wrong_amount() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, 0);
        // [Assert] Not sold out
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_booking_failed_not_enough_available_value() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(500);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, value * UNIT_PRICE);
        // [Assert] Not sold out
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_booking_failed_public_sale_close() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_public_sale_open(ref state, false);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, value * UNIT_PRICE);
        // [Assert] Not sold out
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_booking_failed_too_low_value() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(100);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_min_value_per_tx(ref state, 500);
        Mint::MintImpl::set_public_sale_open(ref state, false);
        // [Assert] Book
        let value: u256 = 100;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, value * UNIT_PRICE);
        // [Assert] Not sold out
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_refund() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, value * UNIT_PRICE);
        // [Assert] Not sold out
        set_caller_address(ACCOUNT());
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
        // [Assert] Refund
        Mint::MintImpl::refund(ref state, ACCOUNT(), 1);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_refund_to() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, 0);
        // [Assert] Not sold out
        set_caller_address(ACCOUNT());
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
        // [Assert] Refund
        Mint::MintImpl::refund_to(ref state, ACCOUNT(), ACCOUNT(), 1);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Invalid to address',))]
    fn test_mint_refund_to_revert_invalid_to_address() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(ref state, ZERO(), ACCOUNT(), value, 0);
        // [Assert] Not sold out
        set_caller_address(ACCOUNT());
        assert(!Mint::MintImpl::is_sold_out(@state), 'Contract sold out');
        // [Assert] Refund
        Mint::MintImpl::refund_to(ref state, ZERO(), ACCOUNT(), 1);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Only L1 minter can mint value',))]
    fn test_mint_book_from_l1_revert_wrong_from() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, MAX_VALUE_PER_TX);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        let value: u256 = 1000;
        Mint::L1HandlerImpl::book_from_l1(
            ref state, ACCOUNT(), ACCOUNT(), value, value * UNIT_PRICE
        );
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_claim() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        set_caller_address(ACCOUNT());
        Mint::MintImpl::book(ref state, 1000, true);
        // [Assert] Sold out
        assert(Mint::MintImpl::is_sold_out(@state), 'Contract not sold out');
        // [Assert] Claim
        Mint::MintImpl::claim(ref state, ACCOUNT(), 1);
    // [Assert] Events - Enable when test is contract
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Booking not found',))]
    fn test_mint_claim_twice_revert_not_found() {
        // [Setup]
        let mut state = STATE();
        state._mint_carbonable_project_address.write(project_mock());
        state._mint_payment_token_address.write(erc20_mock());
        state._mint_remaining_value.write(1000);
        Mint::MintImpl::set_unit_price(ref state, UNIT_PRICE);
        Mint::MintImpl::set_max_value_per_tx(ref state, 1000);
        Mint::MintImpl::set_public_sale_open(ref state, true);
        // [Assert] Book
        set_caller_address(ACCOUNT());
        Mint::MintImpl::book(ref state, 1000, true);
        // [Assert] Sold out
        assert(Mint::MintImpl::is_sold_out(@state), 'Contract not sold out');
        // [Assert] Claim
        Mint::MintImpl::claim(ref state, ACCOUNT(), 1);
        Mint::MintImpl::claim(ref state, ACCOUNT(), 1);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_mint_l1_minter_address() {
        // [Setup]
        let mut state = STATE();
        let l1_minter = Mint::L1MintImpl::get_l1_minter_address(@state);
        assert(l1_minter == ZERO(), 'Invalid l1 minter address');
        // [Assert] Set l1 minter address
        Mint::L1MintImpl::set_l1_minter_address(ref state, ACCOUNT());
        let l1_minter = Mint::L1MintImpl::get_l1_minter_address(@state);
        assert(l1_minter == ACCOUNT(), 'Invalid l1 minter address');
    }
}
