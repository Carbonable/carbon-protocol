#[starknet::contract]
mod Metadata {
    // Starknet imports

    use starknet::ClassHash;
    use starknet::ContractAddress;

    // External imports

    use cairo_erc_3525::presets::erc3525_mintable_burnable_metadata_slot_approvable_slot_enumerable::ERC3525MintableBurnableMSASE as ERC3525;

    // Internal imports

    use carbon::components::metadata::interface::{
        IContractDescriptor, ISlotDescriptor, IMetadata, IContractDescriptorLibraryDispatcher,
        IContractDescriptorDispatcherTrait, ISlotDescriptorLibraryDispatcher,
        ISlotDescriptorDispatcherTrait,
    };

    #[storage]
    struct Storage {
        _metadata_provider: ContractAddress,
        _metadata_contract_implementation: ClassHash,
        _metadata_slot_implementation: LegacyMap<u256, ClassHash>,
    }

    #[external(v0)]
    impl ContractDescriptorImpl of IContractDescriptor<ContractState> {
        fn construct_contract_uri(self: @ContractState) -> Span<felt252> {
            let implementation: ClassHash = self._metadata_contract_implementation.read();
            let metadata_library = IContractDescriptorLibraryDispatcher {
                class_hash: implementation
            };
            metadata_library.construct_contract_uri()
        }
    }
    #[external(v0)]
    impl SlotDescriptorImpl of ISlotDescriptor<ContractState> {
        fn construct_slot_uri(self: @ContractState, slot: u256) -> Span<felt252> {
            let implementation: ClassHash = self._metadata_slot_implementation.read(slot);
            if implementation.is_zero() {
                return Default::default().span();
            }
            let metadata_library = ISlotDescriptorLibraryDispatcher { class_hash: implementation };
            metadata_library.construct_slot_uri(slot)
        }

        fn construct_token_uri(self: @ContractState, token_id: u256) -> Span<felt252> {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            let slot = ERC3525::ERC3525Impl::slot_of(@unsafe_state, token_id);
            let implementation: ClassHash = self._metadata_slot_implementation.read(slot);
            if implementation.is_zero() {
                return Default::default().span();
            }
            let metadata_library = ISlotDescriptorLibraryDispatcher { class_hash: implementation };
            metadata_library.construct_token_uri(token_id)
        }
    }

    impl MetadataImpl of IMetadata<ContractState> {
        fn get_contract_uri_implementation(self: @ContractState) -> ClassHash {
            self._metadata_contract_implementation.read()
        }

        fn get_slot_uri_implementation(self: @ContractState, slot: u256) -> ClassHash {
            self._metadata_slot_implementation.read(slot)
        }

        fn set_contract_uri_implementation(ref self: ContractState, implementation: ClassHash) {
            assert(implementation.is_non_zero(), 'Implementation cannot be 0');
            self._metadata_contract_implementation.write(implementation);
        }

        fn set_slot_uri_implementation(
            ref self: ContractState, slot: u256, implementation: ClassHash
        ) {
            assert(implementation.is_non_zero(), 'Implementation cannot be 0');
            assert(slot.is_non_zero(), 'Slot cannot be 0');
            self._metadata_slot_implementation.write(slot, implementation);
        }

        fn get_component_provider(self: @ContractState) -> ContractAddress {
            self._metadata_provider.read()
        }

        fn set_component_provider(ref self: ContractState, provider: ContractAddress) {
            self._metadata_provider.write(provider);
        }
    }
}


#[cfg(test)]
mod Test {
    use starknet::ClassHash;
    use starknet::testing::set_caller_address;
    use super::Metadata;

    use carbon::components::metadata::interface::{
        IContractDescriptorLibraryDispatcher, IContractDescriptorDispatcherTrait,
        ISlotDescriptorLibraryDispatcher, ISlotDescriptorDispatcherTrait,
    };

    fn STATE() -> Metadata::ContractState {
        Metadata::unsafe_new_contract_state()
    }

    #[starknet::contract]
    mod MetadataTest {
        use super::Metadata;

        #[storage]
        struct Storage {}

