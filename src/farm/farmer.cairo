// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.farm.library import CarbonableFarmer

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt,
    carbonable_project_address: felt,
    carbonable_token_address: felt,
    reward_token_address: felt,
) {
    // Desc:
    //   Initialize the contract with the given parameters -
    //   This constructor uses a dedicated initializer that mainly stores the inputs
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   owner(felt): Owner address
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    //   carbonable_token_address(felt): Address of the Carbonable token
    //   reward_token_address(felt): Address of the reward token
    // Returns:
    //   None
    return CarbonableFarmer.constructor(
        owner, carbonable_project_address, carbonable_token_address, reward_token_address
    );
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
func reward_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    reward_token_address: felt
) {
    // Desc:
    //   Return the associated reward token
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   reward_token_address(felt): Address of the reward token
    return CarbonableFarmer.reward_token_address();
}

@view
func carbonable_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_token_address: felt) {
    // Desc:
    //   Return the associated carbonable token
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   carbonable_token_address(felt): Address of the Carbonable token
    return CarbonableFarmer.carbonable_token_address();
}
