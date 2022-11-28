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
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}

    %{ stop_mock=mock_call(context.mocks.carbonable_project_address, "totalSupply", [9, 0]) %}
    let (sold_out) = CarbonableMinter.sold_out();
    assert sold_out = FALSE;
    %{ stop_mock() %}

    %{ stop_mock=mock_call(context.mocks.carbonable_project_address, "totalSupply", [10, 0]) %}
    let (sold_out) = CarbonableMinter.sold_out();
    assert sold_out = TRUE;
    %{ stop_mock() %}

    return ();
}
