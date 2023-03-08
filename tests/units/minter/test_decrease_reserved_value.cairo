// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
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
func test_decrease_reserved_value_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to decrease the reserved value by 2
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current NFT reserved value: 5
    alloc_locals;

    // prepare minter instance
    let reserved_value = 5;
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=20,
        min_value_per_tx=1,
        max_value=1000,
        unit_price=50 * 10 ** 6,
        reserved_value=reserved_value,
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    let value = 2;
    let expected_value = reserved_value - value;
    CarbonableMinter.decrease_reserved_value(value=value);
    let (returned_value) = CarbonableMinter.reserved_value();
    assert returned_value = expected_value;
    %{ stop() %}
    return ();
}

@external
func test_decrease_reserved_value_revert_over_decreased{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to decrease the reserved value by 6
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current reserved value: 5
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=20,
        min_value_per_tx=1,
        max_value=1000,
        unit_price=50 * 10 ** 6,
        reserved_value=5,
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    let value = 6;
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough reserved value") %}
    CarbonableMinter.decrease_reserved_value(value=value);
    %{ stop() %}
    return ();
}

@external
func test_decrease_reserved_value_revert_invalid_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to decrease the reserved value by 6
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current NFT reserved value: 5
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=20,
        min_value_per_tx=1,
        max_value=1000,
        unit_price=50 * 10 ** 6,
        reserved_value=5,
    );
    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    let value = -1;
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: value is not valid") %}
    CarbonableMinter.decrease_reserved_value(value=value);
    %{ stop() %}
    return ();
}
