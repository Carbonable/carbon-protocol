// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

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

    // prepare minter instance
    let public_sale_open = FALSE;
    let max_buy_per_tx = 5;
    let unit_price = Uint256(10, 0);
    let max_supply_for_mint = Uint256(10, 0);
    let reserved_supply_for_mint = Uint256(5, 0);
    let (local context) = prepare(
        public_sale_open=public_sale_open,
        max_buy_per_tx=max_buy_per_tx,
        unit_price=unit_price,
        max_supply_for_mint=max_supply_for_mint,
        reserved_supply_for_mint=reserved_supply_for_mint,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let (returned_carbonable_project_address) = CarbonableMinter.carbonable_project_address();
    assert returned_carbonable_project_address = context.mocks.carbonable_project_address;

    let (payment_token_address) = CarbonableMinter.payment_token_address();
    assert payment_token_address = context.mocks.payment_token_address;

    let (whitelisted_sale_open) = CarbonableMinter.whitelisted_sale_open();
    let (whitelist_merkle_root) = CarbonableMinter.whitelist_merkle_root();
    assert whitelisted_sale_open = whitelist_merkle_root;

    let (returned_public_sale_open) = CarbonableMinter.public_sale_open();
    assert returned_public_sale_open = public_sale_open;

    let (returned_max_buy_per_tx) = CarbonableMinter.max_buy_per_tx();
    assert returned_max_buy_per_tx = max_buy_per_tx;

    let (returned_unit_price) = CarbonableMinter.unit_price();
    assert returned_unit_price = unit_price;

    let (returned_reserved_supply_for_mint) = CarbonableMinter.reserved_supply_for_mint();
    assert returned_reserved_supply_for_mint = reserved_supply_for_mint;
    %{ stop() %}

    return ();
}
