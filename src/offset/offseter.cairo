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

//
// Initializer
//

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated initializer that mainly stores the inputs.
// @param carbonable_project_address The address of the Carbonable project.
// @param min_claimable The minimum threshold of claimable to allow a claim.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt, min_claimable: felt, owner: felt
) {
    alloc_locals;

    CarbonableOffseter.initializer(carbonable_project_address);
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
// Getters
//

// @notice Return the associated carbonable project.
// @return carbonable_project_address The address of the corresponding Carbonable project.
@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableOffseter.carbonable_project_address();
}

// @notice Return the minimum claimable quantity.
// @return min_claimable The minimum claimable.
@view
func getMinClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    min_claimable: felt
) {
    return CarbonableOffseter.min_claimable();
}

// @notice Return the total deposited balance of the project.
// @return balance The total deposited.
@view
func getTotalDeposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    balance: Uint256
) {
    return CarbonableOffseter.total_deposited();
}

// @notice Return the total claimed balance of the project.
// @return balance The total claimed.
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
// @param address The address to query.
// @return tokens_len The tokens array length.
// @return tokens The tokens deposited by the provided address.
@view
func getRegisteredTokensOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (tokens_len: felt, tokens: Uint256*) {
    return CarbonableOffseter.registered_tokens_of(address=address);
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

// @notice Deposit tokens to the project.
// @dev Quantity cannot be higher than the caller total claimable.
// @param token_id The token id.
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
// @return success The success status.
@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    return CarbonableOffseter.deposit(token_id=token_id);
}

// @notice Withdraw the specified token id into the contract.
// @dev Token id must be owned by the contract.
// @param token_id The token id.
// @return success The success status.
@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    return CarbonableOffseter.withdraw(token_id=token_id);
}
