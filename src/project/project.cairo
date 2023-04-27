// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.starknet.common.syscalls import get_contract_address

// Project dependencies
from openzeppelin.access.accesscontrol.library import AccessControl
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.upgrades.library import Proxy
from erc3525.extensions.slotapprovable.library import ERC3525SlotApprovable
from erc3525.extensions.slotenumerable.library import (
    ERC3525SlotEnumerable,
    _add_token_to_slot_enumeration,
)
from erc3525.library import ERC3525
from erc3525.periphery.library import ERC3525MetadataDescriptor
from erc2981.library import ERC2981
from erc4906.library import ERC4906

// Local dependencies
from src.project.library import CarbonableProject
from src.metadata.library import CarbonableMetadataOnchainSvg as CarbonableMetadata
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
// @param name The name of the collection.
// @param name The name of the collection.
// @param name The name of the collection.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt,
    symbol: felt,
    decimals: felt,
    receiver: felt,
    fee_numerator: felt,
    fee_denominator: felt,
    owner: felt,
) {
    ERC721.initializer(name, symbol);
    ERC721Enumerable.initializer();
    ERC3525.initializer(decimals);
    ERC3525SlotApprovable.initializer();
    ERC3525SlotEnumerable.initializer();
    ERC2981.initializer(receiver, fee_numerator, fee_denominator);
    ERC4906.initializer();
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
@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

// @notice Add new minter.
// @dev Throws if the caller is not the owner.
// @param minter The minter address.
@external
func addMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256, minter: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_minter(slot, minter);
    return ();
}

// @notice Get the list of minters.
// @return minters_len The array length.
// @return minters The minter addresses.
@view
func getMinters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
    minters_len: felt, minters: felt*
) {
    return CarbonableAccessControl.get_minters(slot);
}

// @notice Revoke minter role.
// @dev Throws if the caller is not the owner.
// @param minter The minter address.
@external
func revokeMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256, minter: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.revoke_minter(slot, minter);
    return ();
}

// @notice Add new certifier.
// @dev Throws if the caller is not the owner.
// @param certifier The certifier address.
@external
func setCertifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256, certifier: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_certifier(slot, certifier);
    return ();
}

// @notice Get the certifier.
// @return certifier The certifier address.
@view
func getCertifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (certifier: felt) {
    let (certifier) = CarbonableAccessControl.get_certifier(slot);
    return (certifier=certifier);
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
// @param from_ The current owner of the NFT.
// @param to The new owner.
// @param tokenId The NFT to transfer.
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
// @param from_ The current owner of the NFT.
// @param to The new owner.
// @param tokenId The NFT to transfer.
// @param data Additional data with no specified format, sent in call to -to-.
@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721Enumerable.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

//
// ERC3525
//

// @notice Get the number of decimals the token uses for value - e.g. 6, means the user
//   representation of the value of a token can be calculated by dividing it by 1,000,000.
// @return The number of decimals for value.
@view
func valueDecimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    decimals: felt
) {
    return ERC3525.value_decimals();
}

// @notice Get the value of the specified tokenId.
// @param tokenId The token for which to query the value.
// @return balance The value of token.
@view
func valueOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    balance: Uint256
) {
    return ERC3525.balance_of(tokenId);
}

// @notice Get the slot of a token.
// @param tokenId The identifier for a token.
// @return slot The slot of the token.
@view
func slotOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    slot: Uint256
) {
    return ERC3525.slot_of(tokenId);
}

// @notice Get the maximum value of a token that an operator is allowed to manage.
// @param tokenId The token for which to query the allowance.
// @param operator The address of an operator.
// @return amount The current approval value of tokenId that operator is allowed to manage.
@view
func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, operator: felt
) -> (amount: Uint256) {
    return ERC3525.allowance(tokenId, operator);
}

// @notice Get the total value of the specified slot.
// @param slot The slot to query total value for.
// @return total The total value.
@view
func totalValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
    total: Uint256
) {
    return ERC3525.total_value(slot);
}

