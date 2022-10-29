// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Project dependencies
from openzeppelin.access.ownable.library import Ownable

// Local dependencies
from src.farm.library import CarbonableFarmer, CarbonableOffseter

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt,
    carbonable_project_address: felt,
    start: felt,
    end: felt,
    locked_duration: felt,
    period_duration: felt,
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
    // Returns:
    //   None
    CarbonableFarmer.initializer(start, end, locked_duration, period_duration, carbonable_project_address);
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
