use starknet::ContractAddress;

#[starknet::interface]
trait IExternal<ContractState> {
    fn total_value(self: @ContractState, slot: u256) -> u256;
    fn mint(ref self: ContractState, to: ContractAddress, slot: u256, value: u256) -> u256;
    fn mint_value(ref self: ContractState, token_id: u256, value: u256);
    fn burn(ref self: ContractState, token_id: u256);
    fn burn_value(ref self: ContractState, token_id: u256, value: u256);
}


#[starknet::contract]
mod Project {
    use core::traits::Into;
    use starknet::{get_caller_address, ContractAddress, ClassHash};

    // Ownable
    use openzeppelin::access::ownable::interface::IOwnable;
    use openzeppelin::access::ownable::ownable::Ownable;

    // Upgradable
    use openzeppelin::upgrades::interface::IUpgradeable;
    use openzeppelin::upgrades::upgradeable::Upgradeable;

    //SRC5
    use openzeppelin::introspection::interface::{ISRC5, ISRC5Camel};
    use openzeppelin::introspection::src5::SRC5;

    // ERC721
    use openzeppelin::token::erc721::interface::{
        IERC721, IERC721Metadata, IERC721CamelOnly, IERC721MetadataCamelOnly
    };

    // ERC3525
    use cairo_erc_3525::interface::IERC3525;
    use cairo_erc_3525::extensions::metadata::interface::IERC3525Metadata;
    use cairo_erc_3525::extensions::slotapprovable::interface::IERC3525SlotApprovable;
    use cairo_erc_3525::extensions::slotenumerable::interface::IERC3525SlotEnumerable;
    use cairo_erc_3525::presets::erc3525_mintable_burnable_metadata_slot_approvable_slot_enumerable::ERC3525MintableBurnableMSASE as ERC3525;

    // Access control
    use carbon::components::access::interface::{IMinter, ICertifier};
    use carbon::components::access::module::Access;

    // Absorber
    use carbon::components::absorber::interface::IAbsorber;
    use carbon::components::absorber::module::Absorber;

    // Metadata
    use carbon::components::metadata::interface::{IContractDescriptor, ISlotDescriptor, IMetadata};
    use carbon::components::metadata::module::Metadata;

