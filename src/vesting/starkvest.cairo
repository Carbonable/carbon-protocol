// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable.library import Ownable

from starkvest.starkvest import (
    constructor,
    create_vesting,
    erc20_address,
    vestings_total_amount,
    vesting_count,
    vestings,
    withdrawable_amount,
    get_contract_balance,
    releasable_amount,
    revoke,
    release,
    withdraw,
)

from starkvest.library import StarkVest

//##
// @return the number of vestings associated to the account
//##
@view
func get_vesting_id{pedersen_ptr: HashBuiltin*}(account: felt, vesting_index: felt) -> (
    vesting_id: felt
) {
    return StarkVest.compute_vesting_id(account, vesting_index);
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
    // Raises:
    //   caller: caller is not the contract owner
    //   newOwner: new owner is the zero address
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
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.renounce_ownership();
    return ();
}
