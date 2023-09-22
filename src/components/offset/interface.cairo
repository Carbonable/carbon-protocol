use starknet::ContractAddress;

#[starknet::interface]
trait IOffset<TContractState> {
    fn get_total_claimable(self: @TContractState) -> u256;
    fn get_total_claimed(self: @TContractState) -> u256;
    fn get_claimable_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_claimed_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_min_claimable(self: @TContractState) -> u256;
    fn claim(ref self: TContractState, amount: u256);
    fn claim_all(ref self: TContractState);
    fn set_min_claimable(ref self: TContractState, min_claimable: u256);
}
