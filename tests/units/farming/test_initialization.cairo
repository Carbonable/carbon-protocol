// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.farming.library import setup, prepare, CarbonableFarming

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [0]) %}

    let (carbonable_project_address) = CarbonableFarming.carbonable_project_address();
    assert carbonable_project_address = context.mocks.carbonable_project_address;

    let (carbonable_project_slot) = CarbonableFarming.carbonable_project_slot();
    assert carbonable_project_slot.low = context.mocks.carbonable_project_slot;

    let (total_deposited) = CarbonableFarming.total_deposited();
    assert total_deposited.low = 0;
    assert total_deposited.high = 0;

    let (total_absorption) = CarbonableFarming.total_absorption();
    assert total_absorption = 0;

    let (total_sale) = CarbonableFarming.total_sale();
    assert total_sale = 0;

    let (deposited) = CarbonableFarming.deposited_of(context.signers.anyone);
    assert deposited.low = 0;
    assert deposited.high = 0;

    let (absorption) = CarbonableFarming.absorption_of(context.signers.anyone);
    assert absorption = 0;

    let (sale) = CarbonableFarming.sale_of(context.signers.anyone);
    assert sale = 0;

    return ();
}
