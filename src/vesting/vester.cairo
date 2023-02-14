// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.upgrades.library import Proxy
from starkvest.library import StarkVest
from starkvest.starkvest import (
    erc20_address,
    vestings_total_amount,
    vesting_count,
    get_vesting_id,
    vestings,
    withdrawable_amount,
    get_contract_balance,
    releasable_amount,
    revoke,
    release,
    withdraw,
)

// Local dependencies
from src.utils.access.library import CarbonableAccessControl
from src.vesting.library import CarbonableVester

//
// Initializer
//

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    erc20_address: felt, owner: felt
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
    //   owner(felt): Owner and Admin address
    // Returns:
    //   None
    Ownable.initializer(owner);
    StarkVest.initializer(erc20_address);
    Proxy.initializer(owner);
    return ();
}

//
// Proxy administration
//

@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    // Desc:
    //   Return the current implementation hash
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   implementation(felt): Implementation class hash
    return Proxy.get_implementation_hash();
}

@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    // Desc:
    //   Return the admin address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   admin(felt): The admin address
    return Proxy.get_admin();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    // Desc:
    //   Upgrade the contract to the new implementation
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_implementation(felt): New implementation class hash
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the admin
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    // Desc:
    //   Transfer admin rights to a new admin
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_admin(felt): Address of the new admin
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the admin
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}

//
// Ownership administration
//

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
    return Ownable.owner();
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

@external
func addVester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(vester: felt) {
    // Desc:
    //   Add new vester
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   minter(felt): Vester address
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_vester(vester);
    return ();
}

@view
func getVesters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    vesters_len: felt, vesters: felt*
) {
    // Desc:
    //   Get the list of vester
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   vesters_len(felt): vester array length
    //   vester(felt*): vester address array
    return CarbonableAccessControl.get_vesters();
}

@external
func revokeVester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(vester: felt) {
    // Desc:
    //   Revoke vester role
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   vester(felt): vester address
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    CarbonableAccessControl.revoke_vester(vester);
    return ();
}

//
// Views
//

@view
func releasableOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (amount: Uint256) {
    // Desc:
    //   Return
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   account(felt): Account address
    // Returns:
    //   amount(Uint256): Total amount releasable
    return CarbonableVester.releasable_of(account=account);
}

//
// Externals
//

@external
func releaseAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Desc:
    //   Release all withdrawable amounts of all vestings associated to the caller
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    CarbonableVester.release_all();
    return ();
}

@external
func create_vesting{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    beneficiary: felt,
    cliff_delta: felt,
    start: felt,
    duration: felt,
    slice_period_seconds: felt,
    revocable: felt,
    amount_total: Uint256,
) -> (vesting_id: felt) {
    // Desc:
    //   Creates a new vesting for a beneficiary
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   beneficiary(felt): address of the beneficiary
    //   start(felt): start time of the vesting period
    //   cliff_delta(felt): duration in seconds of the cliff in which tokens will begin to vest
    //   duration(felt): duration in seconds of the period in which the tokens will vest
    //   slice_period_seconds(felt): duration of a slice period for the vesting in seconds
    //   revocable(felt): whether the vesting is revocable or not
    //   amount_total(Uint256): total amount of tokens to be released at the end of the vesting
    // Returns:
    //   vesting_id(felt): the created vesting id
    // Raises:
    //   caller: caller does not have the VESTER_ROLE role
    CarbonableAccessControl.assert_only_vester();
    return StarkVest.create_vesting(
        beneficiary, cliff_delta, start, duration, slice_period_seconds, revocable, amount_total
    );
}
