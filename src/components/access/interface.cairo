use starknet::ContractAddress;

#[starknet::interface]
trait IMinter<TContractState> {
    fn get_minters(self: @TContractState, slot: u256) -> Span<ContractAddress>;
    fn add_minter(ref self: TContractState, slot: u256, user: ContractAddress);
    fn revoke_minter(ref self: TContractState, slot: u256, user: ContractAddress);
}

#[starknet::interface]
trait ICertifier<TContractState> {
    fn get_certifier(self: @TContractState, slot: u256) -> ContractAddress;
    fn set_certifier(ref self: TContractState, slot: u256, user: ContractAddress);
}

#[starknet::interface]
trait IWithdrawer<TContractState> {
    fn get_withdrawer(self: @TContractState) -> ContractAddress;
    fn set_withdrawer(ref self: TContractState, user: ContractAddress);
}
