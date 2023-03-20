// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.offset.library import CarbonableOffseter

//
// Initializer
//

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated initializer that mainly stores the inputs.
// @param carbonable_project_address The address of the Carbonable project.
// @param carbonable_project_slot The slot of the Carbonable project.
// @param min_claimable The minimum threshold of claimable to allow a claim.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt,
    carbonable_project_slot: Uint256,
    min_claimable: felt,
    owner: felt,
) {
    alloc_locals;

    CarbonableOffseter.initializer(carbonable_project_address, carbonable_project_slot);
    CarbonableOffseter.set_min_claimable(min_claimable);
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

// @notice Return the contract owner.
// @return owner The owner address.
@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev This function is only callable by the owner.
//   The new owner cannot be the zero address.
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
// Getters
//

// @notice Return the associated carbonable project address.
// @return carbonable_project_address The address of the corresponding Carbonable project.
@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableOffseter.carbonable_project_address();
}

// @notice Return the associated carbonable project slot.
// @return carbonable_project_slot The slot of the corresponding Carbonable project.
@view
func getCarbonableProjectSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_slot: Uint256) {
    return CarbonableOffseter.carbonable_project_slot();
}

// @notice Return the minimum claimable quantity.
// @return min_claimable The minimum claimable.
@view
func getMinClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    min_claimable: felt
) {
    return CarbonableOffseter.min_claimable();
}

// @notice Return the total value deposited balance of the project.
// @return value The total value deposited.
@view
func getTotalDeposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    value: Uint256
) {
    return CarbonableOffseter.total_deposited();
}

// @notice Return the total absorption of the project.
// @return total_absorption The total absorption.
@view
func getTotalAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_absorption: felt
) {
    return CarbonableOffseter.total_absorption();
}

// @notice Return the total claimed balance of the project.
// @return total_claimed The total claimed.
@view
func getTotalClaimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_claimed: felt
) {
    return CarbonableOffseter.total_claimed();
}

// @notice Return the total claimable absorption of the project.
// @return total_claimable The total claimable.
@view
func getTotalClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_claimable: felt
) {
    return CarbonableOffseter.total_claimable();
}

// @notice Return the total deposited value of the provided address.
// @param address The address to query.
// @return value The total value.
@view
func getDepositedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (value: Uint256) {
    return CarbonableOffseter.deposited_of(address=address);
}

// @notice Return the total absorption of the provided address.
// @param address The address to query.
// @return absorption The total absorption.
@view
func getAbsorptionOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (absorption: felt) {
    return CarbonableOffseter.absorption_of(address=address);
}

// @notice Return the total claimable balance of the provided address.
// @param address The address to query.
// @return claimable The total claimable.
@view
func getClaimableOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (claimable: felt) {
    return CarbonableOffseter.claimable_of(address=address);
}

// @notice Return the total claimed balance of the provided address.
// @param address The address to query.
// @return claimed The total claimed.
@view
func getClaimedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (claimed: felt) {
    return CarbonableOffseter.claimed_of(address=address);
}

//
// Externals
//

// @notice Set the minimum claimable quantity (must be consistent with project absorption unit)
// @dev min_claimable cannot be null.
// @param min_claimable The new minimum claimable.
// @return success The success flag.
@external
func setMinClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    min_claimable: felt
) -> () {
    Ownable.assert_only_owner();
    return CarbonableOffseter.set_min_claimable(min_claimable=min_claimable);
}

// @notice Claim the specified quantity of claimable.
// @dev Quantity cannot be higher than the caller total claimable.
// @param quantity The quantity to claim
// @return success The success status.
@external
func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) -> (
    success: felt
) {
    return CarbonableOffseter.claim(quantity=quantity);
}

// @notice Claim all the total claimable of the caller address.
// @return success The success status.
@external
func claimAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    return CarbonableOffseter.claim_all();
}

// @notice Deposit tokens to the project.
// @dev Token id must be owned by the caller.
// @param token_id The token id.
// @param value The value to transfer.
// @return success The success status.
@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, value: Uint256
) -> (success: felt) {
    return CarbonableOffseter.deposit(token_id=token_id, value=value);
}

// @notice Withdraw the specified value to a new token.
// @param value The value to withdraw.
// @return success The success status.
@external
func withdrawTo{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: Uint256
) -> (success: felt) {
    return CarbonableOffseter.withdraw_to(value=value);
}

// @notice Withdraw the specified value into the specified token.
// @dev Token id must be owned by the caller.
// @param token_id The token id.
// @param value The value to withdraw.
// @return success The success status.
@external
func withdrawToToken{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, value: Uint256
) -> (success: felt) {
    return CarbonableOffseter.withdraw_to_token(token_id=token_id, value=value);
}
