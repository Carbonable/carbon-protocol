// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from bal7hazar.token.erc1155.library import ERC1155
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.badge.library import CarbonableBadge

//
// Initializer
//

// @notice Initialize the contract with the given uri, name and owner.
// @dev This constructor ignores the standard OZ ERC1155 initializer (which require the uri only as single felt) in favor of
//   a dedicated initialize handling the uri (as a felt*) and a name to be compliant with most markplaces, finally the OZ
//   Ownable initializer is used.
// @param uri_len The URI array length.
// @param uri The URI characters.
// @param name The name of the badge collection.
// @param owner The owner and Admin address.
@external
func initializer{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*, name: felt, owner: felt) {
    alloc_locals;
    ERC1155.initializer(0);
    CarbonableBadge.initializer(uri_len, uri, name);
    Ownable.initializer(owner);
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
// @dev The caller must be the admin.
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
// @dev The caller must be the admin.
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
// @dev The aller must be the owner.
//   The new owner must not be the zero address.
// @param newOwner The new owner address.
@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

// @notice Renounce ownership.
// @dev The caller must be the owner.
@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

//
// ERC-1155
//

// @notice Return ability status to support the provided interface (EIP 165).
// @param interfaceId The nterface id.
// @return success TRUE if supported else FALSE.
@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

// @notice Return the URI corresponding to the specified token id (OpenSea).
// @dev The id must be a valid Uint256.
// @param id The token id.
// @return uri_len The URI array length.
// @return uri The The URI characters.
@view
func uri{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(id: Uint256) -> (uri_len: felt, uri: felt*) {
    return CarbonableBadge.uri(id);
}

// @notice Return the contract uri (OpenSea).
// @return uri_len The URI array length.
// @return uri The The URI characters.
@view
func contractURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (uri_len: felt, uri: felt*) {
    return CarbonableBadge.contract_uri();
}

// @notice Get the balance of multiple account/token pairs (EIP 1155).
// @param account The addresses of the token holder.
// @param id The token id.
// @return balance The account-s balance of the token types requested (i-e balance for each (owner, id) pair).
@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, id: Uint256
) -> (balance: Uint256) {
    return ERC1155.balance_of(account, id);
}

// @notice Get the balance of multiple account/token pairs (EIP 1155).
// @param accounts_len Accounts array length.
// @param accounts The addresses of the token holders.
// @param ids_len The token ids array length.
// @param ids The token ids.
// @return balances_len The balances array length.
// @return balances The accounts balance of the token types requested (i-e balance for each (owner, id) pair).
@view
func balanceOfBatch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    accounts_len: felt, accounts: felt*, ids_len: felt, ids: Uint256*
) -> (balances_len: felt, balances: Uint256*) {
    let (balances_len, balances) = ERC1155.balance_of_batch(accounts_len, accounts, ids_len, ids);
    return (balances_len, balances);
}

// @notice Query if an address is an authorized operator for another address (EIP 1155).
// @param account The address that owns the tokens.
// @param operator The address that acts on behalf of the owner.
// @return isApproved TRUE if the operator is approved, FALSE if not.
@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, operator: felt
) -> (isApproved: felt) {
    let (is_approved) = ERC1155.is_approved_for_all(account, operator);
    return (is_approved,);
}

// @notice Set the contract base URI.
// @param uri_len The URI array length.
// @param uri The URI characters.
@external
func setURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*) {
    Ownable.assert_only_owner();
    CarbonableBadge.set_uri(uri_len, uri);
    return ();
}

// @notice Enable or disable approval for a third party (operator) to manage all of the caller-s tokens (EIP 1155).
// @param operator The address to add to the set of authorized operators.
// @param approved TRUE if the operator is approved, FALSE to revoke approval.
@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC1155.set_approval_for_all(operator, approved);
    return ();
}

// @notice Transfer an amount of token id from address to a target (EIP 1155).
// @param from_ The source address.
// @param to The target address.
// @param id The token id.
// @param amount The transfer amount.
// @param data_len The data array len.
// @param data Additional data with no specified format.
@external
func safeTransferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
) {
    CarbonableBadge.assert_unlocked(id);
    ERC1155.safe_transfer_from(from_, to, id, amount, data_len, data);
    return ();
}

