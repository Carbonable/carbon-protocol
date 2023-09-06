#[starknet::contract]
mod Mint {
    use zeroable::Zeroable;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use array::{Array, ArrayTrait};
    use debug::PrintTrait;
    use hash::LegacyHash;

    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};

    use alexandria_data_structures::merkle_tree::{MerkleTree, MerkleTreeTrait};

    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
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
        CarbonableMinter_carbonable_project_address_: ContractAddress,
        CarbonableMinter_carbonable_project_slot_: u256,
        CarbonableMinter_payment_token_address_: ContractAddress,
        CarbonableMinter_public_sale_open_: bool,
        CarbonableMinter_max_value_per_tx_: u256,
        CarbonableMinter_min_value_per_tx_: u256,
        CarbonableMinter_max_value_: u256,
        CarbonableMinter_unit_price_: u256,
        CarbonableMinter_reserved_value_: u256,
        CarbonableMinter_whitelist_merkle_root_: felt252,
        CarbonableMinter_claimed_value_: LegacyMap<ContractAddress, u256>,
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
        time: u64
    }

    #[derive(Drop, starknet::Event)]
    struct Buy {
        time: u64
    }

    impl MintImpl of IMint<ContractState> {
        fn get_carbonable_project_address(self: @ContractState) -> ContractAddress {
            self.CarbonableMinter_carbonable_project_address_.read()
        }

        fn get_carbonable_project_slot(self: @ContractState) -> u256 {
            self.CarbonableMinter_carbonable_project_slot_.read()
        }

        fn get_payment_token_address(self: @ContractState) -> ContractAddress {
            self.CarbonableMinter_payment_token_address_.read()
        }

        fn is_pre_sale_open(self: @ContractState) -> bool {
            let merkle_root = self.CarbonableMinter_whitelist_merkle_root_.read();
            merkle_root != 0
        }

        fn is_public_sale_open(self: @ContractState) -> bool {
            self.CarbonableMinter_public_sale_open_.read()
        }

        fn get_min_value_per_tx(self: @ContractState) -> u256 {
            self.CarbonableMinter_min_value_per_tx_.read()
        }

        fn get_max_value_per_tx(self: @ContractState) -> u256 {
            self.CarbonableMinter_max_value_per_tx_.read()
        }

        fn get_unit_price(self: @ContractState) -> u256 {
            self.CarbonableMinter_unit_price_.read()
        }

        fn get_reserved_value(self: @ContractState) -> u256 {
            self.CarbonableMinter_reserved_value_.read()
        }

        fn get_max_value(self: @ContractState) -> u256 {
            self.CarbonableMinter_max_value_.read()
        }

        fn get_whitelist_merkle_root(self: @ContractState) -> felt252 {
            self.CarbonableMinter_whitelist_merkle_root_.read()
        }

        fn get_whitelist_allocation(
            self: @ContractState, account: ContractAddress, allocation: u256, proof: Span<felt252>
        ) -> u256 {
            let root = self.CarbonableMinter_whitelist_merkle_root_.read();
            let leaf = LegacyHash::hash(account.into(), allocation);
            let mut tree: MerkleTree = MerkleTreeTrait::new();
            let whitelisted = tree.verify(root, leaf, proof);
            allocation * if whitelisted {
                1
            } else {
                0
            }
        }

        fn get_claimed_value(self: @ContractState, account: ContractAddress) -> u256 {
            self.CarbonableMinter_claimed_value_.read(account)
        }

        fn is_sold_out(self: @ContractState) -> bool {
            let project_address = self.CarbonableMinter_carbonable_project_address_.read();
            let slot = self.CarbonableMinter_carbonable_project_slot_.read();
            let max_value = IAbsorberDispatcher { contract_address: project_address }
                .get_project_value(slot);
            let reserved_value = self.CarbonableMinter_reserved_value_.read();
            let total_value = IProjectDispatcher { contract_address: project_address }
                .total_value(slot);
            total_value + reserved_value >= max_value
        }

        fn set_whitelist_merkle_root(ref self: ContractState, whitelist_merkle_root: felt252) {}
        fn set_public_sale_open(ref self: ContractState, public_sale_open: bool) {}
        fn set_max_value_per_tx(ref self: ContractState, max_value_per_tx: u256) {}
        fn set_min_value_per_tx(ref self: ContractState, min_value_per_tx: u256) {}
        fn set_unit_price(ref self: ContractState, unit_price: u256) {}
        fn decrease_reserved_value(ref self: ContractState, value: u256) {}
        fn airdrop(ref self: ContractState, to: ContractAddress, value: u256) {}
        fn withdraw(ref self: ContractState) {}
        fn transfer(
            ref self: ContractState,
            token_address: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) {}
        fn pre_buy(
            ref self: ContractState,
            allocation: u256,
            proof: Span<felt252>,
            value: u256,
            force: bool
        ) {}
        fn public_buy(ref self: ContractState, value: u256, force: bool) {}
    }
}
