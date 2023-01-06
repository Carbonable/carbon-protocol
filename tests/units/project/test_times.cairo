// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le

// Local dependencies
from tests.units.project.library import setup, prepare, CarbonableProject

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_start_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (time) = CarbonableProject.start_time();
    assert time = context.absorption.times[0];
    return ();
}

@external
func test_start_time_revert_not_defined{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: times must be defined") %}
    let (time) = CarbonableProject.start_time();
    return ();
}

@external
func test_final_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (time) = CarbonableProject.final_time();
    assert time = context.absorption.times[context.absorption.times_len - 1];
    return ();
}

@external
func test_final_time_revert_not_defined{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: times must be defined") %}
    let (time) = CarbonableProject.final_time();
    return ();
}
