// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable

// Local dependencies
from src.farm.library import CarbonableFarmer

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt, owner: felt
) {
    // Desc:
    //   Initialize the contract with the given parameters -
    //   This constructor uses a dedicated initializer that mainly stores the inputs
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    //   owner(felt): Owner address
    // Returns:
    //   None
    CarbonableFarmer.initializer(carbonable_project_address);
    Ownable.initializer(owner);
    return ();
}

//
// Getters
//

@view
func carbonable_project_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    // Desc:
    //   Return the associated carbonable project
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    return CarbonableFarmer.carbonable_project_address();
}

@view
func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    status: felt
) {
    // Desc:
    //   Return the locked status of deposites and withdrawals
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   status(felt): Locked status
    return CarbonableFarmer.is_locked();
}

@view
func total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    balance: Uint256
) {
    // Desc:
    //   Return the current number of tokens locked in the contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   balance(Uint256): Total balance of locked tokens
    return CarbonableFarmer.total_locked();
}

@view
func share{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt, precision: felt
) -> (share: Uint256) {
    // Desc:
    //   Return the current share of a specified address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): Address
    //   precision(felt): Decimal of the returned share
    // Returns:
    //   share(Uint256): Share associated to the address
    return CarbonableFarmer.share(address=address, precision=precision);
}

@view
func registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (address: felt) {
    // Desc:
    //   Return the registred owner of a token id (0 if token is not locked in the contract)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   address(felt): Registred owner address
    return CarbonableFarmer.registred_owner_of(token_id=token_id);
}

//
// Externals
//

@external
func start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    unlocked_duration: felt, period_duration: felt
) -> (success: felt) {
    // Desc:
    //   Start a new period (erase the current one)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   unlocked_duration(felt): Unlocked duration in seconds
    //   period_duration(felt): Period duration in seconds
    // Returns:
    //   success(felt): Success status
    Ownable.assert_only_owner();
    return CarbonableFarmer.start_period(
        unlocked_duration=unlocked_duration, period_duration=period_duration
    );
}

@external
func stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    // Desc:
    //   Stop the current period
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   success(felt): Success status
    Ownable.assert_only_owner();
    return CarbonableFarmer.stop_period();
}

@external
func deposite{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    // Desc:
    //   Deposite the specified token id into the contract (lock)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   success(felt): Success status
    return CarbonableFarmer.deposite(token_id=token_id);
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
    return CarbonableFarmer.withdraw(token_id=token_id);
}
