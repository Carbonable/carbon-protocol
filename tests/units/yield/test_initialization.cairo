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
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (carbonable_vester_address) = CarbonableYielder.carbonable_vester_address();
    assert carbonable_vester_address = context.mocks.carbonable_vester_address;

    let (carbonable_offseter_address) = CarbonableYielder.carbonable_offseter_address();
    assert carbonable_offseter_address = context.mocks.carbonable_offseter_address;

    let (snapshoted_time) = CarbonableYielder.snapshoted_time();
    assert snapshoted_time = 0;

    return ();
}
