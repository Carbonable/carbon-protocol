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
func test_set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare minter instance
    let public_sale_open = FALSE;
    let (local context) = prepare(
        public_sale_open=public_sale_open,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=0,
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

@external
func test_set_public_sale_open_revert_not_boolean{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let public_sale_open = -1;
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: public_sale_open must be either 0 or 1") %}
    CarbonableMinter.set_public_sale_open(public_sale_open);

    return ();
}
