// SPDX-License-Identifier: Apache-2.0

use array::ArrayTrait;
use starknet::ContractAddress;

#[starknet::interface]
trait IProject<TContractState> {
    // Access control administration
    fn get_minters(self: @TContractState, slot: u256) -> Array<ContractAddress>;
    fn add_minter(ref self: TContractState, slot: u256, minter: ContractAddress);
    fn revoke_minter(ref self: TContractState, slot: u256, minter: ContractAddress);
    fn get_certifier(self: @TContractState, slot: u256) -> ContractAddress;
    fn set_certifier(ref self: TContractState, slot: u256, certifier: ContractAddress);

    // Project
    fn get_start_time(self: @TContractState, slot: u256) -> u64;
    fn get_final_time(self: @TContractState, slot: u256) -> u64;
    fn get_times(self: @TContractState, slot: u256) -> Array<u64>;
    fn get_absorptions(self: @TContractState, slot: u256) -> Array<u64>;
    fn get_absorption(self: @TContractState, slot: u256, time: u64) -> u64;
    fn get_current_absorption(self: @TContractState, slot: u256) -> u64;
    fn get_final_absorption(self: @TContractState, slot: u256) -> u64;
    fn get_ton_equivalent(self: @TContractState, slot: u256) -> u64;
    fn get_project_value(self: @TContractState, slot: u256) -> u256;
    fn is_setup(self: @TContractState, slot: u256) -> bool;
    fn set_absorptions(ref self: TContractState, slot: u256, times: Array<u64>, absorptions: Array<u64>, ton_equivalent: u64);
    fn set_project_value(ref self: TContractState, slot: u256, project_value: u256);
}

#[starknet::interface]
trait IProjectLegacy<TContractState> {
    // Access control administration
    fn getMinters(self: @TContractState, slot: u256) -> Array<ContractAddress>;
    fn addMinter(ref self: TContractState, slot: u256, minter: ContractAddress);
    fn revokeMinter(ref self: TContractState, slot: u256, minter: ContractAddress);
    fn getCertifier(self: @TContractState, slot: u256) -> ContractAddress;
    fn setCertifier(ref self: TContractState, slot: u256, certifier: ContractAddress);

    // Project
    fn getStartTime(self: @TContractState, slot: u256) -> u64;
    fn getFinalTime(self: @TContractState, slot: u256) -> u64;
    fn getTimes(self: @TContractState, slot: u256) -> Array<u64>;
    fn getAbsorptions(self: @TContractState, slot: u256) -> Array<u64>;
    fn getAbsorption(self: @TContractState, slot: u256, time: u64) -> u64;
    fn getCurrentAbsorption(self: @TContractState, slot: u256) -> u64;
    fn getFinalAbsorption(self: @TContractState, slot: u256) -> u64;
    fn getTonEquivalent(self: @TContractState, slot: u256) -> u64;
    fn getProjectValue(self: @TContractState, slot: u256) -> u256;
    fn isSetup(self: @TContractState, slot: u256) -> bool;
    fn setAbsorptions(ref self: TContractState, slot: u256, times: Array<u64>, absorptions: Array<u64>, ton_equivalent: u64);
    fn setProjectValue(ref self: TContractState, slot: u256, project_value: u256);
}
