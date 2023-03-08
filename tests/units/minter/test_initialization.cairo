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
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let public_sale_open = TRUE;
    let max_value_per_tx = 20;
    let min_value_per_tx = 1;
    let max_value = 1000;
    let unit_price = 50 * 10 ** 6;
    let reserved_value = 300;
    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=public_sale_open,
        max_value_per_tx=max_value_per_tx,
        min_value_per_tx=min_value_per_tx,
        max_value=max_value,
        unit_price=unit_price,
        reserved_value=reserved_value,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let (returned_carbonable_project_address) = CarbonableMinter.carbonable_project_address();
    assert returned_carbonable_project_address = context.mocks.carbonable_project_address;

    let (payment_token_address) = CarbonableMinter.payment_token_address();
    assert payment_token_address = context.mocks.payment_token_address;

    let (pre_sale_open) = CarbonableMinter.pre_sale_open();
    let (whitelist_merkle_root) = CarbonableMinter.whitelist_merkle_root();
    assert pre_sale_open = whitelist_merkle_root;

    let (returned_public_sale_open) = CarbonableMinter.public_sale_open();
    assert returned_public_sale_open = public_sale_open;

    let (returned_max_value_per_tx) = CarbonableMinter.max_value_per_tx();
    assert returned_max_value_per_tx = max_value_per_tx;

    let (returned_min_value_per_tx) = CarbonableMinter.min_value_per_tx();
    assert returned_min_value_per_tx = min_value_per_tx;

    let (returned_unit_price) = CarbonableMinter.unit_price();
    assert returned_unit_price = unit_price;

    let (returned_max_value) = CarbonableMinter.max_value();
    assert returned_max_value = max_value;

    let (returned_reserved_value) = CarbonableMinter.reserved_value();
    assert returned_reserved_value = reserved_value;
    %{ stop() %}

    return ();
}

@external
func test_initialization_revert_unit_price_invalid{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: unit_price should be non-negative") %}
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=20,
        min_value_per_tx=1,
        max_value=1000,
        unit_price=-1,
        reserved_value=300,
    );

    return ();
}

@external
func test_initialization_revert_max_value_invalid{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: reserved_value should be smaller than max_value") %}
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=20,
        min_value_per_tx=1,
        max_value=-1,
        unit_price=50 * 10 ** 6,
        reserved_value=300,
    );

    return ();
}

@external
func test_initialization_revert_reserved_supply_for_mint_invalid{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: reserved_value should be non-negative") %}
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=50 * 10 ** 6,
        reserved_value=-1,
    );

    return ();
}
