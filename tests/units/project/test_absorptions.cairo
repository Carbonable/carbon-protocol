// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256

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
    let new_len = 5;

    // [Effect] Define new times
    let (local new_times: felt*) = alloc();
    assert [new_times + 0] = 1;
    assert [new_times + 1] = 2;
    assert [new_times + 2] = 3;
    assert [new_times + 3] = 4;
    assert [new_times + 4] = 5;

    // [Effect] Define new absorptions
    let (local new_absorptions: felt*) = alloc();
    assert [new_absorptions + 0] = 1;
    assert [new_absorptions + 1] = 2;
    assert [new_absorptions + 2] = 3;
    assert [new_absorptions + 3] = 4;
    assert [new_absorptions + 4] = 5;

    // [Effect] Define new ton equivalent
    let new_ton_equivalent = 1;

    // [Effect] Apply new configuration
    local low = context.absorption.slot.low;
    local high = context.absorption.slot.high;
    %{
        warp(blk_timestamp=200)
        expect_events(dict(name="AbsorptionUpdate", data=dict(slot=dict(low=ids.low, high=ids.high), time=200)))
    %}
    CarbonableProject.set_absorptions(
        slot=context.absorption.slot,
        len=new_len,
        times=new_times,
        absorptions=new_absorptions,
        ton_equivalent=new_ton_equivalent,
    );

    // [Check] New values applied
    let (times_len, times) = CarbonableProject.times(slot=context.absorption.slot);
    assert times_len = new_len;
    assert times[0] = new_times[0];
    assert times[times_len - 1] = new_times[new_len - 1];

    let (absorptions_len, absorptions) = CarbonableProject.absorptions(
        slot=context.absorption.slot
    );
    assert absorptions_len = new_len;
    assert absorptions[0] = new_absorptions[0];
    assert absorptions[absorptions_len - 1] = new_absorptions[new_len - 1];

    let (ton_equivalent) = CarbonableProject.ton_equivalent(slot=context.absorption.slot);
    assert ton_equivalent = new_ton_equivalent;

    return ();
}

@external
func test_current_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    // Before start, absorption = 0
    %{ stop_warp=warp(blk_timestamp=context.absorption.times[0] - 86000) %}
    let (absorption) = CarbonableProject.current_absorption(slot=context.absorption.slot);
    assert absorption = 0;
    %{ stop_warp() %}

    // At start, absorption = absorptions[0]
    %{ stop_warp=warp(blk_timestamp=context.absorption.times[0]) %}
    let (absorption) = CarbonableProject.current_absorption(slot=context.absorption.slot);
    assert absorption = context.absorption.values[0];
    %{ stop_warp() %}

    // After start, absorptions[0] < absorption < absorptions[1]
    %{ stop_warp=warp(blk_timestamp=context.absorption.times[0] + 86000) %}
    let (absorption) = CarbonableProject.current_absorption(slot=context.absorption.slot);
    let is_higher = is_le(context.absorption.values[0] + 1, absorption);
    assert is_higher = TRUE;
    let is_lower = is_le(absorption + 1, context.absorption.values[1]);
    assert is_lower = TRUE;
    %{ stop_warp() %}

    // Before end, absorptions[-2] < absorption < absorptions[-1]
    %{
        blk_timestamp = context.absorption.times[-1] - 86000
        stop_warp=warp(blk_timestamp=blk_timestamp)
    %}
    let (absorption) = CarbonableProject.current_absorption(slot=context.absorption.slot);
    let is_higher = is_le(
        context.absorption.values[context.absorption.len - 2] + 86000, absorption
    );
    assert is_higher = TRUE;
    let is_lower = is_le(absorption + 86000, context.absorption.values[context.absorption.len - 1]);
    assert is_lower = TRUE;
    %{ stop_warp() %}

    // At end, absorption = absorptions[-1]
    %{
        blk_timestamp = context.absorption.times[-1]
        stop_warp=warp(blk_timestamp=blk_timestamp)
    %}
    let (absorption) = CarbonableProject.current_absorption(slot=context.absorption.slot);
    assert absorption = context.absorption.values[context.absorption.len - 1];
    %{ stop_warp() %}

    // After end, absorption = absorptions[-1]
    %{
        blk_timestamp = context.absorption.times[-1] + 86000
        stop_warp=warp(blk_timestamp=blk_timestamp)
    %}
    let (absorption) = CarbonableProject.current_absorption(slot=context.absorption.slot);
    assert absorption = context.absorption.values[context.absorption.len - 1];
    %{ stop_warp() %}

    return ();
}

@external
func test_final_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare instance
    let (local context) = prepare();

    let (absorption) = CarbonableProject.final_absorption(slot=context.absorption.slot);
    assert absorption = context.absorption.values[context.absorption.len - 1];

    return ();
}

@external
func test_final_absorption_zero_not_set{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let one = Uint256(low=1, high=0);
    let (absorption) = CarbonableProject.final_absorption(slot=one);
    assert absorption = 0;

    return ();
}

@external
func test_absorption_zero_not_set{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let one = Uint256(low=1, high=0);
    let (absorption) = CarbonableProject.current_absorption(slot=one);
    assert absorption = 0;

    return ();
}

@external
func test_set_absorptions_revert_not_defined{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let one = Uint256(low=1, high=0);
    let (local times: felt*) = alloc();
    let (local absorptions: felt*) = alloc();
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableProject: times and absorptions must be defined and equal") %}
    CarbonableProject.set_absorptions(
        slot=one, len=0, times=times, absorptions=absorptions, ton_equivalent=1
    );
    return ();
}
