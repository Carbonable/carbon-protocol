// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_sold_out{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=0,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}

    %{
        stop_mocks = [
            mock_call(context.mocks.carbonable_project_address, "totalValue", [9, 0]),
            mock_call(context.mocks.carbonable_project_address, "getProjectValue", [10, 0])
        ]
    %}
    let (sold_out) = CarbonableMinter.sold_out();
    assert sold_out = FALSE;
    %{ for stop in stop_mocks: stop() %}

    %{
        stop_mocks = [
            mock_call(context.mocks.carbonable_project_address, "totalValue", [10, 0]),
            mock_call(context.mocks.carbonable_project_address, "getProjectValue", [10, 0])
        ]
    %}
    let (sold_out) = CarbonableMinter.sold_out();
    assert sold_out = TRUE;
    %{ for stop in stop_mocks: stop() %}

    return ();
}
