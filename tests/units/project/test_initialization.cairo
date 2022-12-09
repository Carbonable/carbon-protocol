// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.project.library import setup, prepare, CarbonableProject

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (status) = CarbonableProject.is_setup();
    assert status = TRUE;

    let (start_time) = CarbonableProject.start_time();
    assert start_time = context.absorption.start_time;

    let (time_step) = CarbonableProject.time_step();
    assert time_step = context.absorption.time_step;

    let (absorptions_len, absorptions) = CarbonableProject.absorptions();
    assert absorptions_len = context.absorption.values_len;
    assert absorptions[0] = context.absorption.values[0];
    assert absorptions[absorptions_len - 1] = context.absorption.values[absorptions_len - 1];

    return ();
}
