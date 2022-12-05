// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from tests.units.offset.library import setup, prepare, CarbonableOffseter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let values_len = context.absorption.values_len;

    %{ stop_warp=warp(blk_timestamp=0) %}
    let (absorption) = CarbonableOffseter.total_absorption();
    assert absorption = context.absorption.values[0];
    %{ stop_warp() %}

    %{ stop_warp=warp(blk_timestamp=1000) %}
    let (absorption) = CarbonableOffseter.total_absorption();
    assert absorption = context.absorption.values[values_len - 1];
    %{ stop_warp() %}

    return ();
}
