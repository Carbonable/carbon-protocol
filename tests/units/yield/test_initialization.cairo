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
    
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    let (payment_token_address) = CarbonableYielder.payment_token_address();
    assert payment_token_address = context.mocks.payment_token_address;

    let (total_claimable) = CarbonableYielder.total_claimable();
    assert total_claimable = 0;

    let (total_claimed) = CarbonableYielder.total_claimed();
    assert total_claimed = 0;

    let (claimable) = CarbonableYielder.claimable_of(context.signers.anyone);
    assert claimable = 0;

    let (claimed) = CarbonableYielder.claimed_of(context.signers.anyone);
    assert claimed = 0;

    return ();
}
