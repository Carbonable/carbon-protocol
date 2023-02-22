// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Project dependencies
from openzeppelin.access.accesscontrol.library import AccessControl
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.upgrades.library import Proxy
from erc3525.extensions.slotapprovable.library import ERC3525SlotApprovable
from erc3525.extensions.slotenumerable.library import (
    ERC3525SlotEnumerable,
    _add_token_to_slot_enumeration,
)
from erc3525.library import ERC3525
from erc3525.periphery.library import ERC3525MetadataDescriptor

// Local dependencies
from src.project.library import CarbonableProject
from src.utils.access.library import CarbonableAccessControl

//
// Initializer
//

// @notice Initialize the contract with the given name, symbol and owner.
// @dev This constructor uses the following standards:
//   the standard OZ Proxy initializer,
//   the standard OZ ERC721 initializer,
//   the standard OZ ERC721Enumerable initializer,
//   the standard Carbonable ERC3525 initializer,
//   the standard Carbonable ERC3525SlotApprovable initializer,
//   the standard Carbonable ERC3525SlotEnumerable initializer,
//   the OZ Ownable initializer.
// @param name The name of the collection.
// @param symbol The symbol of the collection.
// @param decimals The value decimals of the collection.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt, decimals: felt, owner: felt
) {
    ERC721.initializer(name, symbol);
    ERC721Enumerable.initializer();
    ERC3525.initializer(decimals);
    ERC3525SlotApprovable.initializer();
    ERC3525SlotEnumerable.initializer();
    Ownable.initializer(owner);
    CarbonableAccessControl.initializer();
    Proxy.initializer(owner);
    return ();
}

//
// Proxy administration
//

// @notice Return the current implementation hash.
// @return implementation The implementation class hash.
@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

// @notice Return the current admin address.
// @return admin The admin address.
@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

// @notice Upgrade the contract to the new implementation.
// @dev This function is only callable by the admin.
// @param new_implementation The new implementation class hash.
@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

// @notice Transfer admin rights to a new admin.
// @dev This function is only callable by the admin.
// @param new_admin The new admin address.
@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}

//
// Ownership administration
//

// @notice Return the current owner address.
// @return owner The owner address.
@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev This function is only callable by the owner.
//   The new owner address cannot be the zero address.
// @param newOwner The new owner address.
@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

// @notice Renounce ownership.
// @dev This function is only callable by the owner.
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

//
// ERC165
//

// @notice Return the ability status to support the provided interface (EIP 165).
// @param interfaceId Interface id.
// @return success TRUE if supported else FALSE.
@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

//
// ERC721
//

// @notice A descriptive name for a collection of NFTs in this contract (EIP 721 - Metadata extension).
// @return name The name of the collection.
@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return ERC721.name();
}

// @notice An abbreviated name for NFTs in this contract (EIP 721 - Metadata extension).
// @return symbol The symbol of the collection.
@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    return ERC721.symbol();
}

// @notice Count all NFTs assigned to an owner (EIP 721).
// @dev Throws if -owner- is null.
@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    return ERC721.balance_of(owner);
}

// @notice Find the owner of an NFT (EIP 721).
// @param tokenId The identifier for an NFT.
// @return owner The address of the owner of the NFT.
@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    return ERC721.owner_of(tokenId);
}

// @notice Get the approved address for a single NFT (EIP 721).
// @dev The tokenId must be a valid NFT.
// @param tokenId The NFT to find the approved address for.
// @return approved The approved address for this NFT, or the zero address if there is none.
@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (approved: felt) {
    return ERC721.get_approved(tokenId);
}

// @notice Query if an address is an authorized operator for another address (EIP 721).
// @param owner The address that owns the NFTs.
// @param operator The address that acts on behalf of the owner.
// @return isApproved True if -operator- is an approved operator for -owner-, false otherwise.
@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (isApproved: felt) {
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved=isApproved);
}

// @notice Count NFTs tracked by this contract (EIP 721 - Enumeration extension).
// @return totalSupply A count of valid NFTs tracked by this contract, where each one of them has an assigned and queryable owner not equal to the zero address.
@view
func totalSupply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
    totalSupply: Uint256
) {
    let (totalSupply: Uint256) = ERC721Enumerable.total_supply();
    return (totalSupply=totalSupply);
}

