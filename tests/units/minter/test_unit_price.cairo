// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_set_unit_price_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let unit_price = 10 * 10 ** 6;
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=unit_price,
        reserved_value=0,
    );

    // run scenario
    let (initial_price) = CarbonableMinter.unit_price();
    assert initial_price = unit_price;

    let new_price = 20;
    CarbonableMinter.set_unit_price(new_price);
    let (returned_price) = CarbonableMinter.unit_price();
    assert returned_price = new_price;

    return ();
}

@external
func test_set_unit_price_revert_unit_price_invalid{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
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
    let new_price = -1;
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: unit_price should be non-negative") %}
    CarbonableMinter.set_unit_price(new_price);

    return ();
}
