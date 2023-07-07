// SPDX-License-Identifier: Apache-2.0

use array::ArrayTrait;
use starknet::ContractAddress;

#[starknet::interface]
trait IYielder<TContractState> {
    // Yielder
    fn get_payment_token_address(self: @TContractState) -> ContractAddress;
    fn get_total_claimable(self: @TContractState) -> u256;
    fn get_total_claimed(self: @TContractState) -> u256;
    fn get_claimable_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_claimed_of(self: @TContractState, account: ContractAddress) -> u256;
    fn claim(ref self: TContractState, token_id: u256);
}
