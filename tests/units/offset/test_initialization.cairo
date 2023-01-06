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

    let (min_claimable) = CarbonableOffseter.min_claimable();
    assert min_claimable = context.claim.minimum;

    return ();
}

@external
func test_set_min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (min_claimable) = CarbonableOffseter.min_claimable();
    assert min_claimable = context.claim.minimum;

    let new_minimum = 2000000;
    CarbonableOffseter.set_min_claimable(min_claimable=new_minimum);

    let (min_claimable) = CarbonableOffseter.min_claimable();
    assert min_claimable = new_minimum;

    return ();
}