// @notice Allow an operator to manage the value of a token, up to the value.
// @dev Revert unless caller is the current owner, an authorized operator, or the approved
//   address for tokenId.
//   Emit the ApprovalValue event.
// @param tokenId The token to approve.
// @param operator The operator to be approved.
// @param value The maximum value of tokenId that operator is allowed to manage.
@external
func approveValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, operator: felt, value: Uint256
) {
    ERC3525SlotApprovable.approve_value(tokenId, operator, value);
    return ();
}

// @notice Transfer value from a specified token to another specified token with the same slot
//   or to an address.
// @dev -toTokenId- and -to- parameters are mutually exclusive, one of them must be null
//   depending to the receive mode.
//   Revert if fromTokenId is zero token id or does not exist.
//   Revert if to is zero address and toTokenId is null.
//   Revert if value exceeds the balance of fromTokenId or its allowance to the operator.
//   Emit MetadataUpdate and TransferValue events.
// @param fromTokenId The token to transfer value from.
// @param toTokenId The token to transfer value to.
// @param to The address to transfer value to.
// @param value The transferred value.
// @return newTokenId The id of the token which receives the transferred value.
@external
func transferValueFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    fromTokenId: Uint256, toTokenId: Uint256, to: felt, value: Uint256
) -> (newTokenId: Uint256) {
    alloc_locals;

    // Transfer
    let (local new_token_id: Uint256) = ERC3525SlotApprovable.transfer_from(
        fromTokenId, toTokenId, to, value
    );

    // Emit metadata update events
    ERC4906.metadata_update(token_id=fromTokenId);

    if (to == 0) {
        ERC4906.metadata_update(token_id=toTokenId);
        return (newTokenId=new_token_id);
    }

    // Keep enumerability
    let (slot) = ERC3525.slot_of(fromTokenId);
    _add_token_to_slot_enumeration(slot, new_token_id);
    return (newTokenId=new_token_id);
}

//
// ERC3525 - SlotApprovable
//

// @notice Get the total amount of slots stored by the contract.
// @return count The total amount of slots.
@view
func slotCount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    count: Uint256
) {
    return ERC3525SlotEnumerable.slot_count();
}

// @notice Get the slot at the specified index of all slots stored by the contract.
// @param index The index in the slot list.
// @return slot The slot at index of all slots.
@view
func slotByIndex{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    index: Uint256
) -> (slot: Uint256) {
    return ERC3525SlotEnumerable.slot_by_index(index);
}

// @notice Get the total amount of tokens with the same slot.
// @param slot The slot to query token supply for.
// @return totalAmount The total amount of tokens with the specified slot.
@view
func tokenSupplyInSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (totalAmount: Uint256) {
    let (totalAmount) = ERC3525SlotEnumerable.token_supply_in_slot(slot);
    return (totalAmount=totalAmount);
}

// @notice Get the token at the specified index of all tokens with the same slot.
// @param slot The slot to query tokens with.
// @param index The index in the token list of the slot.
// @return tokenId The token ID at index of all tokens with slot.
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
// ERC3525 - Metadata
//

// @notice Return the contract URI (OpenSea).
// @return uri_len The URI array length
// @return uri The URI characters
@view
func contractURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    uri_len: felt, uri: felt*
) {
    let (uri_len, uri) = CarbonableProject.contract_uri();
    return (uri_len=uri_len, uri=uri);
}

// @notice Return the slot URI.
// @dev The slot must be a valid Uint256.
// @param slot The slot to query.
// @return uri_len The URI array length
// @return uri The URI characters
@view
func slotURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
    uri_len: felt, uri: felt*
) {
    let (uri_len, uri) = CarbonableProject.slot_uri(slot=slot);
    return (uri_len=uri_len, uri=uri);
}

// @notice Return the token URI.
// @dev The tokenID must be a valid Uint256.
// @param tokenId The token ID to query.
// @return uri_len The URI array length
// @return uri The URI characters
@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (uri_len: felt, uri: felt*) {
    let (uri_len, uri) = CarbonableProject.token_uri(token_id=tokenId);
    return (uri_len=uri_len, uri=uri);
}

