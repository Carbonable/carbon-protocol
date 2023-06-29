// SPDX-License-Identifier: Apache-2.0

use array::ArrayTrait;
use starknet::ContractAddress;

#[starknet::interface]
trait IProject<TContractState> {
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
    fn getMinters(self: @TContractState, slot: u256) -> Array<ContractAddress>;

    #[external]
    fn addMinter(self: @TContractState, slot: u256, minter: ContractAddress);

    #[external]
    fn revokeMinter(self: @TContractState, slot: u256, minter: ContractAddress);

    #[view]
    fn getCertifier(self: @TContractState, slot: u256) -> ContractAddress;

    #[external]
    fn setCertifier(self: @TContractState, slot: u256, certifier: ContractAddress);

    //
    // Project
    //

    #[view]
    fn getStartTime(self: @TContractState, slot: u256) -> felt252;

    #[view]
    fn getFinalTime(self: @TContractState, slot: u256) -> felt252;

    #[view]
    fn getTimes(self: @TContractState, slot: u256) -> Array<felt252>;

    #[view]
    fn getAbsorptions(self: @TContractState, slot: u256) -> Array<felt252>;

    #[view]
    fn getAbsorption(self: @TContractState, slot: u256, time: felt252) -> felt252;

    #[view]
    fn getCurrentAbsorption(self: @TContractState, slot: u256) -> felt252;

    #[view]
    fn getFinalAbsorption(self: @TContractState, slot: u256) -> felt252;

    #[view]
    fn getTonEquivalent(self: @TContractState, slot: u256) -> felt252;

    #[view]
    fn getProjectValue(self: @TContractState, slot: u256) -> u256;

    #[view]
    fn isSetup(self: @TContractState, slot: u256) -> bool;

    #[external]
    fn setAbsorptions(self: @TContractState, slot: u256, times: Array<felt252>, absorptions: Array<felt252>, ton_equivalent: felt252);

    #[external]
    fn setProjectValue(self: @TContractState, slot: u256, project_value: u256);
}
