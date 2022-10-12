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
    // Desc:
    //   Initialize the contract with the given uri, name and owner -
    //   This constructor ignores the standard OZ ERC1155 initializer (which require the uri only as single felt) in favor of
    //   a dedicated initialize handling the uri (as a felt*) and a name to be compliant with most markplaces, finally the OZ
    //   Ownable initializer is used
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   uri_len(felt): URI array length
    //   uri(felt*): URI characters
    //   name(felt): Name of the badge collection
    //   owner(felt): Owner address
    // Returns:
    //   None
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
    // Desc:
    //   Return the ability status to support the provided interface (EIP 165)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   interfaceId(felt): Interface id
    // Returns:
    //   success(felt): 1 if supported else 0
    return ERC165.supports_interface(interfaceId);
}

@view
func uri{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(id: Uint256) -> (uri_len: felt, uri: felt*) {
    // Desc:
    //   Return the URI corresponding to the specified token id (OpenSea)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   id(Uint256): Token id
    // Returns:
    //   uri_len(felt): URI array length
    //   uri(felt*): The URI characters
    // Raises:
    //   id: id is not a valid Uint256
    return CarbonableBadge.uri(id);
}

@view
func contractURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (uri_len: felt, uri: felt*) {
    // Desc:
    //   Return the contract uri (OpenSea)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Returns:
    //   uri_len(felt): URI array length
    //   uri(felt*): The URI characters
    return CarbonableBadge.contract_uri();
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, id: Uint256
) -> (balance: Uint256) {
    // Desc:
    //   Get the balance of multiple account/token pairs (EIP 1155)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   account(felt): The addresses of the token holder
    //   id(Uint256): Token id
    // Returns:
    //   balance(Uint256): The account-s balance of the token types requested (i-e balance for each (owner, id) pair)
    return ERC1155.balance_of(account, id);
}

@view
func balanceOfBatch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    accounts_len: felt, accounts: felt*, ids_len: felt, ids: Uint256*
) -> (balances_len: felt, balances: Uint256*) {
    // Desc:
    //   Get the balance of multiple account/token pairs (EIP 1155)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   accounts_len(felt): Accounts array length
    //   accounts(felt*): The addresses of the token holders
    //   ids_len(felt): Token ids array length
    //   ids(Uint256*): Token ids
    // Returns:
    //   balances_len(felt): The balances array length
    //   balances(Uint256*): The accounts balance of the token types requested (i-e balance for each (account, id) pair)
    let (balances_len, balances) = ERC1155.balance_of_batch(accounts_len, accounts, ids_len, ids);
    return (balances_len, balances);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, operator: felt
) -> (isApproved: felt) {
    // Desc:
    //   Queries the approval status of an operator for a given owner (EIP 1155)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   account(felt): The owner of the tokens
    //   operator(felt): Address of authorized operator
    // Returns:
    //   isApproved(felt): 1 if the operator is approved, 0 if not
    let (is_approved) = ERC1155.is_approved_for_all(account, operator);
    return (is_approved,);
}

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    // Desc:
    //   Return the contract owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   owner(felt): The owner address
    let (owner: felt) = Ownable.owner();
    return (owner,);
}

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    // Desc:
    //   A descriptive name for a collection of NFTs in this contract (OpenSea)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   name(felt): The contract name
    return CarbonableBadge.name();
}

@view
func locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) -> (
    is_locked: felt
) {
    // Desc:
    //   Return the locked status of a token id
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   id(Uint256): Token id
    // Returns:
    //   is_locked(felt): 1 if locked else 0
    return CarbonableBadge.locked(id);
}

//
// Externals
//

@external
func setURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*) {
    // Desc:
    //   Set the contract base URI
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   uri_len(felt): URI array length
    //   uri(felt*): URI characters
    Ownable.assert_only_owner();
    CarbonableBadge.set_uri(uri_len, uri);
    return ();
}

