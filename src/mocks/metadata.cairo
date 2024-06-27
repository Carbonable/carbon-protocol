#[starknet::contract]
mod MetadataTest {
    use carbon::components::metadata::module::Metadata;
    use carbon::components::metadata::interface::{IContractDescriptor, ISlotDescriptor};

    #[storage]
    struct Storage {}

    #[external(v0)]
    impl ContractDescriptorTestImpl of Metadata::IContractDescriptor<ContractState> {
        fn construct_contract_uri(self: @ContractState) -> Span<felt252> {
            array!['https://dev-carbonable-metadata', '.fly.dev/collection/7'].span()
        }
    }
    #[external(v0)]
    impl SlotDescriptorTestImpl of Metadata::ISlotDescriptor<ContractState> {
        fn construct_slot_uri(self: @ContractState, slot: u256) -> Span<felt252> {
            array!['https://dev-carbonable-metadata', '.fly.dev/collection/7'].span()
        }

        fn construct_token_uri(self: @ContractState, token_id: u256) -> Span<felt252> {
            array!['https://dev-carbonable-metadata', '.fly.dev/collection/7/token'].span()
        }
    }
}
