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
func test_times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (times_len, times) = CarbonableProject.times();
    assert times_len = context.absorption.times_len;
    assert times[0] = context.absorption.times[0];
    assert times[times_len - 1] = context.absorption.times[times_len - 1];

    let (local new_times: felt*) = alloc();
    assert [new_times + 0] = 1;
    assert [new_times + 1] = 2;
    assert [new_times + 2] = 3;
    assert [new_times + 3] = 4;
    assert [new_times + 4] = 5;
    let new_times_len = 5;
    CarbonableProject.set_times(times_len=new_times_len, times=new_times);

    let (times_len, times) = CarbonableProject.times();
    assert times_len = new_times_len;
    assert times[0] = new_times[0];
    assert times[times_len - 1] = new_times[new_times_len - 1];

    return ();
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

@external
func test_set_times_revert_not_defined{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: times must be defined") %}
    let (local times: felt*) = alloc();
    CarbonableProject.set_times(times_len=0, times=times);
    return ();
}
