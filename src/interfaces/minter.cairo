// SPDX-License-Identifier: Apache-2.0

use array::ArrayTrait;
use starknet::ContractAddress;


#[starknet::interface]
trait IMinter<TContractState> {
    // Access control administration
    fn getWithdrawer(self: @TContractState, slot: u256) -> ContractAddress;
    fn setWithdrawer(self: @TContractState, slot: u256, withdrawer: ContractAddress);
    // Minter
    fn getCarbonableProjectAddress(self: @TContractState) -> ContractAddress;
    fn getCarbonableProjectSlot(self: @TContractState) -> u256;
    fn getPaymentTokenAddress(self: @TContractState) -> ContractAddress;
    fn isPreSaleOpen(self: @TContractState) -> bool;
    fn isPublicSaleOpen(self: @TContractState) -> bool;
    fn getMinValuePerTx(self: @TContractState) -> u256;
    fn getMaxValuePerTx(self: @TContractState) -> u256;
    fn getUnitPrice(self: @TContractState) -> u256;
    fn getReservedValue(self: @TContractState) -> u256;
    fn getMaxValue(self: @TContractState) -> u256;
    fn getWhitelistMerkleRoot(self: @TContractState) -> felt252;
    fn getWhitelistAllocation(
        self: @TContractState, account: ContractAddress, allocation: u256, proof: Array<felt252>
    ) -> u256;
    fn getClaimedValue(self: @TContractState, account: ContractAddress) -> u256;
    fn isSoldOut(self: @TContractState) -> bool;
    fn setWhitelistMerkleRoot(self: @TContractState, root: felt252);
    fn setPublicSaleOpen(self: @TContractState, status: bool);
    fn setMaxValuePerTx(self: @TContractState, value: u256);
    fn setMinValuePerTx(self: @TContractState, value: u256);
    fn setUnitPrice(self: @TContractState, price: u256);
    fn decreaseReservedValue(self: @TContractState, value: u256);
    fn airdrop(self: @TContractState, to: ContractAddress, value: u256);
    fn withdraw(self: @TContractState);
    fn transfer(self: @TContractState, recipient: ContractAddress, amount: u256);
    fn preBuy(
        self: @TContractState, allocation: u256, proof: Array<felt252>, value: u256, force: bool
    );
    fn publicBuy(self: @TContractState, value: u256, force: bool);
}