@external
func setLocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) {
    // Desc:
    //   Lock the corresponding token id
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   id(Uint256): Token id to lock
    // Returns:
    //   None
    Ownable.assert_only_owner();
    CarbonableBadge.set_locked(id);
    return ();
}

@external
func setUnlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) {
    // Desc:
    //   Unock the corresponding token id
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   id(Uint256): Token id to unlock
    // Returns:
    //   None
    Ownable.assert_only_owner();
    CarbonableBadge.set_unlocked(id);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    // Desc:
    //   Enable or disable approval for a third party (operator) to manage all of the caller-s tokens (EIP 1155)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   operator(felt): Address to add to the set of authorized operators
    //   approved(felt): 1 if the operator is approved, 0 to revoke approval
    // Returns:
    //   None
    ERC1155.set_approval_for_all(operator, approved);
    return ();
}

@external
func safeTransferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
) {
    // Desc:
    //   Transfer an amount of token id from address to a target (EIP 1155)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   from_(felt): Source address
    //   to(felt): Target address
    //   id(Uint256): Token id
    //   amount(Uint256): Transfer amount
    //   data_len(felt): Data array len
    //   data(felt*): Additional data with no specified format
    // Returns:
    //   None
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
    // Desc:
    //   Transfer amounts of token ids from the from address to the to address specified (with safety call) (EIP 1155)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   from_(felt): Source address
    //   to(felt): Target address
    //   ids_len(felt): Token ids array length
    //   ids(Uint256*): Token ids of each token type (order and length must match amounts array)
    //   amounts_len(felt): Amounts array length
    //   amounts(Uint256*): Transfer amounts per token type (order and length must match ids array)
    //   data_len(felt): Data array len
    //   data(felt*): Additional data with no specified format
    // Returns:
    //   None
    CarbonableBadge.assert_unlocked_batch(ids_len, ids);
    ERC1155.safe_batch_transfer_from(from_, to, ids_len, ids, amounts_len, amounts, data_len, data);
    return ();
}

@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
) {
    // Desc:
    //   Mint amount of token id to the -to- address specified
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   to(felt): Target address
    //   id(Uint256): Token id
    //   amount(Uint256): Mint amount
    //   data_len(felt): Data array len
    //   data(felt*): Additional data with no specified format
    // Returns:
    //   None
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
    // Desc:
    //   Mint amounts of token ids to the -to- address specified
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   to(felt): Target address
    //   ids_len(felt): Token ids array length
    //   ids(Uint256*): Token ids of each token type (order and length must match amounts array)
    //   amounts_len(felt): Amounts array length
    //   amounts(Uint256*): Mint amounts per token type (order and length must match ids array)
    //   data_len(felt): Data array len
    //   data(felt*): Additional data with no specified format
    // Returns:
    //   None
    Ownable.assert_only_owner();
    ERC1155._mint_batch(to, ids_len, ids, amounts_len, amounts, data_len, data);
    return ();
}

@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, id: Uint256, amount: Uint256
) {
    // Desc:
    //   Burn amount of token id from the -from_- address specified
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   from_(felt): Address of the token holder
    //   id(Uint256): Token id
    //   amount(Uint256): Burn amount
    //   data_len(felt): Data array len
    //   data(felt*): Additional data with no specified format
    // Returns:
    //   None
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
    // Desc:
    //   Burn amounts of token ids from the -from_- address specified
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   from_(felt): Address of the token holder
    //   ids_len(felt): Token ids array length
    //   ids(Uint256*): Token ids of each token type (order and length must match amounts array)
    //   amounts_len(felt): Amounts array length
    //   amounts(Uint256*): Burn amounts per token type (order and length must match ids array)
    //   data_len(felt): Data array len
    //   data(felt*): Additional data with no specified format
    // Returns:
    //   None
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
    // Desc:
    //   Transfer ownership to a new owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   newOwner(felt): Address of the new owner
    // Returns:
    //   None
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Desc:
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    Ownable.renounce_ownership();
    return ();
}