// @notice Transfer amounts of token ids from the from address to the to address specified (with safety call) (EIP 1155).
// @param from_ The source address.
// @param to The arget address.
// @param ids_len The token ids array length.
// @param ids Token ids of each token type (order and length must match amounts array).
// @param amounts_len The amounts array length.
// @param amounts The transfer amounts per token id.
// @param data_len The data array len.
// @param data Additional data with no specified format.
@external
func safeBatchTransferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt,
    to: felt,
    ids_len: felt,
    ids: Uint256*,
    amounts_len: felt,
    amounts: Uint256*,
    data_len: felt,
    data: felt*,
) {
    CarbonableBadge.assert_unlocked_batch(ids_len, ids);
    ERC1155.safe_batch_transfer_from(from_, to, ids_len, ids, amounts_len, amounts, data_len, data);
    return ();
}

// @notice Mint amount of token id to the -to- address specified.
// @param to The target address.
// @param id The token id.
// @param amount The mint amount.
// @param data_len The data array len.
// @param data Additional data with no specified format.
@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
) {
    Ownable.assert_only_owner();
    ERC1155._mint(to, id, amount, data_len, data);
    return ();
}

// @notice Mint amounts of token ids to the -to- address specified.
// @param to The target address.
// @param ids_len The token ids array length.
// @param ids The token ids of each token type (order and length must match amounts array).
// @param amounts_len The amounts array length.
// @param amounts The mint amounts per token type (order and length must match ids array).
// @param data_len The Data array len.
// @param data Additional data with no specified format.
@external
func mintBatch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt,
    ids_len: felt,
    ids: Uint256*,
    amounts_len: felt,
    amounts: Uint256*,
    data_len: felt,
    data: felt*,
) {
    Ownable.assert_only_owner();
    ERC1155._mint_batch(to, ids_len, ids, amounts_len, amounts, data_len, data);
    return ();
}

// @notice Burn amount of token id from the -from_- address specified.
// @param from_ The address of the token holder.
// @param id The token id.
// @param amount The burn amount.
@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, id: Uint256, amount: Uint256
) {
    ERC1155.assert_owner_or_approved(owner=from_);
    let (caller) = get_caller_address();
    with_attr error_message("ERC1155: called from zero address") {
        assert_not_zero(caller);
    }
    ERC1155._burn(from_, id, amount);
    return ();
}

// @notice Burn amounts of token ids from the -from_- address specified.
// @param from_ The address of the token holder.
// @param ids_len The token ids array length.
// @param ids The token ids of each token type (order and length must match amounts array).
// @param amounts_len The amounts array length.
// @param amounts The burn amounts per token type (order and length must match ids array).
@external
func burnBatch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, ids_len: felt, ids: Uint256*, amounts_len: felt, amounts: Uint256*
) {
    ERC1155.assert_owner_or_approved(owner=from_);
    let (caller) = get_caller_address();
    with_attr error_message("ERC1155: called from zero address") {
        assert_not_zero(caller);
    }
    ERC1155._burn_batch(from_, ids_len, ids, amounts_len, amounts);
    return ();
}

//
// Carbonable Badge
//

// @notice A descriptive name for a collection of NFTs in this contract (OpenSea).
// @return name The contract name.
@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return CarbonableBadge.name();
}

// @notice Return the locked status of a token id.
// @param is_locked TRUE if locked else FALSE.
// @return is_locked The locked status of a token id.
@view
func locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) -> (
    is_locked: felt
) {
    return CarbonableBadge.locked(id);
}

// @notice Lock the corresponding token id.
// @param id The token id to lock.
@external
func setLocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) {
    Ownable.assert_only_owner();
    CarbonableBadge.set_locked(id);
    return ();
}

// @notice Unlock the corresponding token id.
// @param id The token id to unlock.
@external
func setUnlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) {
    Ownable.assert_only_owner();
    CarbonableBadge.set_unlocked(id);
    return ();
}
