// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable.library import Ownable

from openzeppelin.upgrades.library import Proxy

from starkvest.library import StarkVest
from starkvest.starkvest import (
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

//
// Initializer
//
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    erc20_address: felt, owner: felt, proxy_admin: felt
) {
    // Desc:
    //   Initialize the contract with the given parameters -
    //   This constructor uses a dedicated initializer that mainly stores the inputs
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   erc20_address(felt): Address of the corresponding Carbonable project
    //   owner(felt): Owner address
    //   proxy_admin(felt): Admin address
    // Returns:
    //   None
    Ownable.initializer(owner);
    StarkVest.initializer(erc20_address);
    Proxy.initializer(proxy_admin);
    return ();
}

//##
// @return the number of vestings associated to the account
//##
@view
func get_vesting_id{pedersen_ptr: HashBuiltin*}(account: felt, vesting_index: felt) -> (
    vesting_id: felt
) {
    return StarkVest.compute_vesting_id(account, vesting_index);
}

@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    // Desc:
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    // Explicit args:
    //   new_implementation(felt): new contract implementation
    // Raises:
    //   caller: caller is not a contract admin
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
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

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    // Desc:
    //   Transfer ownership to a new owner
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   newOwner(felt): Address of the new owner
    // Returns:
    //   None
    // Explicit args:
    //   new_implementation(felt): new contract implementation
    // Raises:
    //   caller: caller is not the contract owner
    //   newOwner: new owner is the zero address
    Ownable.transfer_ownership(newOwner);
    return ();
}
