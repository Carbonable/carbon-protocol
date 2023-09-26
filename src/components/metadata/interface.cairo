use starknet::ClassHash;
use starknet::ContractAddress;

#[starknet::interface]
trait IContractDescriptor<T> {
    fn construct_contract_uri(self: @T) -> Span<felt252>;
}
#[starknet::interface]
trait ISlotDescriptor<T> {
    fn construct_slot_uri(self: @T, slot: u256) -> Span<felt252>;
    fn construct_token_uri(self: @T, token_id: u256) -> Span<felt252>;
}

#[starknet::interface]
trait IMetadata<T> {
    fn get_component_provider(self: @T) -> ContractAddress;
    fn set_component_provider(ref self: T, provider: ContractAddress);
    fn get_contract_uri_implementation(self: @T) -> ClassHash;
    fn get_slot_uri_implementation(self: @T, slot: u256) -> ClassHash;
    fn set_contract_uri_implementation(ref self: T, implementation: ClassHash);
    fn set_slot_uri_implementation(ref self: T, slot: u256, implementation: ClassHash);
}

