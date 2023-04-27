// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Project dependencies
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.IERC721Metadata import IERC721Metadata
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from erc3525.IERC3525Full import IERC3525Full as IERC3525
from erc2981.IERC2981 import IERC2981
from erc4906.IERC4906 import IERC4906

// Local dependencies
from src.interfaces.project import ICarbonableProject
from src.interfaces.metadata import ICarbonableMetadata
from src.utils.type.library import _felt_to_uint, _uint_to_felt

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (contract_address: felt) {
        tempvar contract_address;
        %{ ids.contract_address = context.carbonable_project_contract %}
        return (contract_address,);
    }

    //
    // Proxy administration
    //

    func get_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (implementation: felt) {
        let (contract_address) = instance.get_address();
        let (implementation) = ICarbonableProject.getImplementationHash(
            contract_address=contract_address
        );
        return (implementation,);
    }

    func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        admin: felt
    ) {
        let (contract_address) = instance.get_address();
        let (admin) = ICarbonableProject.getAdmin(contract_address=contract_address);
        return (admin,);
    }

    func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_implementation: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.upgrade(contract_address, new_implementation);
        %{ stop_prank() %}
        return ();
    }

    func set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_admin: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.setAdmin(contract_address, new_admin);
        %{ stop_prank() %}
        return ();
    }

    //
    // Ownership administration
    //

    func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
        let (contract_address) = instance.get_address();
        let (owner) = ICarbonableProject.owner(contract_address);
        return (owner,);
    }

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(newOwner: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.transferOwnership(contract_address, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func renounce_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }() {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.renounceOwnership(contract_address);
        %{ stop_prank() %}
        return ();
    }

    func add_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        slot: felt, minter: felt
    ) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.addMinter(contract_address, slot_u256, minter);
        %{ stop_prank() %}
        return ();
    }

    func get_minters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (minters_len: felt, minters: felt*) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (minters_len, minters) = ICarbonableProject.getMinters(
            contract_address=contract_address, slot=slot_u256
        );
        return (minters_len, minters);
    }

    func revoke_minter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(slot: felt, minter: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.revokeMinter(
            contract_address=contract_address, slot=slot_u256, minter=minter
        );
        %{ stop_prank() %}
        return ();
    }

    func set_certifier{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(slot: felt, certifier: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.setCertifier(
            contract_address=contract_address, slot=slot_u256, certifier=certifier
        );
        %{ stop_prank() %}
        return ();
    }

    func get_certifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (certifier: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (certifier) = ICarbonableProject.getCertifier(
            contract_address=contract_address, slot=slot_u256
        );
        return (certifier,);
    }

    //
    // ERC165
    //

    func supports_interface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        interface_id: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (success) = IERC721.supportsInterface(
            contract_address=contract_address, interfaceId=interface_id
        );
        return (success,);
    }

    //
    // ERC721
    //

    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
        let (contract_address) = instance.get_address();
        let (name) = IERC721Metadata.name(contract_address=contract_address);
        return (name,);
    }

    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        symbol: felt
    ) {
        let (contract_address) = instance.get_address();
        let (symbol) = IERC721Metadata.symbol(contract_address=contract_address);
        return (symbol,);
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt
    ) -> (balance: felt) {
        let (contract_address) = instance.get_address();
        let (balance_u256) = IERC721.balanceOf(contract_address=contract_address, owner=owner);
        let (balance) = _uint_to_felt(balance_u256);
        return (balance,);
    }

    func owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (owner: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (owner) = IERC721.ownerOf(contract_address, token_id_u256);
        return (owner,);
    }

    func get_approved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (approved: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (approved) = IERC721.getApproved(contract_address, token_id_u256);
        return (approved,);
    }

    func is_approved_for_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt, operator: felt
    ) -> (is_approved: felt) {
        let (contract_address) = instance.get_address();
        let (is_approved) = IERC721.isApprovedForAll(
            contract_address=contract_address, owner, operator
        );
        return (is_approved,);
    }

    func total_supply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
        total_supply: felt
    ) {
        let (contract_address) = instance.get_address();
        let (total_supply_u256) = IERC721Enumerable.totalSupply(contract_address);
        let (total_supply) = _uint_to_felt(total_supply_u256);
        return (total_supply,);
    }

    func token_by_index{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        index: felt
    ) -> (token_id: felt) {
        let (contract_address) = instance.get_address();
        let (index_u256) = _felt_to_uint(index);
        let (token_id_u256) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index_u256
        );
        let (token_id) = _uint_to_felt(token_id_u256);
        return (token_id,);
    }

    func token_of_owner_by_index{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        owner: felt, index: felt
    ) -> (token_id: felt) {
        let (contract_address) = instance.get_address();
        let (index_u256) = _felt_to_uint(index);
        let (token_id_u256) = IERC721Enumerable.tokenOfOwnerByIndex(
            contract_address, owner, index_u256
        );
        let (token_id) = _uint_to_felt(token_id_u256);
        return (token_id,);
    }

    func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr, caller: felt}(
        approved: felt, token_id: felt
    ) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC721.approve(contract_address, approved, token_id_u256);
        %{ stop_prank() %}
        return ();
    }

    func set_approval_for_all{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(operator: felt, approved: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC721.setApprovalForAll(contract_address, operator, approved);
        %{ stop_prank() %}
        return ();
    }

    func transfer_from{
        pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr, caller: felt
    }(from_: felt, to: felt, token_id: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC721.transferFrom(contract_address, from_, to, token_id_u256);
        %{ stop_prank() %}
        return ();
    }

    func safe_transfer_from{
        pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr, caller: felt
    }(from_: felt, to: felt, token_id: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let data_len = 0;
        let (local data: felt*) = alloc();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC721.safeTransferFrom(
            contract_address=contract_address, from_, to, token_id_u256, data_len, data
        );
        %{ stop_prank() %}
        return ();
    }

    //
    // ERC3525
    //

    func value_decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        decimals: felt
    ) {
        let (contract_address) = instance.get_address();
        let (decimals) = IERC3525.valueDecimals(contract_address);
        return (decimals,);
    }

    func value_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (balance: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (balance_u256) = IERC3525.valueOf(contract_address, token_id_u256);
        let (balance) = _uint_to_felt(balance_u256);
        return (balance,);
    }

    func slot_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (slot: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (slot_u256) = IERC3525.slotOf(contract_address, token_id_u256);
        let (slot) = _uint_to_felt(slot_u256);
        return (slot,);
    }

    func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt, operator: felt
    ) -> (amount: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (amount_u256) = IERC3525.allowance(
            contract_address=contract_address, token_id_u256, operator
        );
        let (amount) = _uint_to_felt(amount_u256);
        return (amount,);
    }

    func total_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (total: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (total_u256) = IERC3525.totalValue(contract_address, slot_u256);
        let (total) = _uint_to_felt(total_u256);
        return (total,);
    }

    func approve_value{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(token_id: felt, operator: felt, value: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC3525.approveValue(
            contract_address=contract_address, token_id_u256, operator, value_u256
        );
        %{ stop_prank() %}
        return ();
    }

    func transfer_value_from{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(from_token_id: felt, to_token_id: felt, to: felt, value: felt) -> (new_token_id: felt) {
        let (contract_address) = instance.get_address();
        let (from_token_id_u256) = _felt_to_uint(from_token_id);
        let (to_token_id_u256) = _felt_to_uint(to_token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (new_token_id_u256) = IERC3525.transferValueFrom(
            contract_address, from_token_id, to_token_id, to, value_u256
        );
        %{ stop_prank() %}
        let (new_token_id) = _uint_to_felt(new_token_id_u256);
        return (new_token_id);
    }

    //
    // ERC3525 - SlotApprovable
    //

    func slot_count{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        count: felt
    ) {
        let (contract_address) = instance.get_address();
        let (count_u256) = IERC3525.slotCount(contract_address);
        let (count) = _uint_to_felt(count_u256);
        return (count,);
    }

    func slot_by_index{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt
    ) -> (slot: felt) {
        let (contract_address) = instance.get_address();
        let (index_u256) = _felt_to_uint(index);
        let (slot_u256) = IERC3525.slotByIndex(contract_address, index_u256);
        let (slot) = _uint_to_felt(slot_u256);
        return (slot,);
    }

    func token_supply_in_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (total_amount: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (total_amount_u256) = IERC3525.tokenSupplyInSlot(
            contract_address=contract_address, slot_u256
        );
        let (total_amount) = _uint_to_felt(total_amount_u256);
        return (total_amount,);
    }

    func token_in_slot_by_index{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt, index: felt
    ) -> (token_id: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (index_u256) = _felt_to_uint(index);
        let (token_id_u256) = IERC3525.tokenInSlotByIndex(contract_address, slot_u256, index_u256);
        let (token_id) = _uint_to_felt(token_id_u256);
        return (token_id);
    }

    func is_approved_for_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt, slot: felt, operator: felt
    ) -> (is_approved: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (is_approved) = IERC3525.isApprovedForSlot(
            contract_address, owner, slot_u256, operator
        );
        return (is_approved);
    }

    func set_approval_for_slot{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(owner: felt, slot: felt, operator: felt, approved: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC3525.setApprovalForSlot(
            contract_address=contract_address,
            owner=owner,
            slot=slot_u256,
            operator=operator,
            approved=approved,
        );
        %{ stop_prank() %}
        return ();
    }

    //
    // ERC3525 - Metadata
    //

    func contract_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        uri_len: felt, uri: felt*
    ) {
        let (contract_address) = instance.get_address();
        let (uri_len, uri) = ICarbonableMetadata.contractURI(contract_address);
        return (uri_len, uri);
    }

    func slot_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: felt) -> (
        uri_len: felt, uri: felt*
    ) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (uri_len, uri) = ICarbonableMetadata.slotURI(
            contract_address=contract_address, slot_u256
        );
        return (uri_len, uri);
    }

    func token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (uri_len: felt, uri: felt*) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (uri_len, uri) = ICarbonableMetadata.tokenURI(
            contract_address=contract_address, tokenId=token_id_u256
        );
        return (uri_len, uri);
    }

    func get_metadata_implementation{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (implementation: felt) {
        let (contract_address) = instance.get_address();
        let (implementation) = ICarbonableMetadata.getMetadataImplementation(
            contract_address=contract_address
        );
        return (implementation,);
    }

    func set_metadata_implementation{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(implementation: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMetadata.setMetadataImplementation(
            contract_address=contract_address, implementation=implementation
        );
        %{ stop_prank() %}
        return ();
    }

    //
    // Mint and Burn
    //

    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        to: felt, token_id: felt, slot: felt, value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (slot_u256) = _felt_to_uint(slot);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC3525.mint(contract_address, to, token_id_u256, slot_u256, value_u256);
        %{ stop_prank() %}
        return ();
    }

    func mint_new{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        to: felt, slot: felt, value: felt
    ) -> (token_id: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (token_id_u256) = IERC3525.mintNew(
            contract_address=contract_address, to, slot_u256, value_u256
        );
        %{ stop_prank() %}
        let (token_id) = _uint_to_felt(token_id_u256);
        return (token_id);
    }

    func mint_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        token_id: felt, value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC3525.mintValue(contract_address, token_id_u256, value_u256);
        %{ stop_prank() %}
        return ();
    }

    func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        token_id: felt
    ) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC3525.burn(contract_address, token_id_u256);
        %{ stop_prank() %}
        return ();
    }

    func burn_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        token_id: felt, value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC3525.burnValue(contract_address, token_id_u256, value_u256);
        %{ stop_prank() %}
        return ();
    }

    //
    // ERC2981
    //

    func default_royalty{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        receiver: felt, feeNumerator: felt, feeDenominator: felt
    ) {
        let (contract_address) = instance.get_address();
        let (receiver, fee_numerator, fee_denominator) = IERC2981.defaultRoyalty(contract_address);
        return (receiver, fee_numerator, fee_denominator);
    }

    func token_royalty{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (receiver: felt, feeNumerator: felt, feeDenominator: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (receiver, fee_numerator, fee_denominator) = IERC2981.tokenRoyalty(
            contract_address, token_id_u256
        );
        return (receiver, fee_numerator, fee_denominator);
    }

    func royalty_info{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt, sale_price: felt
    ) -> (receiver: felt, royalty_amount: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (sale_price_u256) = _felt_to_uint(sale_price);
        let (receiver, royalty_amount_u256) = IERC2981.royaltyInfo(
            contract_address, token_id_u256, sale_price_u256
        );
        let (royalty_amount) = _uint_to_felt(royalty_amount_u256);
        return (receiver, royalty_amount);
    }

    func set_default_royalty{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(receiver: felt, fee_numerator: felt, fee_denominator: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC2981.setDefaultRoyalty(
            contract_address=contract_address, receiver, fee_numerator, fee_denominator
        );
        %{ stop_prank() %}
        return ();
    }

    func set_token_royalty{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(token_id: felt, receiver: felt, fee_numerator: felt, fee_denominator: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC2981.setTokenRoyalty(
            contract_address, token_id_u256, receiver, fee_numerator, fee_denominator
        );
        %{ stop_prank() %}
        return ();
    }

    //
    // ERC4906
    //

    func emit_batch_metadata_update{
        pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr, caller: felt
    }(from_token_id: felt, to_token_id: felt) {
        let (contract_address) = instance.get_address();
        let (from_token_id_u256) = _felt_to_uint(from_token_id);
        let (to_token_id_u256) = _felt_to_uint(to_token_id);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        IERC4906.emitBatchMetadataUpdate(
            contract_address=contract_address, from_token_id_u256, to_token_id_u256
        );
        %{ stop_prank() %}
        return ();
    }

    //
    // Carbonable
    //

    func get_start_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (time: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (time) = ICarbonableProject.getStartTime(contract_address, slot_u256);
        return (time,);
    }

    func get_final_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (time: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (time) = ICarbonableProject.getFinalTime(contract_address, slot_u256);
        return (time,);
    }

    func get_times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: felt) -> (
        times_len: felt, times: felt*
    ) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (times_len, times) = ICarbonableProject.getTimes(
            contract_address=contract_address, slot_u256
        );
        return (times_len, times);
    }

    func get_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (absorptions_len: felt, absorptions: felt*) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (absorptions_len, absorptions) = ICarbonableProject.getAbsorptions(
            contract_address, slot_u256
        );
        return (absorptions_len, absorptions);
    }

    func get_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt, time: felt
    ) -> (absorption: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot_u256, time
        );
        return (absorption,);
    }

    func get_current_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (absorption: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address, slot=slot_u256
        );
        return (absorption,);
    }

    func get_final_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (absorption: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (absorption) = ICarbonableProject.getFinalAbsorption(
            contract_address=contract_address, slot=slot_u256
        );
        return (absorption,);
    }

    func get_ton_equivalent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt
    ) -> (ton_equivalent: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (ton_equivalent) = ICarbonableProject.getTonEquivalent(
            contract_address=contract_address, slot=slot_u256
        );
        return (ton_equivalent);
    }

    func is_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: felt) -> (
        status: felt
    ) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        let (status) = ICarbonableProject.isSetup(
            contract_address=contract_address, slot=slot_u256
        );
        return (status);
    }

    func set_absorptions{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(
        slot: felt,
        times_len: felt,
        times: felt*,
        absorptions_len: felt,
        absorptions: felt*,
        ton_equivalent: felt,
    ) {
        alloc_locals;

        let (contract_address) = instance.get_address();
        let (slot_u256) = _felt_to_uint(slot);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableProject.setAbsorptions(
            contract_address=contract_address,
            slot=slot_u256,
            times_len=times_len,
            times=times,
            absorptions_len=absorptions_len,
            absorptions=absorptions,
            ton_equivalent=ton_equivalent,
        );
        %{ stop_prank() %}
        return ();
    }
}
