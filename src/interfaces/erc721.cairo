use starknet::ContractAddress;

#[starknet::interface]
trait IERC721<TContractState> {
    // IERC721
    fn balanceOf(self: @TContractState, account: ContractAddress) -> u256;
    fn ownerOf(self: @TContractState, tokenId: u256) -> ContractAddress;
    fn transferFrom(
        self: @TContractState, from: ContractAddress, to: ContractAddress, tokenId: u256
    );
    fn safeTransferFrom(
        self: @TContractState,
        from: ContractAddress,
        to: ContractAddress,
        tokenId: u256,
        data: Span<felt252>
    );
    fn approve(self: @TContractState, to: ContractAddress, tokenId: u256);
    fn setApprovalForAll(self: @TContractState, operator: ContractAddress, approved: bool);
    fn getApproved(self: @TContractState, tokenId: u256) -> ContractAddress;
    fn isApprovedForAll(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    // IERC721Metadata
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn tokenUri(self: @TContractState, tokenId: u256) -> felt252;
    // IERC721Enumerable
    fn totalSupply(self: @TContractState) -> u256;
    fn tokenOfOwnerByIndex(self: @TContractState, owner: ContractAddress, index: u256) -> u256;
    fn tokenByIndex(self: @TContractState, index: u256) -> u256;
}
