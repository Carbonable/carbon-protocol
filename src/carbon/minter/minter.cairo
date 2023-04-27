use starknet::ContractAddress;
use array::ArrayTrait;

trait IMinter {
    /// Administration
    // fn withdrawer() -> ContractAddress;
    // fn set_withdrawer(withdrawer: ContractAddress);
    /// Views
    fn project_address() -> ContractAddress;
    fn project_slot() -> u256;
    fn payment_token_address() -> ContractAddress;
    fn is_pre_sale_open() -> bool;
    fn is_public_sale_open() -> bool;
    fn min_value_per_tx() -> felt252;
    fn max_value_per_tx() -> felt252;
    fn unit_price() -> felt252;
    fn reserved_value() -> felt252;
    fn max_value() -> felt252;
    fn whitelist_merkle_root() -> felt252;
    fn whitelist_allocation(
        account: ContractAddress, allocation: felt252, proof: Array<felt252>
    ) -> felt252;
    fn claimed_value(account: ContractAddress) -> felt252;
    fn is_sold_out() -> bool;
    /// Externals
    fn set_whitelist_merkle_root(whitelist_merkle_root: felt252);
    fn set_public_sale_open(public_sale_open: bool);
    fn set_max_value_per_tx(max_value_per_tx: felt252);
    fn set_min_value_per_tx(min_value_per_tx: felt252);
    fn set_unit_price(unit_price: felt252);
    fn decrease_reserved_value(value: felt252);
    fn airdrop(to: ContractAddress, value: felt252) -> bool;
    fn withdraw() -> bool;
    fn transfer(token_address: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn pre_buy(allocation: felt252, proof: Array<felt252>, value: felt252, force: bool) -> bool;
    fn public_buy(value: felt252, force: bool) -> bool;
}

#[contract]
mod Minter {
    use super::IMinter;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::ContractAddressZeroable;
    // use starknet::pedersen_hash;
    use integer::u256;
    use integer::u256_from_felt252;
    use zeroable::Zeroable;

    struct Storage {
        CarbonableMinter_carbonable_project_address_: ContractAddress,
        CarbonableMinter_carbonable_project_slot_: u256,
        CarbonableMinter_payment_token_address_: ContractAddress,
        CarbonableMinter_public_sale_open_: bool,
        CarbonableMinter_max_value_per_tx_: felt252,
        CarbonableMinter_min_value_per_tx_: felt252,
        CarbonableMinter_max_value_: felt252,
        CarbonableMinter_unit_price_: felt252,
        CarbonableMinter_reserved_value_: felt252,
        CarbonableMinter_whitelist_merkle_root_: felt252,
        CarbonableMinter_claimed_value_: LegacyMap<ContractAddress, felt252>,
    }

    #[event]
    fn PreSaleOpen(time: felt252) {}

    #[event]
    fn PreSaleClose(time: felt252) {}

    #[event]
    fn PublicSaleOpen(time: felt252) {}

    #[event]
    fn PublicSaleClose(time: felt252) {}

    #[event]
    fn SoldOut(time: felt252) {}

    #[event]
    fn Airdrop(address: ContractAddress, value: u256, time: felt252) {}

    #[event]
    fn Buy(address: ContractAddress, value: u256, time: felt252) {}

    impl Minter of IMinter {
        fn project_address() -> ContractAddress {
            CarbonableMinter_carbonable_project_address_::read()
        }

        fn project_slot() -> u256 {
            CarbonableMinter_carbonable_project_slot_::read()
        }

        fn payment_token_address() -> ContractAddress {
            CarbonableMinter_payment_token_address_::read()
        }

        fn is_pre_sale_open() -> bool {
            /// If whitelist merkle root is zero, pre-sale is not open
            let merkle_root = CarbonableMinter_whitelist_merkle_root_::read();
            merkle_root != 0
        }

        fn is_public_sale_open() -> bool {
            CarbonableMinter_public_sale_open_::read()
        }

        fn is_sold_out() -> bool {
            /// TODO: ERC3525 interaction
            true
        }

        fn max_value_per_tx() -> felt252 {
            CarbonableMinter_max_value_per_tx_::read()
        }

        fn min_value_per_tx() -> felt252 {
            CarbonableMinter_min_value_per_tx_::read()
        }

        fn max_value() -> felt252 {
            CarbonableMinter_max_value_::read()
        }

        fn unit_price() -> felt252 {
            CarbonableMinter_unit_price_::read()
        }

