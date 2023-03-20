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

    let (slot) = CarbonableOffseter.carbonable_project_slot();
    assert slot.low = context.offset.slot;
    assert slot.high = 0;

    let (min_claimable) = CarbonableOffseter.min_claimable();
    assert min_claimable = context.offset.minimum;

    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [0, 0]) %}
    let (total_deposited) = CarbonableOffseter.total_deposited();
    assert total_deposited.low = 0;
    assert total_deposited.high = 0;

    let (total_claimable) = CarbonableOffseter.total_claimable();
    assert total_claimable = 0;

    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    let (deposited) = CarbonableOffseter.deposited_of(context.signers.anyone);
    assert deposited.low = 0;
    assert deposited.high = 0;

    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [0]) %}
    let (claimable) = CarbonableOffseter.claimable_of(context.signers.anyone);
    assert claimable = 0;

    let (claimed) = CarbonableOffseter.claimed_of(context.signers.anyone);
    assert claimed = 0;

    return ();
}

@external
func test_set_min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (min_claimable) = CarbonableOffseter.min_claimable();
    assert min_claimable = context.offset.minimum;

    let new_minimum = 2000000;
    CarbonableOffseter.set_min_claimable(min_claimable=new_minimum);

    let (min_claimable) = CarbonableOffseter.min_claimable();
    assert min_claimable = new_minimum;

    return ();
}
