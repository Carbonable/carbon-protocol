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
func test_set_max_value_per_tx_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let max_value_per_tx = 20;
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=max_value_per_tx,
        min_value_per_tx=1,
        max_value=1000,
        unit_price=50 * 10 ** 6,
        reserved_value=300,
    );

    // run scenario
    let (initial_value) = CarbonableMinter.max_value_per_tx();
    assert initial_value = max_value_per_tx;

    let new_value = 3;
    CarbonableMinter.set_max_value_per_tx(new_value);
    let (returned_value) = CarbonableMinter.max_value_per_tx();
    assert returned_value = new_value;

    return ();
}
