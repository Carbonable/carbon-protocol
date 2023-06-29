// SPDX-License-Identifier: Apache-2.0

use array::ArrayTrait;
use starknet::ContractAddress;

#[starknet::interface]
trait IMinter<TContractState> {
    //
    // Proxy administration
    //

    #[view]
    fn getImplementationHash(self: @TContractState) -> felt252;

    #[view]
    fn getAdmin(self: @TContractState) -> felt252;

    #[external]
    fn upgrade(ref self: TContractState, new_implementation: felt252);

    #[external]
    fn setAdmin(ref self: TContractState, new_admin: ContractAddress);

    //
    // Ownership administration
    //

    #[view]
    fn owner(self: @TContractState) -> ContractAddress;

    #[external]
    fn transferOwnership(self: @TContractState, newOwner: ContractAddress);

    #[external]
    fn renounceOwnership(self: @TContractState);

    //
    // Access control administration
    //

    #[view]
    fn getWithdrawer(self: @TContractState, slot: u256) -> ContractAddress;

    #[external]
    fn setWithdrawer(self: @TContractState, slot: u256, withdrawer: ContractAddress);

    //
    // Minter
    //

    #[view]
    fn getCarbonableProjectAddress(self: @TContractState) -> ContractAddress;

    #[view]
    fn getCarbonableProjectSlot(self: @TContractState) -> u256;

    #[view]
    fn getPaymentTokenAddress(self: @TContractState) -> ContractAddress;

    #[view]
    fn isPreSaleOpen(self: @TContractState) -> bool;

    #[view]
    fn isPublicSaleOpen(self: @TContractState) -> bool;

    #[view]
    fn getMinValuePerTx(self: @TContractState) -> u256;

    #[view]
    fn getMaxValuePerTx(self: @TContractState) -> u256;

    #[view]
    fn getUnitPrice(self: @TContractState) -> u256;

    #[view]
    fn getReservedValue(self: @TContractState) -> u256;

    #[view]
    fn getMaxValue(self: @TContractState) -> u256;

    #[view]
    fn getWhitelistMerkleRoot(self: @TContractState) -> felt252;

    #[view]
    fn getWhitelistMerkleRoot(self: @TContractState) -> felt252;

    #[view]
    fn getWhitelistAllocation(self: @TContractState, account: ContractAddress, allocation: u256, proof: Array<felt252>) -> u256;

    #[view]
    fn getClaimedValue(self: @TContractState, account: ContractAddress) -> u256;

    #[view]
    fn isSoldOut(self: @TContractState) -> bool;

    #[external]
    fn setWhitelistMerkleRoot(self: @TContractState, root: felt252);

    #[external]
    fn setPublicSaleOpen(self: @TContractState, status: bool);

    #[external]
    fn setMaxValuePerTx(self: @TContractState, value: u256);

    #[external]
    fn setMinValuePerTx(self: @TContractState, value: u256);

    #[external]
    fn setUnitPrice(self: @TContractState, price: u256);

    #[external]
    fn decreaseReservedValue(self: @TContractState, value: u256);

    #[external]
    fn airdrop(self: @TContractState, to: ContractAddress, value: u256);

    #[external]
    fn withdraw(self: @TContractState);

    #[external]
    fn transfer(self: @TContractState, recipient: ContractAddress, amount: u256);

    #[external]
    fn preBuy(self: @TContractState, allocation: u256, proof: Array<felt252>, value: u256, force: bool);

    #[external]
    fn publicBuy(self: @TContractState, value: u256, force: bool);
}
