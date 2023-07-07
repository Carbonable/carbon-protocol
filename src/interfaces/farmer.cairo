// SPDX-License-Identifier: Apache-2.0

use array::ArrayTrait;
use starknet::ContractAddress;

#[starknet::interface]
trait IFarmer<TContractState> {
    // Farmer
    fn get_carbonable_project_address(self: @TContractState) -> ContractAddress;
    fn get_carbonable_project_slot(self: @TContractState) -> u256;
    fn get_total_deposited(self: @TContractState) -> u256;
    fn get_total_absorption(self: @TContractState) -> u256;
    fn get_max_absorption(self: @TContractState) -> u256;
    fn get_total_sale(self: @TContractState) -> u256;
    fn get_max_sale(self: @TContractState) -> u256;
    fn get_deposited_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_absorption_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_sale_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_current_price(self: @TContractState) -> u256;
    fn get_prices(self: @TContractState) -> (Array<u64>, Array<u256>, Array<u256>, Array<u256>);
    fn get_apr(self: @TContractState, minter: ContractAddress) -> (u256, u256);
    fn deposit(ref self: TContractState, token_id: u256, value: u256);
    fn withdraw_to(ref self: TContractState, value: u256);
    fn withdraw_to_token(ref self: TContractState, token_id: u256, value: u256);
    fn add_price(ref self: TContractState, time: u64, price: u256);
    fn update_last_price(ref self: TContractState, time: u64, price: u256);
    fn set_prices(ref self: TContractState, times: Array<u64>, prices: Array<u256>);
}