// @notice Get the metadata implementation.
// @return implementation The metadata implementation class hash.
@view
func getMetadataImplementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (implementation: felt) {
    let (implementation) = CarbonableMetadata.get_implementation();
    return (implementation=implementation);
}

// @notice Set the metadata implementation.
// @dev Throws if the caller is not the owner.
// @param implementation The metadata implementation class hash.
@external
func setMetadataImplementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    implementation: felt
) {
    Ownable.assert_only_owner();
    CarbonableMetadata.set_implementation(implementation=implementation);
    return ();
}

//
// Mint and Burn
//

// @notice Mint the token id to the specified -to- address.
// @dev Throws if the caller does not have the MINTER_ROLE role.
//   Throws if -to- is the zero address.
//   Throws if -tokenId- is not a valid Uint256.
//   Throws if -slot- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
//   Throws if tokenId already minted.
// @param to Recipient address.
// @param tokenId The token id.
// @param slot Slot number the new token will belong to.
// @param value Token value to mint.
@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, tokenId: Uint256, slot: Uint256, value: Uint256
) {
    CarbonableAccessControl.assert_only_minter(slot);
    return ERC3525SlotEnumerable._mint(to, tokenId, slot, value);
}

// @notice Mint a new token to the specified -to- address.
// @dev Throws if the caller does not have the MINTER_ROLE role.
//   Throws if -to- is the zero address.
//   Throws if -slot- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
// @param to Recipient address.
// @param slot Slot number the new token will belong to.
// @param value Token value to mint.
@external
func mintNew{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, slot: Uint256, value: Uint256
) -> (tokenId: Uint256) {
    CarbonableAccessControl.assert_only_minter(slot);
    let (token_id) = ERC3525SlotEnumerable._mint_new(to, slot, value);
    return (tokenId=token_id);
}

// @notice Mint value of the specified token.
// @dev Throws if the caller does not have the MINTER_ROLE role.
//   Throws if -to- is the zero address.
//   Throws if -slot- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
// @param tokenId The token id.
// @param value Token value to mint.
@external
func mintValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, value: Uint256
) {
    let (slot) = ERC3525.slot_of(tokenId);
    CarbonableAccessControl.assert_only_minter(slot);
    ERC3525._mint_value(tokenId, value);
    return ();
}

// @notice Burn the specified token.
// @dev Throws if the caller is not the token owner nor approved.
//   Throws if -tokenId- is not a valid Uint256.
// @param tokenId The token id.
@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) {
    ERC721.assert_only_token_owner(tokenId);
    ERC3525SlotEnumerable._burn(tokenId);
    return ();
}

// @notice Burn value of the specified token.
// @dev Throws if the caller is not the token owner nor approved.
//   Throws if -tokenId- is not a valid Uint256.
//   Throws if -value- is not a valid Uint256.
// @param tokenId The token id.
// @param value The token value to burn.
@external
func burnValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, value: Uint256
) {
    ERC721.assert_only_token_owner(tokenId);
    ERC3525._burn_value(tokenId, value);
    return ();
}

//
// ERC2981
//

@view
func defaultRoyalty{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    receiver: felt, feeNumerator: felt, feeDenominator: felt
) {
    let (receiver, fee_numerator, fee_dumerator) = ERC2981.default_royalty();
    return (receiver=receiver, feeNumerator=fee_numerator, feeDenominator=fee_dumerator);
}

