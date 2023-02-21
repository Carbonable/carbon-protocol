// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.offset.library import CarbonableOffseter
from src.utils.access.library import CarbonableAccessControl
from src.yield.library import CarbonableYielder

//
// Initializer
//

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated initializer that mainly stores the inputs.
// @param carbonable_project_address The address of the Carbonable project.
// @param carbonable_offseter_address The address of the Carbonable offseter.
// @param carbonable_vester_address The address of the Carbonable vester.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt,
    carbonable_offseter_address: felt,
    carbonable_vester_address: felt,
    owner: felt,
) {
    CarbonableOffseter.initializer(carbonable_project_address);
    CarbonableYielder.initializer(
        carbonable_offseter_address=carbonable_offseter_address,
        carbonable_vester_address=carbonable_vester_address,
    );
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

// @notice Return the admin address.
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

// @notice Return the owner address.
// @return owner The owner address.
@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev This function is only callable by the owner.
//   The new owner can be the zero address.
// @param new_owner The address of the new owner.
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

// @notice Set the snapshoter.
// @dev This function is only callable by the owner.
// @param snapshoter The address of the snapshoter.
@external
func setSnapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    snapshoter: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_snapshoter(snapshoter);
    return ();
}

// @notice Get the snapshoter.
// @return snapshoter The address of the snapshoter.
@view
func getSnapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    snapshoter: felt
) {
    return CarbonableAccessControl.get_snapshoter();
}

//
// Getters
//

// @notice Return the associated carbonable project.
// @return carbonable_project_address The address of the corresponding Carbonable project.
@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableOffseter.carbonable_project_address();
}

// @notice Return the associated carbonable offseter.
// @return carbonable_offseter_address The address of the corresponding Carbonable offseter.
@view
func getCarbonableOffseterAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_offseter_address: felt) {
    return CarbonableYielder.carbonable_offseter_address();
}

// @notice Return the associated carbonable vester.
// @return carbonable_vester_address The address of the corresponding Carbonable vester.
@view
func getCarbonableVesterAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_vester_address: felt) {
    return CarbonableYielder.carbonable_vester_address();
}

// @notice Return the total deposited balance of the project.
// @return balance The total deposited.
@view
func getTotalDeposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    balance: Uint256
) {
    return CarbonableOffseter.total_deposited();
}

// @notice Return the total claimable absorption of the project.
// @return total_absorption The total absorption.
@view
func getTotalAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_absorption: felt
) {
    let (total_claimable) = CarbonableOffseter.total_claimable();
    return (total_absorption=total_claimable);
}

// @notice Return the total absorption balance of the provided address.
// @param address The address of the user.
// @return absorption The absorption.
@view
func getAbsorptionOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (absorption: felt) {
    let (claimable) = CarbonableOffseter.claimable_of(address=address);
    return (absorption=claimable);
}

// @notice Return the registered owner of a token id (0 if token is not owned by the contract).
// @param token_id The token id.
// @return address The registred owner address.
@view
func getRegisteredOwnerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (address: felt) {
    return CarbonableOffseter.registered_owner_of(token_id=token_id);
}

// @notice Return the registered time of a token id (0 if token is not owned by the contract).
// @param token_id The token id.
// @return time The registred time.
@view
func getRegisteredTimeOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (time: felt) {
    return CarbonableOffseter.registered_time_of(token_id=token_id);
}

// @notice Return the registered tokens of the provided address.
// @param address The address of the user.
// @return tokens_len The tokens array length.
// @return tokens The tokens deposited by the provided address.
@view
func getRegisteredTokensOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (tokens_len: felt, tokens: Uint256*) {
    return CarbonableOffseter.registered_tokens_of(address=address);
}

// @notice Return the associated carbonable vester.
// @return time The last snapshot time.
@view
func getSnapshotedTime{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    time: felt
) {
    return CarbonableYielder.snapshoted_time();
}

// @notice Return the snapshoted absorption of the provided address.
// @param address The address of the user.
// @return absorption The snapshoted absorption.
@view
func getSnapshotedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (absorption: felt) {
    return CarbonableYielder.snapshoted_of(address=address);
}

//
// Externals
//

// @notice Deposit the specified token id into the contract (lock).
// @param token_id The token id.
// @return success The success status.
@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    return CarbonableOffseter.deposit(token_id=token_id);
}

// @notice Withdraw the specified token id into the contract.
// @param token_id The token id.
// @return success The success status.
@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    return CarbonableOffseter.withdraw(token_id=token_id);
}

// @notice Snapshot the current state of claimable and claimed per user.
// @dev The caller must have the SNAPSHOTER_ROLE role.
// @return success The success status.
@external
func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    CarbonableAccessControl.assert_only_snapshoter();
    return CarbonableYielder.snapshot();
}

// @notice The Yielder goes through all assets that are deposited, during the current period, to create a vesting for each of the assets,
//   on the starkvest smart contract, by allocating shares of the total amount collected from selling carbon credit.
// @dev Snapshot must have been executed before.
//   The caller must be the contract owner.
// @param total_amount The amount, in ERC-20 value, of carbon credit sold for the current period.
// @param cliff_delta The time, in seconds, before the first vesting.
// @param start The start time of the vesting period.
// @param duration The duration of the vesting period.
// @param slice_period_seconds The time, in seconds, between each vesting.
// @param revocable The vesting revocability.
// @return success The success status.
@external
func createVestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    total_amount: felt,
    cliff_delta: felt,
    start: felt,
    duration: felt,
    slice_period_seconds: felt,
    revocable: felt,
) -> (success: felt) {
    Ownable.assert_only_owner();
    return CarbonableYielder.create_vestings(
        total_amount=total_amount,
        cliff_delta=cliff_delta,
        start=start,
        duration=duration,
        slice_period_seconds=slice_period_seconds,
        revocable=revocable,
    );
}
