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

    let (time_step) = CarbonableOffseter.time_step();
    assert time_step = context.absorption.time_step;

    let (absorptions_len, absorptions) = CarbonableOffseter.absorptions();
    assert absorptions_len = context.absorption.values_len;
    assert absorptions[0] = context.absorption.values[0];
    assert absorptions[absorptions_len - 1] = context.absorption.values[absorptions_len - 1];

    return ();
}