        fn reserved_value() -> felt252 {
            CarbonableMinter_reserved_value_::read()
        }

        fn whitelist_merkle_root() -> felt252 {
            CarbonableMinter_whitelist_merkle_root_::read()
        }

        fn whitelist_allocation(
            account: ContractAddress, allocation: felt252, proof: Array<felt252>
        ) -> felt252 {
            let merkle_root = CarbonableMinter_whitelist_merkle_root_::read();
            /// TODO: Merkle tree verification
            1
        }

        fn claimed_value(address: ContractAddress) -> felt252 {
            CarbonableMinter_claimed_value_::read(address)
        }

        fn set_whitelist_merkle_root(merkle_root: felt252) {
            /// TODO: Assert only owner
            CarbonableMinter_whitelist_merkle_root_::write(merkle_root);
        }

        fn set_public_sale_open(public_sale_open: bool) {
            /// TODO: Assert only owner
            CarbonableMinter_public_sale_open_::write(public_sale_open);
        }

        fn set_max_value_per_tx(max_value_per_tx: felt252) {
            /// TODO: Assert only owner
            CarbonableMinter_max_value_per_tx_::write(max_value_per_tx);
        }

        fn set_min_value_per_tx(min_value_per_tx: felt252) {
            /// TODO: Assert only owner
            CarbonableMinter_min_value_per_tx_::write(min_value_per_tx);
        }

        fn set_unit_price(unit_price: felt252) {
            /// TODO: Assert only owner
            CarbonableMinter_unit_price_::write(unit_price);
        }

        fn decrease_reserved_value(value: felt252) {
            /// TODO: Assert only owner
            let reserved_value = CarbonableMinter_reserved_value_::read();
            CarbonableMinter_reserved_value_::write(reserved_value - value);
        }

        fn airdrop(to: ContractAddress, value: felt252) -> bool {
            /// TODO: Assert only owner
            /// TODO: ERC3525 interaction
            true
        }

        fn withdraw() -> bool { /// TODO: Assert only withdrawer
            /// TODO: ERC20 interaction
            true
        }

        fn transfer(
            token_address: ContractAddress, recipient: ContractAddress, amount: u256
        ) -> bool {
            /// TODO: Assert only owner
            /// TODO: ERC20 interaction
            true
        }

        fn pre_buy(
            allocation: felt252, proof: Array<felt252>, value: felt252, force: bool, 
        ) -> bool {
            /// [Check] pre-sale is open
            assert(is_pre_sale_open(), 'Minter: pre-sale not open');
            /// TODO: Assert only owner
            /// TODO: ERC3525 interaction
            true
        }

        fn public_buy(value: felt252, force: bool, ) -> bool {
            /// [Check] public-sale is open
            assert(is_public_sale_open(), 'Minter: public-sale not open');
            /// TODO: Assert only owner
            /// TODO: ERC3525 interaction
            true
        }
    }

    #[constructor]
    fn constructor(
        project_address: ContractAddress,
        project_slot: u256,
        payment_token_address: ContractAddress,
        public_sale_open: bool,
        max_value_per_tx: felt252,
        min_value_per_tx: felt252,
        max_value: felt252,
        unit_price: felt252,
        reserved_value: felt252,
        owner: ContractAddress,
    ) {
        initializer(
            project_address,
            project_slot,
            payment_token_address,
            public_sale_open,
            max_value_per_tx,
            min_value_per_tx,
            max_value,
            unit_price,
            reserved_value,
        );
    }

    #[view]
    fn get_carbonable_project_address() -> ContractAddress {
        Minter::project_address()
    }

    #[view]
    fn get_carbonable_project_slot() -> u256 {
        Minter::project_slot()
    }

    #[view]
    fn get_payment_token_address() -> ContractAddress {
        Minter::payment_token_address()
    }

    #[view]
    fn is_pre_sale_open() -> bool {
        Minter::is_pre_sale_open()
    }

    #[view]
    fn is_public_sale_open() -> bool {
        Minter::is_public_sale_open()
    }

    #[view]
    fn is_sold_out() -> bool {
        Minter::is_sold_out()
    }

    #[view]
    fn get_max_value_per_tx() -> felt252 {
        Minter::max_value_per_tx()
    }

    #[view]
    fn get_min_value_per_tx() -> felt252 {
        Minter::min_value_per_tx()
    }

    #[view]
    fn get_max_value() -> felt252 {
        Minter::max_value()
    }

    #[view]
    fn get_unit_price() -> felt252 {
        Minter::unit_price()
    }

