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

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt, min_claimable: felt, owner: felt
) {
    // Desc:
    //   Initialize the contract with the given parameters -
    //   This constructor uses a dedicated initializer that mainly stores the inputs
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   carbonable_project_address(felt): Address of the Carbonable project
    //   min_claimable(felt): Minimum threshold of claimable to allow a claim
    //   owner(felt): Owner and Admin address
    // Returns:
    //   None
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

//
// Getters
//

@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    // Desc:
    //   Return the associated carbonable project
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    return CarbonableOffseter.carbonable_project_address();
}

@view
func getMinClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    min_claimable: felt
) {
    // Desc:
    //   Return the minimum claimable quantity
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   min_claimable(felt): Minimum claimable
    return CarbonableOffseter.min_claimable();
}

@view
func getTotalDeposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    balance: Uint256
) {
    // Desc:
    //   Return the total deposited balance of the project
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   balance(Uint256): Total deposited
    return CarbonableOffseter.total_deposited();
}

@view
func getTotalClaimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_claimed: felt
) {
    // Desc:
    //   Return the total claimed absorption of the project
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   total_claimed(felt): Total claimed
    return CarbonableOffseter.total_claimed();
}

@view
func getTotalClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_claimable: felt
) {
    // Desc:
    //   Return the total claimable absorption of the project
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   total_claimable(felt): Total claimable
    return CarbonableOffseter.total_claimable();
}

@view
func getClaimableOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (claimable: felt) {
    // Desc:
    //   Return the total claimable balance of the provided address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): address
    // Returns:
    //   claimable(felt): Total claimable
    return CarbonableOffseter.claimable_of(address=address);
}

@view
func getClaimedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (claimed: felt) {
    // Desc:
    //   Return the total claimed balance of the provided address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): address
    // Returns:
    //   claimed(felt): Total claimed
    return CarbonableOffseter.claimed_of(address=address);
}

@view
func getRegisteredOwnerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (address: felt) {
    // Desc:
    //   Return the registered owner of a token id (0 if token is not owned by the contract)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   address(felt): Registred owner address
    return CarbonableOffseter.registered_owner_of(token_id=token_id);
}

@view
func getRegisteredTimeOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (time: felt) {
    // Desc:
    //   Return the registered time of a token id (0 if token is not owned by the contract)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): address
    // Returns:
    //   address(felt): Registred time
    return CarbonableOffseter.registered_time_of(token_id=token_id);
}

@view
func getRegisteredTokensOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (tokens_len: felt, tokens: Uint256*) {
    // Desc:
    //   Return the registered tokens of the provided address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): Token id
    // Returns:
    //   tokens_len(felt): Tokens array length
    //   tokens(Uint256*): Tokens deposited by the provided address
    return CarbonableOffseter.registered_tokens_of(address=address);
}

//
// Externals
//

@external
func setMinClaimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    min_claimable: felt
) -> () {
    // Desc:
    //   Set the minimum claimable quantity (must be consistent with project absorption unit)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   min_claimable(felt): New minimum claimable
    // Raises:
    //   min_claimable: min_claimable is null
    Ownable.assert_only_owner();
    return CarbonableOffseter.set_min_claimable(min_claimable=min_claimable);
}

@external
func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) -> (
    success: felt
) {
    // Desc:
    //   Claim all the claimable balance of the caller address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   quantity(felt): Quantity to claim
    // Returns:
    //   success(felt): Success status
    // Raises:
    //   quantity: quantity is higher than the caller total claimable
    return CarbonableOffseter.claim(quantity=quantity);
}

@external
func claimAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    // Desc:
    //   Claim all the total claimable of the caller address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   success(felt): Success status
    return CarbonableOffseter.claim_all();
}

@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    // Desc:
    //   Deposit the specified token id into the contract (lock)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   success(felt): Success status
    return CarbonableOffseter.deposit(token_id=token_id);
}

@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    // Desc:
    //   Withdraw the specified token id into the contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   success(felt): Success status
    return CarbonableOffseter.withdraw(token_id=token_id);
}
