// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.farming.library import setup, prepare, CarbonableFarming

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}


@external
func test_add_price_revert_no_capture{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (local context) = prepare();

    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getStartTime", [0]) %}
    
    CarbonableFarming.add_price(time=1, price=0);
    
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarming: the period must capture absorption") %}
    CarbonableFarming.add_price(time=1, price=0);

    return ();
}
