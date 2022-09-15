// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (badge.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from bal7hazar.token.erc1155.library import ERC1155
from openzeppelin.introspection.erc165.library import ERC165

// Local dependencies
from src.badge.library import CarbonableBadge

//
// Constructor
//

@constructor
func constructor{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*, name: felt, owner: felt) {
    alloc_locals;

    ERC1155.initializer(0);
    CarbonableBadge.initializer(uri_len, uri, name);
    Ownable.initializer(owner);
    return ();
}

//
// Getters
//

@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

@view
func uri{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(id: Uint256) -> (uri_len: felt, uri: felt*) {
    return CarbonableBadge.uri(id);
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, id: Uint256
) -> (balance: Uint256) {
    return ERC1155.balance_of(account, id);
}

@view
func balanceOfBatch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    accounts_len: felt, accounts: felt*, ids_len: felt, ids: Uint256*
) -> (balances_len: felt, balances: Uint256*) {
    let (balances_len, balances) = ERC1155.balance_of_batch(accounts_len, accounts, ids_len, ids);
    return (balances_len, balances);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, operator: felt
) -> (isApproved: felt) {
    let (is_approved) = ERC1155.is_approved_for_all(account, operator);
    return (is_approved,);
}

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    let (owner: felt) = Ownable.owner();
    return (owner,);
}

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return CarbonableBadge.name();
}

@view
func locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) -> (
    is_locked: felt
) {
    return CarbonableBadge.locked(id);
}

//
// Externals
//

@external
func setURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*) {
    Ownable.assert_only_owner();
    CarbonableBadge.set_uri(uri_len, uri);
    return ();
}

@external
func setLocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) {
    Ownable.assert_only_owner();
    CarbonableBadge.set_locked(id);
    return ();
}

@external
func setUnlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) {
    Ownable.assert_only_owner();
    CarbonableBadge.set_unlocked(id);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC1155.set_approval_for_all(operator, approved);
    return ();
}

@external
func safeTransferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
) {
    CarbonableBadge.assert_unlocked(id);
    ERC1155.safe_transfer_from(from_, to, id, amount, data_len, data);
    return ();
}

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

@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
) {
    Ownable.assert_only_owner();
    ERC1155._mint(to, id, amount, data_len, data);
    return ();
}

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

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}
