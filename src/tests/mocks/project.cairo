use traits::{Into, TryInto};

#[starknet::contract]
mod project {
    use starknet::ContractAddress;
    use starknet::contract_address_try_from_felt252;
    use option::OptionTrait;
    
    use protocol::interfaces::project::IProjectLegacy;
    use protocol::interfaces::erc721::IERC721;
    use protocol::interfaces::erc3525::IERC3525;
    use protocol::tests::constants::{OWNER, ANYONE, SOMEONE, NAME, SYMBOL, TOTAL_SUPPLY, URI, FINAL_TIME, FINAL_ABSORPTION, TON_EQUIVALENT, PROJECT_VALUE};

    #[storage]
    struct Storage { }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    #[external(v0)]
    impl ERC3525 of IERC3525<ContractState> {
        fn transferValueFrom(ref self: ContractState, fromTokenId: u256, toTokenId: u256, to: ContractAddress, value: u256) -> u256 { 1_u256}
    }

    #[external(v0)]
    impl ERC721 of IERC721<ContractState> {
        // IERC721
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 { 1 }
        fn ownerOf(self: @ContractState, tokenId: u256) -> ContractAddress { contract_address_try_from_felt252(ANYONE).unwrap() }
        fn transferFrom(self: @ContractState, from: ContractAddress, to: ContractAddress, tokenId: u256) {}
        fn safeTransferFrom(self: @ContractState, from: ContractAddress, to: ContractAddress, tokenId: u256, data: Span<felt252>) {}
        fn approve(self: @ContractState, to: ContractAddress, tokenId: u256) {}
        fn setApprovalForAll(self: @ContractState, operator: ContractAddress, approved: bool) {}
        fn getApproved(self: @ContractState, tokenId: u256) -> ContractAddress { contract_address_try_from_felt252(SOMEONE).unwrap() }
        fn isApprovedForAll(self: @ContractState, owner: ContractAddress, operator: ContractAddress) -> bool { true }
        // IERC721Metadata
        fn name(self: @ContractState) -> felt252 { NAME }
        fn symbol(self: @ContractState) -> felt252 { SYMBOL }
        fn tokenUri(self: @ContractState, tokenId: u256) -> felt252 { URI }
        // IERC721Enumerable
        fn totalSupply(self: @ContractState) -> u256 { TOTAL_SUPPLY }
        fn tokenByIndex(self: @ContractState, index: u256) -> u256 { 1_u256 }
        fn tokenOfOwnerByIndex(self: @ContractState, owner: ContractAddress, index: u256) -> u256 { 1_u256 }
    }

    #[external(v0)]
    impl Project of IProjectLegacy<ContractState> {
        // Access control
        fn getMinters(self: @ContractState, slot: u256) -> Array<ContractAddress> { ArrayTrait::<ContractAddress>::new() }
        fn addMinter(ref self: ContractState, slot: u256, minter: ContractAddress) {}
        fn revokeMinter(ref self: ContractState, slot: u256, minter: ContractAddress) {}
        fn getCertifier(self: @ContractState, slot: u256) -> ContractAddress { Zeroable::zero() }
        fn setCertifier(ref self: ContractState, slot: u256, certifier: ContractAddress) {}

        // Project
        fn getStartTime(self: @ContractState, slot: u256) -> u64 { 0 }
        fn getFinalTime(self: @ContractState, slot: u256) -> u64 { FINAL_TIME }
        fn getTimes(self: @ContractState, slot: u256) -> Array<u64> { ArrayTrait::<u64>::new() }
        fn getAbsorptions(self: @ContractState, slot: u256) -> Array<u64> { ArrayTrait::<u64>::new() }
        fn getAbsorption(self: @ContractState, slot: u256, time: u64) -> u64 { time }
        fn getCurrentAbsorption(self: @ContractState, slot: u256) -> u64 { starknet::get_block_timestamp() }
        fn getFinalAbsorption(self: @ContractState, slot: u256) -> u64 { FINAL_ABSORPTION }
        fn getTonEquivalent(self: @ContractState, slot: u256) -> u64 { TON_EQUIVALENT }
        fn getProjectValue(self: @ContractState, slot: u256) -> u256 { PROJECT_VALUE }
        fn isSetup(self: @ContractState, slot: u256) -> bool { true }
        fn setAbsorptions(ref self: ContractState, slot: u256, times: Array<u64>, absorptions: Array<u64>, ton_equivalent: u64) {}
        fn setProjectValue(ref self: ContractState, slot: u256, project_value: u256) {}
    }
}