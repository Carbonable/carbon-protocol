use starknet::ContractAddress;

#[starknet::interface]
trait IFarm<TContractState> {
    /// Returns the address of the linked carbonable project.
    fn get_carbonable_project_address(self: @TContractState) -> ContractAddress;

    /// Returns the slot of the project.
    fn get_carbonable_project_slot(self: @TContractState) -> u256;

    /// Returns the total amount of value deposited to the farm.
    fn get_total_deposited(self: @TContractState) -> u256;

    /// Returns the total amount of absorption farmed up to the current block.
    fn get_total_absorption(self: @TContractState) -> u256;

    /// Returns the total amount of absorption up to the current block.
    fn get_max_absorption(self: @TContractState) -> u256;

    /// Returns the amount of value deposited by the given account.
    fn get_deposited_of(self: @TContractState, account: ContractAddress) -> u256;

    /// Returns the amount of absorption farmed by the given account.
    fn get_absorption_of(self: @TContractState, account: ContractAddress) -> u256;

    /// Deposit value to the farm from the given token_id
    fn deposit(ref self: TContractState, token_id: u256, value: u256);

    /// Withdraw the caller deposited value to the caller account.
    fn withdraw_to(ref self: TContractState, value: u256);

    /// Withdraw the caller deposited value to the given token_id
    fn withdraw_to_token(ref self: TContractState, token_id: u256, value: u256);
}

#[starknet::interface]
trait IYieldFarm<TContractState> {
    /// Returns the maximum amount of payment token bought by the farm at the current block.
    fn get_total_sale(self: @TContractState) -> u256;

    /// Returns the maximum amount of payment token that could be bought at the current block.
    fn get_max_sale(self: @TContractState) -> u256;

    /// Returns the current share of payment token of the given account.
    fn get_sale_of(self: @TContractState, account: ContractAddress) -> u256;

    /// Returns the current selling price
    fn get_current_price(self: @TContractState) -> u256;

    /// Returns the timestamp list where prices are set
    fn get_price_times(self: @TContractState) -> Span<u64>;

    /// Returns prices set at the timestamp list
    fn get_prices(self: @TContractState) -> Span<u256>;

    /// Returns the merged timestamp list 
    fn get_cumsale_times(self: @TContractState) -> Span<u64>;

    /// Returns the prices at the merged timestamps list
    fn get_updated_prices(self: @TContractState) -> Span<u256>;

    /// Returns the cumulative sales at the merged timestamps list
    fn get_cumsales(self: @TContractState) -> Span<u256>;

    /// Returns the APR of the current timestamp period
    fn get_apr(self: @TContractState, minter: ContractAddress) -> (u256, u256);

    /// Setup a list of prices at the given timestamps
    fn set_prices(ref self: TContractState, times: Span<u64>, prices: Span<u256>);
}