        #[external(v0)]
        impl ContractDescriptorTestImpl of Metadata::IContractDescriptor<ContractState> {
            fn construct_contract_uri(self: @ContractState) -> Span<felt252> {
                array!['http://example.com/', 'contract/uri.json'].span()
            }
        }
        #[external(v0)]
        impl SlotDescriptorTestImpl of Metadata::ISlotDescriptor<ContractState> {
            fn construct_slot_uri(self: @ContractState, slot: u256) -> Span<felt252> {
                array!['http://example.com/', 'slot/uri.json'].span()
            }

            fn construct_token_uri(self: @ContractState, token_id: u256) -> Span<felt252> {
                array!['http://example.com/', 'token/uri.json'].span()
            }
        }
    }

    #[test]
    #[available_gas(100_000)]
    fn test_initial_storage() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Initialization pass
        let class = Metadata::MetadataImpl::get_contract_uri_implementation(@state);
        assert(class.is_zero(), 'Implementation should be 0');
        let class = Metadata::MetadataImpl::get_slot_uri_implementation(@state, 1);
        assert(class.is_zero(), 'Implementation should be 0');
        let address = Metadata::MetadataImpl::get_component_provider(@state);
        assert(address.is_zero(), 'Implementation should be 0');
    }

    #[test]
    #[available_gas(500_000)]
    fn test_contract_uri_setup() {
        // [Setup]
        let mut state = STATE();

        let class: ClassHash = MetadataTest::TEST_CLASS_HASH.try_into().unwrap();

        Metadata::MetadataImpl::set_contract_uri_implementation(ref state, class);

        let contract_uri_class = Metadata::MetadataImpl::get_contract_uri_implementation(@state);
        assert(contract_uri_class.into() == class, 'Implementation should be set');

        let metadata_class: ClassHash = Metadata::TEST_CLASS_HASH.try_into().unwrap();

        let contract_metadata_library = IContractDescriptorLibraryDispatcher {
            class_hash: metadata_class
        };
        let contract_uri = contract_metadata_library.construct_contract_uri();
        assert(
            contract_uri == array!['http://example.com/', 'contract/uri.json'].span(),
            'Contract URI error'
        );
    }

    #[test]
    #[available_gas(500_000)]
    fn test_slot_uri_setup() {
        // [Setup]
        let mut state = STATE();

        let class: ClassHash = MetadataTest::TEST_CLASS_HASH.try_into().unwrap();

        Metadata::MetadataImpl::set_slot_uri_implementation(ref state, 1, class);

        let slot_uri_class = Metadata::MetadataImpl::get_slot_uri_implementation(@state, 1);
        assert(slot_uri_class.into() == class, 'Implementation should be set');

        let metadata_class: ClassHash = Metadata::TEST_CLASS_HASH.try_into().unwrap();

        let slot_metadata_library = ISlotDescriptorLibraryDispatcher { class_hash: metadata_class };
        let slot_uri = slot_metadata_library.construct_slot_uri(1);
        assert(slot_uri == array!['http://example.com/', 'slot/uri.json'].span(), 'Slot URI error');
    }

    #[test]
    #[available_gas(10_000_000)]
    #[should_panic(expected: ('ERC3525: token not minted', 'ENTRYPOINT_FAILED'))]
    // Can't mock ERC3525 token minting, so we just check the error message.
    fn test_token_uri_setup() {
        // [Setup]
        let mut state = STATE();

        let class: ClassHash = MetadataTest::TEST_CLASS_HASH.try_into().unwrap();

        Metadata::MetadataImpl::set_slot_uri_implementation(ref state, 1, class);

        let slot_uri_class = Metadata::MetadataImpl::get_slot_uri_implementation(@state, 1);
        assert(slot_uri_class.into() == class, 'Implementation should be set');

        let metadata_class: ClassHash = Metadata::TEST_CLASS_HASH.try_into().unwrap();

        let slot_metadata_library = ISlotDescriptorLibraryDispatcher { class_hash: metadata_class };

        let token_uri = slot_metadata_library.construct_token_uri(1);
        assert(
            token_uri == array!['http://example.com/', 'token/uri.json'].span(), 'Slot URI error'
        );
    }
}
