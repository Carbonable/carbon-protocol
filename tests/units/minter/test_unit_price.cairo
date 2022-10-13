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
    let unit_price = Uint256(10, 0);
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=unit_price,
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // run scenario
    let (initial_price) = CarbonableMinter.unit_price();
    assert initial_price = unit_price;

    let new_price = Uint256(20, 0);
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
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // run scenario
    let new_price = Uint256(20, -1);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: unit_price is not a valid Uint256") %}
    CarbonableMinter.set_unit_price(new_price);

    return ();
}