// @notice Enumerate valid NFTs (EIP 721 - Enumeration extension).
// @dev Throws if -index- >= -totalSupply()-.
// @param index A counter less than -totalSupply()-.
// @return tokenId The token identifier for the -index-th NFT (sort order not specified).
@view
func tokenByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId: Uint256) = ERC721Enumerable.token_by_index(index);
    return (tokenId=tokenId);
}

// @notice Enumerate NFTs assigned to an owner (EIP 721 - Enumeration extension).
// @dev Throws if -index- >= -balanceOf(owner)-.
//   Throws if -owner- is the zero address, representing invalid NFTs.
// @param owner An address where we are interested in NFTs owned by them.
// @param index A counter less than -balanceOf(owner)-.
// @return tokenId The token identifier for the -index-th NFT assigned to -owner- (sort order not specified).
@view
func tokenOfOwnerByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    owner: felt, index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId: Uint256) = ERC721Enumerable.token_of_owner_by_index(owner, index);
    return (tokenId=tokenId);
}

// @notice Change or reaffirm the approved address for an NFT (EIP 721).
// @dev The caller must be the owner of the NFT or an authorized operator of the owner.
@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    ERC721.approve(to, tokenId);
    return ();
}

// @notice Enable or disable approval for a third party ("operator") to manage all of the caller's assets (EIP 721).
// @dev Emits the ApprovalForAll event.
// @param operator The address to add to the set of authorized operators.
// @param approved TRUE if the operator is approved, FALSE to revoke approval.
@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

// @notice Transfer ownership of an NFT (EIP 721).
// @dev Throws unless -from_- is the current owner, an authorized operator, or the approved address for this NFT.
//   -from_- must be the current owner.
//   -to- cannot be the zero address.
//   -tokenId- must be a valid NFT.
//  @param from_ The current owner of the NFT.
//  @param to The new owner.
//  @param tokenId The NFT to transfer.
@external
func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    ERC721Enumerable.transfer_from(from_, to, tokenId);
    return ();
}

// @notice Transfers the ownership of an NFT from one address to another address (EIP 721).
// @dev Throws unless -from_- is the current owner, an authorized operator, or the approved address for this NFT.
//   -from_- must be the current owner.
//   -to- cannot be the zero address.
//   -tokenId- must be a valid NFT.
//   -to- must be a contract account that implements the -onERC721Received- interface.
//  @param from_ The current owner of the NFT.
//  @param to The new owner.
//  @param tokenId The NFT to transfer.
//  @param data Additional data with no specified format, sent in call to -to-.
@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721Enumerable.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

// @notice Set the contract base URI.
// @dev Throws if the caller is not the owner.
//  @param uri_len The URI array length.
//  @param uri The URI characters.
@external
func setURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*) {
    Ownable.assert_only_owner();
    CarbonableProject.set_uri(uri_len, uri);
    return ();
}

//
// ERC3525
//

@view
func valueDecimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    decimals: felt
) {
    return ERC3525.value_decimals();
}

@view
func valueOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    balance: Uint256
) {
    return ERC3525.balance_of(tokenId);
}

@view
func slotOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    slot: Uint256
) {
    return ERC3525.slot_of(tokenId);
}

@view
func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, operator: felt
) -> (amount: Uint256) {
    return ERC3525.allowance(tokenId, operator);
}

@view
func totalValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
    total: Uint256
) {
    return ERC3525.total_value(slot);
}

@external
func approveValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, operator: felt, value: Uint256
) {
    ERC3525SlotApprovable.approve_value(tokenId, operator, value);
    return ();
}

@external
func transferValueFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    fromTokenId: Uint256, toTokenId: Uint256, to: felt, value: Uint256
) -> (newTokenId: Uint256) {
    alloc_locals;
    let (local new_token_id: Uint256) = ERC3525SlotApprovable.transfer_from(
        fromTokenId, toTokenId, to, value
    );

    if (to != 0) {
        // Keep enumerability
        let (slot) = ERC3525.slot_of(fromTokenId);
        _add_token_to_slot_enumeration(slot, new_token_id);
        return (newTokenId=new_token_id);
    }
    return (newTokenId=new_token_id);
}

//
// ERC3525 - SlotApprovable
//

@view
func slotCount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    count: Uint256
) {
    return ERC3525SlotEnumerable.slot_count();
}

@view
func slotByIndex{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    index: Uint256
) -> (slot: Uint256) {
    return ERC3525SlotEnumerable.slot_by_index(index);
}

