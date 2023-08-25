use starknet::ContractAddress;

#[starknet::interface]
trait IERC3525<TContractState> {
    // IERC3525
    fn transferValueFrom(
        ref self: TContractState,
        fromTokenId: u256,
        toTokenId: u256,
        to: ContractAddress,
        value: u256
    ) -> u256;
}
