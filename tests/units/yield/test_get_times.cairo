// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableYielder

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    // start period at timestamp = 100
    %{ stop_warp = warp(100) %}
    let unlocked_duration = 30;
    let period_duration = 100;
    let (success) = CarbonableYielder.start_period(
        unlocked_duration=unlocked_duration, period_duration=period_duration
    );
    assert success = TRUE;
    %{ stop_warp() %}

    let (start_time) = CarbonableYielder.get_start_time();
    assert start_time = 100;

    let (lock_time) = CarbonableYielder.get_lock_time();
    assert lock_time = 130;

    let (end_time) = CarbonableYielder.get_end_time();
    assert end_time = 200;

    return ();
}