@view
func tokenSupplyInSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (totalAmount: Uint256) {
    let (totalAmount) = ERC3525SlotEnumerable.token_supply_in_slot(slot);
    return (totalAmount=totalAmount);
}

@view
func tokenInSlotByIndex{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256, index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId) = ERC3525SlotEnumerable.token_in_slot_by_index(slot, index);
    return (tokenId=tokenId);
}

// @notice Query if operator is authorized to manage all of owner's tokens with the specified slot.
// @param owner The address that owns the EIP-3525 tokens.
// @param slot The slot of tokens being queried approval of.
// @param operator The address for whom to query approval.
// @return is_approved TRUE if operator is authorized to manage all of owner`'s tokens with slot, FALSE otherwise.
@view
func isApprovedForSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, slot: Uint256, operator: felt
) -> (is_approved: felt) {
    let (is_approved) = ERC3525SlotApprovable.is_approved_for_slot(owner, slot, operator);
    return (is_approved=is_approved);
}

// @notice Approve or disapprove an operator to manage all of `_owner`'s tokens with the specified slot.
// @dev Caller SHOULD be `_owner` or an operator who has been authorized through setApprovalForAll.
//    MUST emit ApprovalSlot event.
// @param owner The address that owns the EIP-3525 tokens.
// @param slot The slot of tokens being queried approval of.
// @param operator The address for whom to query approval.
// @param approved Identify if operator would be approved or disapproved.
@external
func setApprovalForSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, slot: Uint256, operator: felt, approved: felt
) {
    ERC3525SlotApprovable.set_approval_for_slot(owner, slot, operator, approved);
    return ();
}

//
// ERC3525 - Metadata Descriptor
//

// @notice Return the contract URI (OpenSea).
// @return uri_len The URI array length
// @return uri The URI characters
@view
func contractURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (uri_len: felt, uri: felt*) {
    let (instance) = get_contract_address();
    let (uri_len, uri) = ERC3525MetadataDescriptor.constructContractURI{instance=instance}();
    return (uri_len=uri_len, uri=uri);
}

// @notice Return the slot URI.
// @dev The slot must be a valid Uint256.
// @param slot The slot to query.
// @return uri_len The URI array length
// @return uri The URI characters
@view
func slotURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(slot: Uint256) -> (uri_len: felt, uri: felt*) {
    let (instance) = get_contract_address();
    let (uri_len, uri) = ERC3525MetadataDescriptor.constructSlotURI{instance=instance}(slot);
    return (uri_len=uri_len, uri=uri);
}

// @notice Return the token URI.
// @dev The tokenID must be a valid Uint256.
// @param tokenId The token ID to query.
// @return uri_len The URI array length
// @return uri The URI characters
@view
func tokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(tokenId: Uint256) -> (uri_len: felt, uri: felt*) {
    let (instance) = get_contract_address();
    let (uri_len, uri) = ERC3525MetadataDescriptor.constructTokenURI{instance=instance}(tokenId);
    return (uri_len=uri_len, uri=uri);
}

//
// Mint and Burn
//

// @notice Mint the token id to the specified -to- address.
// @dev Throws if the caller does not have the MINTER_ROLE role.
//   Throws if -to- is the zero address.
//   Throws if -token_id- is not a valid Uint256.
//   Throws if -slot- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
//   Throws if token_id already minted.
//  @param to Recipient address.
//  @param token_id The token id.
//  @param slot Slot number the new token will belong to.
//  @param value Token value to mint.
@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, token_id: Uint256, slot: Uint256, value: Uint256
) {
    CarbonableAccessControl.assert_only_minter();
    return ERC3525SlotEnumerable._mint(to, token_id, slot, value);
}

// @notice Mint a new token to the specified -to- address.
// @dev Throws if the caller does not have the MINTER_ROLE role.
//   Throws if -to- is the zero address.
//   Throws if -slot- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
//  @param to Recipient address.
//  @param slot Slot number the new token will belong to.
//  @param value Token value to mint.
@external
func mintNew{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, slot: Uint256, value: Uint256
) -> (token_id: Uint256) {
    CarbonableAccessControl.assert_only_minter();
    let (token_id) = ERC3525SlotEnumerable._mint_new(to, slot, value);
    return (token_id=token_id);
}

// @notice Mint value of the specified token.
// @dev Throws if the caller does not have the MINTER_ROLE role.
//   Throws if -to- is the zero address.
//   Throws if -slot- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
//  @param token_id The token id.
//  @param value Token value to mint.
@external
func mintValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, value: Uint256
) {
    CarbonableAccessControl.assert_only_minter();
    ERC3525._mint_value(token_id, value);
    return ();
}

