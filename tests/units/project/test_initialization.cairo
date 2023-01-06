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

    let (times_len, times) = CarbonableProject.times();
    assert times_len = context.absorption.times_len;
    let first_time = times[0];
    assert first_time = context.absorption.times[0];
    let final_time = times[times_len - 1];
    assert final_time = context.absorption.times[times_len - 1];

    let (absorptions_len, absorptions) = CarbonableProject.absorptions();
    assert absorptions_len = context.absorption.values_len;
    let first_absorption = absorptions[0];
    assert first_absorption = context.absorption.values[0];
    let final_absorption = absorptions[absorptions_len - 1];
    assert final_absorption = context.absorption.values[absorptions_len - 1];

    let (ton_equivalent) = CarbonableProject.ton_equivalent();
    assert ton_equivalent = context.absorption.ton_equivalent;

    return ();
}
