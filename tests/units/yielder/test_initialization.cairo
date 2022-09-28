// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.farmer.library import setup, prepare, CarbonableFarmer

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let (carbonable_project_address) = CarbonableFarmer.carbonable_project_address();
    assert carbonable_project_address = context.mocks.carbonable_project_address;

    let (carbonable_token_address) = CarbonableFarmer.carbonable_token_address();
    assert carbonable_token_address = context.mocks.carbonable_token_address;

    let (reward_token_address) = CarbonableFarmer.reward_token_address();
    assert reward_token_address = context.mocks.reward_token_address;
    %{ stop() %}

    return ();
}
