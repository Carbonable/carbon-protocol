use starknet::ContractAddress;

#[starknet::contract_state(OwnableState)]
struct OwnableStorage {
    owner: ContractAddress
}

#[starknet::interface]
trait Ownable<TContractState> {
    fn is_owner(self: @TContractState, addr: ContractAddress) -> bool;
}

#[starknet::component]
impl OwnableImpl<
    TContractState, impl I: GetComponent<TContractState, OwnableState>
> of Ownable<TContractState> {
    fn is_owner(self: @TContractState, addr: ContractAddress) -> bool {
        self.component_snap().owner.read() == addr
    }
}