@view
func tokenRoyalty{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (receiver: felt, feeNumerator: felt, feeDenominator: felt) {
    let (receiver, fee_numerator, fee_dumerator) = ERC2981.token_royalty(token_id=tokenId);
    return (receiver=receiver, feeNumerator=fee_numerator, feeDenominator=fee_dumerator);
}

@view
func royaltyInfo{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, salePrice: Uint256
) -> (receiver: felt, royaltyAmount: Uint256) {
    let (receiver, royaltyAmount) = ERC2981.royalty_info(token_id=tokenId, sale_price=salePrice);
    return (receiver=receiver, royaltyAmount=royaltyAmount);
}

@external
func setDefaultRoyalty{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    receiver: felt, feeNumerator: felt, feeDenominator: felt
) {
    Ownable.assert_only_owner();
    ERC2981.set_default_royalty(
        receiver=receiver, fee_numerator=feeNumerator, fee_denominator=feeDenominator
    );
    return ();
}

@external
func setTokenRoyalty{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256, receiver: felt, feeNumerator: felt, feeDenominator: felt
) {
    Ownable.assert_only_owner();
    ERC2981.set_token_royalty(
        token_id=tokenId,
        receiver=receiver,
        fee_numerator=feeNumerator,
        fee_denominator=feeDenominator,
    );
    return ();
}

//
// ERC4906
//

@external
func emitBatchMetadataUpdate{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    fromTokenId: Uint256, toTokenId: Uint256
) {
    Ownable.assert_only_owner();
    ERC4906.batch_metadata_update(fromTokenId, toTokenId);
    return ();
}

//
// Carbonable
//

// @notice Set the start time.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return time The start time.
@view
func getStartTime{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (time: felt) {
    return CarbonableProject.start_time(slot=slot);
}

// @notice Return the computed final time.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return time The final time.
@view
func getFinalTime{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (time: felt) {
    return CarbonableProject.final_time(slot=slot);
}

// @notice Return the stored times.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return times_len The Array length.
// @return times The timestamps.
@view
func getTimes{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
    times_len: felt, times: felt*
) {
    return CarbonableProject.times(slot=slot);
}

// @notice Return the stored absorptions.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return absorptions_len The array length.
// @return absorptions The absorption values.
@view
func getAbsorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (absorptions_len: felt, absorptions: felt*) {
    return CarbonableProject.absorptions(slot=slot);
}

// @notice Return the computed absorption based on the specified timestamp.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return absorption The absorption.
@view
func getAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256, time: felt
) -> (absorption: felt) {
    return CarbonableProject.absorption(slot=slot, time=time);
}

// @notice Return the computed absorption based on the current timestamp.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return absorption The absorption.
@view
func getCurrentAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (absorption: felt) {
    return CarbonableProject.current_absorption(slot=slot);
}

// @notice Return the computed final absorption based on the final timestamp.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return absorption The final absorption.
@view
func getFinalAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (absorption: felt) {
    return CarbonableProject.final_absorption(slot=slot);
}

// @notice Return the ton equivalent in absorption unit.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return ton_equivalent The ton equivalent.
@view
func getTonEquivalent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256
) -> (ton_equivalent: felt) {
    return CarbonableProject.ton_equivalent(slot=slot);
}

// @notice Return the setup status of the contract.
// @dev Throws if -slot- is not Uint256 compliant.
// @param slot The collection slot.
// @return status TRUE if setup else FALSE.
@view
func isSetup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
    status: felt
) {
    return CarbonableProject.is_setup(slot=slot);
}

// @notice Set new absorption values.
// @dev The caller must have the CERTIFIER_ROLE role.
//   Throws if -slot- is not Uint256 compliant.
//   Throws if -times_len- is null.
//   Throws if -absorptions_len- is null.
//   Throws if -ton_equivalent- is null.
//   Throws if times_len is not equal to absorptions_len.
// @param slot The collection slot.
// @param times_len The array length.
// @param times The time values.
// @param absorptions_len The array length.
// @param absorptions The absorption values.
// @param ton_equivalent The absorption ton equivalent.
@external
func setAbsorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slot: Uint256,
    times_len: felt,
    times: felt*,
    absorptions_len: felt,
    absorptions: felt*,
    ton_equivalent: felt,
) {
    CarbonableAccessControl.assert_only_certifier(slot);
    return CarbonableProject.set_absorptions(
        slot=slot,
        times_len=times_len,
        times=times,
        absorptions_len=absorptions_len,
        absorptions=absorptions,
        ton_equivalent=ton_equivalent,
    );
}
