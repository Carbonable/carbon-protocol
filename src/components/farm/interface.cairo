use starknet::ContractAddress;

#[starknet::interface]
trait IFarm<TContractState> {
    fn get_carbonable_project_address(self: @TContractState) -> ContractAddress;
    fn get_carbonable_project_slot(self: @TContractState) -> u256;
    fn get_total_deposited(self: @TContractState) -> u256;
    fn get_total_absorption(self: @TContractState) -> u256;
    fn get_max_absorption(self: @TContractState) -> u256;
    fn get_deposited_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_absorption_of(self: @TContractState, account: ContractAddress) -> u256;
    fn deposit(ref self: TContractState, token_id: u256, value: u256);
    fn withdraw_to(ref self: TContractState, value: u256);
    fn withdraw_to_token(ref self: TContractState, token_id: u256, value: u256);
}

#[starknet::interface]
trait IYieldFarm<TContractState> {
    fn get_total_sale(self: @TContractState) -> u256;
    fn get_max_sale(self: @TContractState) -> u256;
    fn get_sale_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_current_price(self: @TContractState) -> u256;
    fn get_prices(self: @TContractState) -> (Span<u64>, Span<u256>);
    fn get_cumsales(self: @TContractState) -> (Span<u64>, Span<u256>, Span<u256>);
    fn get_apr(self: @TContractState, minter: ContractAddress) -> (u256, u256);
    fn add_price(ref self: TContractState, time: u64, price: u256);
    fn update_last_price(ref self: TContractState, time: u64, price: u256);
    fn set_prices(ref self: TContractState, times: Span<u64>, prices: Span<u256>);
}