    #[view]
    fn get_reserved_value() -> felt252 {
        Minter::reserved_value()
    }

    #[view]
    fn get_whitelist_merkle_root() -> felt252 {
        Minter::whitelist_merkle_root()
    }

    #[view]
    fn get_whitelist_allocation(
        account: ContractAddress, allocation: felt252, proof: Array<felt252>
    ) -> felt252 {
        Minter::whitelist_allocation(account, allocation, proof)
    }

    #[view]
    fn get_claimed_value(address: ContractAddress) -> felt252 {
        Minter::claimed_value(address)
    }


    #[external]
    fn set_whitelist_merkle_root(merkle_root: felt252) {
        Minter::set_whitelist_merkle_root(merkle_root)
    }

    #[external]
    fn set_public_sale_open(public_sale_open: bool) {
        Minter::set_public_sale_open(public_sale_open)
    }

    #[external]
    fn set_max_value_per_tx(max_value_per_tx: felt252) {
        let min_value_per_tx = Minter::min_value_per_tx();
        let max_value = Minter::max_value();
        assert(
            u256_from_felt252(min_value_per_tx) <= u256_from_felt252(max_value_per_tx),
            'Minter: min_value <= max_value'
        );
        assert(
            u256_from_felt252(max_value_per_tx) <= u256_from_felt252(max_value),
            'Minter: max_per_tx <= max_value'
        );
        Minter::set_max_value_per_tx(max_value_per_tx)
    }

    #[external]
    fn set_min_value_per_tx(min_value_per_tx: felt252) {
        Minter::set_min_value_per_tx(min_value_per_tx)
    }

    #[external]
    fn set_unit_price(unit_price: felt252) {
        Minter::set_unit_price(unit_price)
    }

    #[external]
    fn decrease_reserved_value(value: felt252) {
        Minter::decrease_reserved_value(value)
    }

    #[external]
    fn airdrop(to: ContractAddress, value: felt252) -> bool {
        Minter::airdrop(to, value)
    }

    #[external]
    fn withdraw() -> bool {
        Minter::withdraw()
    }

    #[external]
    fn transfer(token_address: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
        Minter::transfer(token_address, recipient, amount)
    }

    #[external]
    fn pre_buy(allocation: felt252, proof: Array<felt252>, value: felt252, force: bool, ) -> bool {
        Minter::pre_buy(allocation, proof, value, force)
    }

    #[external]
    fn public_buy(value: felt252, force: bool, ) -> bool {
        Minter::public_buy(value, force)
    }

    ///
    /// Internals
    ///

    fn initializer(
        project_address: ContractAddress,
        project_slot: u256,
        payment_token_address: ContractAddress,
        public_sale_open: bool,
        max_value_per_tx: felt252,
        min_value_per_tx: felt252,
        max_value: felt252,
        unit_price: felt252,
        reserved_value: felt252,
    ) {
        // [Check] valid initialization
        // Direct felt252 comparisons have been removed from the core library
        let zero_u256 = u256_from_felt252(0);
        assert(u256_from_felt252(min_value_per_tx) > zero_u256, 'Minter: min_value_per_tx > 0');
        assert(u256_from_felt252(unit_price) >= zero_u256, 'Minter: unit_price >= 0');
        assert(u256_from_felt252(reserved_value) >= zero_u256, 'Minter: reserved_value >= 0');
        assert(
            u256_from_felt252(reserved_value) <= u256_from_felt252(max_value),
            'Minter: reserved <= max_value'
        );
        assert(
            u256_from_felt252(min_value_per_tx) <= u256_from_felt252(max_value_per_tx),
            'Minter: min_value <= max_value'
        );
        assert(
            u256_from_felt252(max_value_per_tx) <= u256_from_felt252(max_value),
            'Minter: max_value <= max per tx'
        );

        CarbonableMinter_carbonable_project_address_::write(project_address);
        CarbonableMinter_carbonable_project_slot_::write(project_slot);
        CarbonableMinter_payment_token_address_::write(payment_token_address);
        CarbonableMinter_public_sale_open_::write(public_sale_open);
        CarbonableMinter_max_value_per_tx_::write(max_value_per_tx);
        CarbonableMinter_min_value_per_tx_::write(min_value_per_tx);
        CarbonableMinter_max_value_::write(max_value);
        CarbonableMinter_unit_price_::write(unit_price);
        CarbonableMinter_reserved_value_::write(reserved_value);

        // Use dedicated function to emit corresponding events
        set_public_sale_open(public_sale_open);
    }
}
