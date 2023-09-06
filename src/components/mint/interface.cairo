use starknet::ContractAddress;

#[starknet::interface]
trait IMint<TContractState> {
    fn get_carbonable_project_address(self: @TContractState) -> ContractAddress;
    fn get_carbonable_project_slot(self: @TContractState) -> u256;
    fn get_payment_token_address(self: @TContractState) -> ContractAddress;
    fn is_pre_sale_open(self: @TContractState) -> bool;
    fn is_public_sale_open(self: @TContractState) -> bool;
    fn get_min_value_per_tx(self: @TContractState) -> u256;
    fn get_max_value_per_tx(self: @TContractState) -> u256;
    fn get_unit_price(self: @TContractState) -> u256;
    fn get_reserved_value(self: @TContractState) -> u256;
    fn get_max_value(self: @TContractState) -> u256;
    fn get_whitelist_merkle_root(self: @TContractState) -> felt252;
    fn get_whitelist_allocation(self: @TContractState, account: ContractAddress, allocation: u256, proof: Span<felt252>) -> u256;
    fn get_claimed_value(self: @TContractState, account: ContractAddress) -> u256;
    fn is_sold_out(self: @TContractState) -> bool;
    fn set_whitelist_merkle_root(ref self: TContractState, whitelist_merkle_root: felt252);
    fn set_public_sale_open(ref self: TContractState, public_sale_open: bool);
    fn set_max_value_per_tx(ref self: TContractState, max_value_per_tx: u256);
    fn set_min_value_per_tx(ref self: TContractState, min_value_per_tx: u256);
    fn set_unit_price(ref self: TContractState, unit_price: u256);
    fn decrease_reserved_value(ref self: TContractState, value: u256);
    fn airdrop(ref self: TContractState, to: ContractAddress, value: u256);
    fn withdraw(ref self: TContractState);
    fn transfer(ref self: TContractState, token_address: ContractAddress, recipient: ContractAddress, amount: u256);
    fn pre_buy(ref self: TContractState, allocation: u256, proof: Span<felt252>, value: u256, force: bool);
    fn public_buy(ref self: TContractState, value: u256, force: bool);
}
