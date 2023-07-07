// SPDX-License-Identifier: Apache-2.0

use starknet::ContractAddress;

#[starknet::interface]
trait IProxy<TContractState> {
    fn get_implementation_hash(self: @TContractState) -> felt252;
    fn get_admin(self: @TContractState) -> felt252;
    fn upgrade(ref self: TContractState, new_implementation: felt252);
    fn set_admin(ref self: TContractState, new_admin: ContractAddress);
}
