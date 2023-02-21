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

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated initializer that mainly stores the inputs.
// @param erc20_address The address of the corresponding Carbonable project.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    erc20_address: felt, owner: felt
) {
    Ownable.initializer(owner);
    StarkVest.initializer(erc20_address);
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
// @param new_admin The address of the new admin.
@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}

//
// Ownership administration
//

// @notice Return the contract owner.
// @return owner The owner address.
@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev The caller must be the owner.
//   The new owner must not be the zero address.
// @param new_owner The address of the new owner.
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

// @notice Add new vester.
// @dev The caller must be the owner.
// @param vester The address of the new vester.
@external
func addVester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(vester: felt) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_vester(vester);
    return ();
}

// @notice Get the list of vester.
// @return vesters_len The vester array length.
// @return vesters The vester address array.
@view
func getVesters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    vesters_len: felt, vesters: felt*
) {
    return CarbonableAccessControl.get_vesters();
}

// @notice Revoke vester role.
// @dev The caller must be the owner.
// @param vester The address of the vester.
@external
func revokeVester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(vester: felt) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.revoke_vester(vester);
    return ();
}

//
// Views
//

// @notice Return the total releasable amount.
// @param account The address of the account.
// @return amount The total releasable amount.
func releasableOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (amount: Uint256) {
    return CarbonableVester.releasable_of(account=account);
}

@view
func releasedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (
    amount: Uint256
) {
    // Desc:
    //   Return
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   account(felt): Account address
    // Returns:
    //   amount(Uint256): Total amount released
    return CarbonableVester.released_of(account=account);
}

//
// Externals
//

// @notice Release all withdrawable amounts of all vestings associated to the caller.
// @dev The caller must be the owner.
@external
func releaseAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    CarbonableVester.release_all();
    return ();
}

// @notice Creates a new vesting for a beneficiary.
// @dev The caller must have the VESTER_ROLE role.
// @param beneficiary The address of the beneficiary.
// @param cliff_delta The duration in seconds of the cliff in which tokens will begin to vest.
// @param start The start time of the vesting period.
// @param duration The duration in seconds of the period in which the tokens will vest.
// @param slice_period_seconds The duration in seconds of the period in which the tokens will be released.
// @param revocable Whether the vesting is revocable or not.
// @param amount_total The total amount of tokens to be vested.
// @return vesting_id The vesting ID.
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
    CarbonableAccessControl.assert_only_vester();
    return StarkVest.create_vesting(
        beneficiary, cliff_delta, start, duration, slice_period_seconds, revocable, amount_total
    );
}