// @notice Burn the specified token.
// @dev Throws if the caller is not the token owner nor approved.
//   Throws if -token_id- is not a valid Uint256.
// @param token_id The token id.
@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(token_id: Uint256) {
    ERC721.assert_only_token_owner(token_id);
    ERC3525SlotEnumerable._burn(token_id);
    return ();
}

// @notice Burn value of the specified token.
// @dev Throws if the caller is not the token owner nor approved.
//   Throws if -token_id- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
// @param token_id The token id.
// @param value The token value to burn.
@external
func burnValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, value: Uint256
) {
    ERC721.assert_only_token_owner(token_id);
    ERC3525._burn_value(token_id, value);
    return ();
}

//
// Carbonable
//

// @notice Set the start time.
// @return time The start time.
@view
func getStartTime{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    time: felt
) {
    return CarbonableProject.start_time();
}

// @notice Return the computed final time.
// @return time The final time.
@view
func getFinalTime{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    time: felt
) {
    return CarbonableProject.final_time();
}

// @notice Return the stored times.
// @return times_len The Array length.
// @return times The timestamps.
@view
func getTimes{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    times_len: felt, times: felt*
) {
    return CarbonableProject.times();
}

// @notice Return the stored absorptions.
// @return absorptions_len The array length.
// @return absorptions The absorption values.
@view
func getAbsorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    absorptions_len: felt, absorptions: felt*
) {
    return CarbonableProject.absorptions();
}

// @notice Return the computed absorption based on the current timestamp.
// @return absorption The absorption.
@view
func getAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(time: felt) -> (
    absorption: felt
) {
    return CarbonableProject.absorption(time=time);
}

// @notice Return the computed absorption based on the current timestamp.
// @return absorption The absorption.
@view
func getCurrentAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    absorption: felt
) {
    return CarbonableProject.current_absorption();
}

// @notice Return the computed final absorption based on the final timestamp.
// @return absorption The final absorption.
@view
func getFinalAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    absorption: felt
) {
    return CarbonableProject.final_absorption();
}

// @notice Return the ton equivalent in absorption unit.
// @return ton_equivalent The ton equivalent.
@view
func getTonEquivalent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    ton_equivalent: felt
) {
    return CarbonableProject.ton_equivalent();
}

// @notice Return the setup status of the contract.
// @return status TRUE if setup else FALSE.
@view
func isSetup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (status: felt) {
    return CarbonableProject.is_setup();
}

// @notice Add new minter.
// @dev Throws if the caller is not the owner.
// @param minter The minter address.
@external
func addMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(minter: felt) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_minter(minter);
    return ();
}

// @notice Get the list of minters.
// @return minters_len The array length.
// @return minters The minter addresses.
@view
func getMinters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    minters_len: felt, minters: felt*
) {
    return CarbonableAccessControl.get_minters();
}

// @notice Revoke minter role.
// @dev Throws if the caller is not the owner.
// @param minter The minter address.
@external
func revokeMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(minter: felt) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.revoke_minter(minter);
    return ();
}

// @notice Add new certifier.
// @dev Throws if the caller is not the owner.
// @param certifier The certifier address.
@external
func setCertifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    certifier: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_certifier(certifier);
    return ();
}

// @notice Get the certifier.
// @return certifier The certifier address.
@view
func getCertifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    certifier: felt
) {
    let (certifier) = CarbonableAccessControl.get_certifier();
    return (certifier=certifier);
}

// @notice Set new absorption values.
// @dev The caller must have the CERTIFIER_ROLE role.
//   Throws if -times_len- is null.
//   Throws if -absorptions_len- is null.
//   Throws if -ton_equivalent- is null.
//   Throws if times_len is not equal to absorptions_len.
// @param times_len The array length.
// @param times The time values.
// @param absorptions_len The array length.
// @param absorptions The absorption values.
// @param ton_equivalent The absorption ton equivalent.
@external
func setAbsorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    times_len: felt, times: felt*, absorptions_len: felt, absorptions: felt*, ton_equivalent: felt
) {
    CarbonableAccessControl.assert_only_certifier();
    return CarbonableProject.set_absorptions(
        times_len=times_len,
        times=times,
        absorptions_len=absorptions_len,
        absorptions=absorptions,
        ton_equivalent=ton_equivalent,
    );
}
