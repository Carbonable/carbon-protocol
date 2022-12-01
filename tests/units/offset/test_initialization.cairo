// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.offset.library import setup, prepare, CarbonableOffseter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (carbonable_project_address) = CarbonableOffseter.carbonable_project_address();
    assert carbonable_project_address = context.mocks.carbonable_project_address;

    %{ stop_warp = warp(1) %}
    let (is_locked) = CarbonableOffseter.is_locked();
    assert is_locked = FALSE;
    %{ stop_warp() %}

    return ();
}
