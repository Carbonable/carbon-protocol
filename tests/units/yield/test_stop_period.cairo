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
func test_stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
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

    // check if locked at timestamp = 131
    %{ stop_warp = warp(131) %}
    let (is_locked) = CarbonableYielder.is_locked();
    assert is_locked = TRUE;
    %{ stop_warp() %}

    // stop period
    let (success) = CarbonableYielder.stop_period();
    assert success = TRUE;

    // check if locked at timestamp = 131
    %{ stop_warp = warp(131) %}
    let (is_locked) = CarbonableYielder.is_locked();
    assert is_locked = FALSE;
    %{ stop_warp() %}

    return ();
}