    const IERC165_BACKWARD_COMPATIBLE_ID: u32 = 0x80ac58cd_u32;

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnershipTransferred: OwnershipTransferred,
        Upgraded: Upgraded,
        Transfer: Transfer,
        Approval: Approval,
        ApprovalForAll: ApprovalForAll,
        ApprovalForSlot: ApprovalForSlot,
        TransferValue: TransferValue,
        ApprovalValue: ApprovalValue,
        SlotChanged: SlotChanged,
    }

    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        previous_owner: ContractAddress,
        new_owner: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct Upgraded {
        class_hash: ClassHash
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        #[key]
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        approved: ContractAddress,
        #[key]
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalForAll {
        #[key]
        owner: ContractAddress,
        #[key]
        operator: ContractAddress,
        approved: bool
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalForSlot {
        owner: ContractAddress,
        slot: u256,
        operator: ContractAddress,
        approved: bool,
    }

    #[derive(Drop, starknet::Event)]
    struct TransferValue {
        from_token_id: u256,
        to_token_id: u256,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalValue {
        token_id: u256,
        operator: ContractAddress,
        value: u256
    }

    #[derive(Drop, starknet::Event)]
    struct SlotChanged {
        token_id: u256,
        old_slot: u256,
        new_slot: u256,
    }

    // Constructor

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
        value_decimals: u8,
        owner: ContractAddress
    ) {
        self.initializer(name, symbol, value_decimals, owner);
    }

    // Upgradable

    #[external(v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Upgrade
            let mut unsafe_state = Upgradeable::unsafe_new_contract_state();
            Upgradeable::InternalImpl::_upgrade(ref unsafe_state, new_class_hash)
        }
    }

    // Access control

    #[external(v0)]
    impl OwnableImpl of IOwnable<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::OwnableImpl::owner(@unsafe_state)
        }

        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::OwnableImpl::transfer_ownership(ref unsafe_state, new_owner)
        }

        fn renounce_ownership(ref self: ContractState) {
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::OwnableImpl::renounce_ownership(ref unsafe_state)
        }
    }

    #[external(v0)]
    impl MinterImpl of IMinter<ContractState> {
        fn get_minters(self: @ContractState, slot: u256) -> Span<ContractAddress> {
            let unsafe_state = Access::unsafe_new_contract_state();
            Access::MinterImpl::get_minters(@unsafe_state, slot)
        }

        fn add_minter(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Add minter
            let mut unsafe_state = Access::unsafe_new_contract_state();
            Access::MinterImpl::add_minter(ref unsafe_state, slot, user)
        }

        fn revoke_minter(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Revoke minter
            let mut unsafe_state = Access::unsafe_new_contract_state();
            Access::MinterImpl::revoke_minter(ref unsafe_state, slot, user)
        }
    }

    #[external(v0)]
    impl CertifierImpl of ICertifier<ContractState> {
        fn get_certifier(self: @ContractState, slot: u256) -> ContractAddress {
            let unsafe_state = Access::unsafe_new_contract_state();
            Access::CertifierImpl::get_certifier(@unsafe_state, slot)
        }

        fn set_certifier(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set certifier
            let mut unsafe_state = Access::unsafe_new_contract_state();
            Access::CertifierImpl::set_certifier(ref unsafe_state, slot, user)
        }
    }

    // SRC5

    #[external(v0)]
    impl SRC5Impl of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            if interface_id == IERC165_BACKWARD_COMPATIBLE_ID.into() {
                return true;
            }
            let unsafe_state = SRC5::unsafe_new_contract_state();
            SRC5::SRC5Impl::supports_interface(@unsafe_state, interface_id)
        }
    }

    #[external(v0)]
    impl SRC5CamelImpl of ISRC5Camel<ContractState> {
        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            self.supports_interface(interfaceId)
        }
    }

    // ERC721

    #[external(v0)]
    impl ERC721Impl of IERC721<ContractState> {
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::balance_of(@unsafe_state, account)
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::owner_of(@unsafe_state, token_id)
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::get_approved(@unsafe_state, token_id)
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::is_approved_for_all(@unsafe_state, owner, operator)
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::approve(ref unsafe_state, to, token_id)
        }

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::set_approval_for_all(ref unsafe_state, operator, approved)
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::transfer_from(ref unsafe_state, from, to, token_id)
        }

        fn safe_transfer_from(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::safe_transfer_from(ref unsafe_state, from, to, token_id, data)
        }
    }

    // ERC721 CamelOnly

    #[external(v0)]
    impl IERC721CamelOnlyImpl of IERC721CamelOnly<ContractState> {
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::balance_of(@unsafe_state, account)
        }

        fn ownerOf(self: @ContractState, tokenId: u256) -> ContractAddress {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::owner_of(@unsafe_state, tokenId)
        }

        fn getApproved(self: @ContractState, tokenId: u256) -> ContractAddress {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::get_approved(@unsafe_state, tokenId)
        }

        fn isApprovedForAll(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::is_approved_for_all(@unsafe_state, owner, operator)
        }

        fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::set_approval_for_all(ref unsafe_state, operator, approved)
        }

        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, tokenId: u256
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::transfer_from(ref unsafe_state, from, to, tokenId)
        }

        fn safeTransferFrom(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            tokenId: u256,
            data: Span<felt252>
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721Impl::safe_transfer_from(ref unsafe_state, from, to, tokenId, data)
        }
    }

    #[generate_trait]
    #[external(v0)]
    impl ERC721MetadataImpl of IERC721MetadataFeltSpan {
        fn name(self: @ContractState) -> felt252 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721MetadataImpl::name(@unsafe_state)
        }

        fn symbol(self: @ContractState) -> felt252 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC721MetadataImpl::symbol(@unsafe_state)
        }

        fn token_uri(self: @ContractState, token_id: u256) -> Span<felt252> {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::SlotDescriptorImpl::construct_token_uri(@unsafe_state, token_id)
        }

        fn tokenURI(self: @ContractState, tokenId: u256) -> Span<felt252> {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            self.token_uri(tokenId)
        }
    }

    // ERC3525

    #[external(v0)]
    impl ERC3525Impl of IERC3525<ContractState> {
        fn value_decimals(self: @ContractState) -> u8 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525Impl::value_decimals(@unsafe_state)
        }

        fn value_of(self: @ContractState, token_id: u256) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525Impl::value_of(@unsafe_state, token_id)
        }

        fn slot_of(self: @ContractState, token_id: u256) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525Impl::slot_of(@unsafe_state, token_id)
        }

        fn approve_value(
            ref self: ContractState, token_id: u256, operator: ContractAddress, value: u256
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525Impl::approve_value(ref unsafe_state, token_id, operator, value)
        }

        fn allowance(self: @ContractState, token_id: u256, operator: ContractAddress) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525Impl::allowance(@unsafe_state, token_id, operator)
        }

        fn transfer_value_from(
            ref self: ContractState,
            from_token_id: u256,
            to_token_id: u256,
            to: ContractAddress,
            value: u256
        ) -> u256 {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525Impl::transfer_value_from(
                ref unsafe_state, from_token_id, to_token_id, to, value
            )
        }
    }

    #[generate_trait]
    #[external(v0)]
    impl ERC3525MetadataImpl of IERC3525MetadataFeltSpan {
        fn contract_uri(self: @ContractState) -> Span<felt252> {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::ContractDescriptorImpl::construct_contract_uri(@unsafe_state)
        }

        fn slot_uri(self: @ContractState, slot: u256) -> Span<felt252> {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::SlotDescriptorImpl::construct_slot_uri(@unsafe_state, slot)
        }

        fn contractUri(self: @ContractState) -> Span<felt252> {
            self.contract_uri()
        }

        fn slotUri(self: @ContractState, slot: u256) -> Span<felt252> {
            self.slot_uri(slot)
        }
    }

    #[external(v0)]
    impl ERC3525SlotApprovableImpl of IERC3525SlotApprovable<ContractState> {
        fn set_approval_for_slot(
            ref self: ContractState,
            owner: ContractAddress,
            slot: u256,
            operator: ContractAddress,
            approved: bool
        ) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525SlotApprovableImpl::set_approval_for_slot(
                ref unsafe_state, owner, slot, operator, approved
            )
        }

        fn is_approved_for_slot(
            self: @ContractState, owner: ContractAddress, slot: u256, operator: ContractAddress
        ) -> bool {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525SlotApprovableImpl::is_approved_for_slot(
                @unsafe_state, owner, slot, operator
            )
        }
    }

    #[external(v0)]
    impl ERC3525SlotEnumerableImpl of IERC3525SlotEnumerable<ContractState> {
        fn slot_count(self: @ContractState) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525SlotEnumerableImpl::slot_count(@unsafe_state)
        }

        fn slot_by_index(self: @ContractState, index: u256) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525SlotEnumerableImpl::slot_by_index(@unsafe_state, index)
        }

        fn token_supply_in_slot(self: @ContractState, slot: u256) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525SlotEnumerableImpl::token_supply_in_slot(@unsafe_state, slot)
        }

        fn token_in_slot_by_index(self: @ContractState, slot: u256, index: u256) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ERC3525SlotEnumerableImpl::token_in_slot_by_index(@unsafe_state, slot, index)
        }
    }

    // Externals

    #[external(v0)]
    impl ExternalImpl of super::IExternal<ContractState> {
        fn total_value(self: @ContractState, slot: u256) -> u256 {
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ExternalImpl::total_value(@unsafe_state, slot)
        }

        fn mint(ref self: ContractState, to: ContractAddress, slot: u256, value: u256) -> u256 {
            // [Check] Only minter
            let unsafe_state = Access::unsafe_new_contract_state();
            Access::InternalImpl::assert_only_minter(@unsafe_state, slot);
            // [Effect] Mint value
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ExternalImpl::mint(ref unsafe_state, to, slot, value)
        }

        fn mint_value(ref self: ContractState, token_id: u256, value: u256) {
            // [Check] Only minter
            let unsafe_sate = ERC3525::unsafe_new_contract_state();
            let slot = ERC3525::ERC3525Impl::slot_of(@unsafe_sate, token_id);
            let unsafe_state = Access::unsafe_new_contract_state();
            Access::InternalImpl::assert_only_minter(@unsafe_state, slot);
            // [Effect] Mint value
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ExternalImpl::mint_value(ref unsafe_state, token_id, value)
        }

        fn burn(ref self: ContractState, token_id: u256) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ExternalImpl::burn(ref unsafe_state, token_id)
        }

        fn burn_value(ref self: ContractState, token_id: u256, value: u256) {
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::ExternalImpl::burn_value(ref unsafe_state, token_id, value)
        }
    }

    // Absorber

    #[external(v0)]
    impl AbsorberImpl of IAbsorber<ContractState> {
        fn get_start_time(self: @ContractState, slot: u256) -> u64 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_start_time(@unsafe_state, slot)
        }

        fn get_final_time(self: @ContractState, slot: u256) -> u64 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_final_time(@unsafe_state, slot)
        }

        fn get_times(self: @ContractState, slot: u256) -> Span<u64> {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_times(@unsafe_state, slot)
        }

        fn get_absorptions(self: @ContractState, slot: u256) -> Span<u64> {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_absorptions(@unsafe_state, slot)
        }

        fn get_absorption(self: @ContractState, slot: u256, time: u64) -> u64 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_absorption(@unsafe_state, slot, time)
        }

        fn get_current_absorption(self: @ContractState, slot: u256) -> u64 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_current_absorption(@unsafe_state, slot)
        }

        fn get_final_absorption(self: @ContractState, slot: u256) -> u64 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_final_absorption(@unsafe_state, slot)
        }

        fn get_project_value(self: @ContractState, slot: u256) -> u256 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_project_value(@unsafe_state, slot)
        }

        fn get_ton_equivalent(self: @ContractState, slot: u256) -> u64 {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::get_ton_equivalent(@unsafe_state, slot)
        }

        fn is_setup(self: @ContractState, slot: u256) -> bool {
            let unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::is_setup(@unsafe_state, slot)
        }

        fn set_absorptions(
            ref self: ContractState,
            slot: u256,
            times: Span<u64>,
            absorptions: Span<u64>,
            ton_equivalent: u64
        ) {
            // [Check] Only certifier
            let unsafe_state = Access::unsafe_new_contract_state();
            let certifier = Access::InternalImpl::assert_only_certifier(@unsafe_state, slot);
            // [Effect] Set absorptions
            let mut unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::set_absorptions(
                ref unsafe_state, slot, times, absorptions, ton_equivalent
            )
        }

        fn set_project_value(ref self: ContractState, slot: u256, project_value: u256) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);

            // [Check] New Project value is more to total value already minted
            let unsafe_state = ERC3525::unsafe_new_contract_state();
            let total_value = ERC3525::ExternalImpl::total_value(@unsafe_state, slot);
            assert(project_value >= total_value, 'Ttl value greater than Pt value');

            // [Effect] Set project value
            let mut unsafe_state = Absorber::unsafe_new_contract_state();
            Absorber::AbsorberImpl::set_project_value(ref unsafe_state, slot, project_value)
        }
    }

    // Metadata

    #[external(v0)]
    impl MetadataImpl of IMetadata<ContractState> {
        fn get_contract_uri_implementation(self: @ContractState) -> ClassHash {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::MetadataImpl::get_contract_uri_implementation(@unsafe_state)
        }
        fn get_slot_uri_implementation(self: @ContractState, slot: u256) -> ClassHash {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::MetadataImpl::get_slot_uri_implementation(@unsafe_state, slot)
        }
        fn get_component_provider(self: @ContractState) -> ContractAddress {
            let unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::MetadataImpl::get_component_provider(@unsafe_state)
        }
        fn set_contract_uri_implementation(ref self: ContractState, implementation: ClassHash) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set contract metadata implementation
            let mut unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::MetadataImpl::set_contract_uri_implementation(
                ref unsafe_state, implementation
            )
        }
        fn set_slot_uri_implementation(
            ref self: ContractState, slot: u256, implementation: ClassHash
        ) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set slot metadata implementation
            let mut unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::MetadataImpl::set_slot_uri_implementation(
                ref unsafe_state, slot, implementation
            )
        }
        fn set_component_provider(ref self: ContractState, provider: ContractAddress) {
            // [Check] Only owner
            let unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::assert_only_owner(@unsafe_state);
            // [Effect] Set component provider contract
            let mut unsafe_state = Metadata::unsafe_new_contract_state();
            Metadata::MetadataImpl::set_component_provider(ref unsafe_state, provider);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState,
            name: felt252,
            symbol: felt252,
            value_decimals: u8,
            owner: ContractAddress
        ) {
            // ERC721 & ERC3525
            let mut unsafe_state = ERC3525::unsafe_new_contract_state();
            ERC3525::InternalImpl::initializer(ref unsafe_state, name, symbol, value_decimals);
            // Access control
            let mut unsafe_state = Ownable::unsafe_new_contract_state();
            Ownable::InternalImpl::initializer(ref unsafe_state, owner);
            let mut unsafe_state = Access::unsafe_new_contract_state();
            Access::InternalImpl::initializer(ref unsafe_state);
        }
    }
}
