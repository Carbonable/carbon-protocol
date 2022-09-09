# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (badge.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero

from openzeppelin.access.ownable.library import Ownable
from openzeppelin.token.erc1155.library import ERC1155
from openzeppelin.introspection.erc165.library import ERC165

#
# Constructor
#

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    uri : felt, owner : felt
):
    ERC1155.initializer(uri)
    Ownable.initializer(owner)
    return ()
end

#
# Getters
#

@view
func supportsInterface{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    interfaceId : felt
) -> (success : felt):
    return ERC165.supports_interface(interfaceId)
end

@view
func uri{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(id : Uint256) -> (
    uri : felt
):
    return ERC1155.uri(id)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account : felt, id : Uint256
) -> (balance : Uint256):
    return ERC1155.balance_of(account, id)
end

@view
func balanceOfBatch{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    accounts_len : felt, accounts : felt*, ids_len : felt, ids : Uint256*
) -> (balances_len : felt, balances : Uint256*):
    let (balances_len, balances) = ERC1155.balance_of_batch(accounts_len, accounts, ids_len, ids)
    return (balances_len, balances)
end

@view
func owner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (owner : felt):
    let (owner : felt) = Ownable.owner()
    return (owner)
end

#
# Externals
#

@external
func setURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(uri : felt):
    Ownable.assert_only_owner()
    ERC1155._set_uri(uri)
    return ()
end

@external
func mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    to : felt, id : Uint256, amount : Uint256, data_len : felt, data : felt*
):
    Ownable.assert_only_owner()
    ERC1155._mint(to, id, amount, data_len, data)
    return ()
end

@external
func mintBatch{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    to : felt,
    ids_len : felt,
    ids : Uint256*,
    amounts_len : felt,
    amounts : Uint256*,
    data_len : felt,
    data : felt*,
):
    Ownable.assert_only_owner()
    ERC1155._mint_batch(to, ids_len, ids, amounts_len, amounts, data_len, data)
    return ()
end

@external
func burn{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    from_ : felt, id : Uint256, amount : Uint256
):
    ERC1155.assert_owner_or_approved(owner=from_)
    let (caller) = get_caller_address()
    with_attr error_message("ERC1155: called from zero address"):
        assert_not_zero(caller)
    end
    ERC1155._burn(from_, id, amount)
    return ()
end

@external
func burnBatch{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    from_ : felt, ids_len : felt, ids : Uint256*, amounts_len : felt, amounts : Uint256*
):
    ERC1155.assert_owner_or_approved(owner=from_)
    let (caller) = get_caller_address()
    with_attr error_message("ERC1155: called from zero address"):
        assert_not_zero(caller)
    end
    ERC1155._burn_batch(from_, ids_len, ids, amounts_len, amounts)
    return ()
end

@external
func transferOwnership{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    newOwner : felt
):
    Ownable.transfer_ownership(newOwner)
    return ()
end

@external
func renounceOwnership{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    Ownable.renounce_ownership()
    return ()
end
