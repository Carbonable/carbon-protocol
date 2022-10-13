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
    let public_sale_open = FALSE;
    let (local context) = prepare(
        public_sale_open=public_sale_open,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // run scenario
    let (initial_value) = CarbonableMinter.public_sale_open();
    assert initial_value = public_sale_open;

    let new_value = TRUE;
    CarbonableMinter.set_public_sale_open(new_value);
    let (returned_value) = CarbonableMinter.public_sale_open();
    assert returned_value = new_value;

    return ();
}