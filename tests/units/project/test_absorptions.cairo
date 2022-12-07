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
func test_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (absorptions_len, absorptions) = CarbonableProject.absorptions();
    assert absorptions_len = context.absorption.values_len;
    assert absorptions[0] = context.absorption.values[0];
    assert absorptions[absorptions_len - 1] = context.absorption.values[absorptions_len - 1];

    let (local new_absorptions: felt*) = alloc();
    assert [new_absorptions + 0] = 1;
    assert [new_absorptions + 1] = 2;
    assert [new_absorptions + 2] = 3;
    assert [new_absorptions + 3] = 4;
    assert [new_absorptions + 4] = 5;
    let new_absorptions_len = 5;
    CarbonableProject.set_absorptions(
        absorptions_len=new_absorptions_len, absorptions=new_absorptions
    );

    let (absorptions_len, absorptions) = CarbonableProject.absorptions();
    assert absorptions_len = new_absorptions_len;
    assert absorptions[0] = new_absorptions[0];
    assert absorptions[new_absorptions_len - 1] = new_absorptions[new_absorptions_len - 1];

    return ();
}

@external
func test_current_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    // Before start, absorption = 0
    %{ stop_warp=warp(blk_timestamp=0) %}
    let (absorption) = CarbonableProject.current_absorption();
    assert absorption = 0;
    %{ stop_warp() %}

    // At start, absorption = absorptions[0]
    %{ stop_warp=warp(blk_timestamp=100) %}
    let (absorption) = CarbonableProject.current_absorption();
    assert absorption = context.absorption.values[0];
    %{ stop_warp() %}

    // After start, absorptions[0] < absorption < absorptions[1]
    %{ stop_warp=warp(blk_timestamp=101) %}
    let (absorption) = CarbonableProject.current_absorption();
    let is_higher = is_le(context.absorption.values[0], absorption - 1);
    assert is_higher = TRUE;
    let is_lower = is_le(absorption, context.absorption.values[1] - 1);
    assert is_lower = TRUE;
    %{ stop_warp() %}

    // Before end, absorptions[-2] < absorption < absorptions[-1]
    %{
        blk_timestamp = context.absorption.time_step * (len(context.absorption.values) - 1) + context.absorption.start_time - 1
        stop_warp=warp(blk_timestamp=blk_timestamp)
    %}
    let (absorption) = CarbonableProject.current_absorption();
    let is_higher = is_le(
        context.absorption.values[context.absorption.values_len - 2], absorption - 1
    );
    assert is_higher = TRUE;
    let is_lower = is_le(
        absorption, context.absorption.values[context.absorption.values_len - 1] - 1
    );
    assert is_lower = TRUE;
    %{ stop_warp() %}

    // At end, absorption = absorptions[-1]
    %{
        blk_timestamp = context.absorption.time_step * (len(context.absorption.values) - 1) + context.absorption.start_time
        stop_warp=warp(blk_timestamp=blk_timestamp)
    %}
    let (absorption) = CarbonableProject.current_absorption();
    assert absorption = context.absorption.values[context.absorption.values_len - 1];
    %{ stop_warp() %}

    // After end, absorption = absorptions[-1]
    %{
        blk_timestamp = context.absorption.time_step * (len(context.absorption.values) - 1) + context.absorption.start_time + 1
        stop_warp=warp(blk_timestamp=blk_timestamp)
    %}
    let (absorption) = CarbonableProject.current_absorption();
    assert absorption = context.absorption.values[context.absorption.values_len - 1];
    %{ stop_warp() %}

    return ();
}

@external
func test_final_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (absorption) = CarbonableProject.final_absorption();
    assert absorption = context.absorption.values[context.absorption.values_len - 1];
    return ();
}

@external
func test_final_absorption_revert_not_defined{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: absorptions must be defined") %}
    let (absorption) = CarbonableProject.final_absorption();
    return ();
}

@external
func test_set_absorptions_revert_not_defined{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (local absorptions: felt*) = alloc();
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: absorptions must be defined") %}
    CarbonableProject.set_absorptions(absorptions_len=0, absorptions=absorptions);
    return ();
}

@external
func test_set_time_revert_not_null{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: time_step must be not null") %}
    CarbonableProject.set_time(start_time=0, time_step=0);
    return ();
}
