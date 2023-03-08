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
func test_airdrop_nominal_case{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // User: admin
    // Wants to airdrop value 5
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current max_value: 5
    // current reserved value: 5
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=5,
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [5, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mintNew", [1337,0]) %}
    CarbonableMinter.airdrop(to=context.signers.anyone, value=5);
    %{ stop() %}
    return ();
}

@external
func test_airdrop_revert_not_enough_value_available{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to airdrop value 5 then 1 then 1
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current totalValue: 6
    // current reserved value: 1
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=10,
        min_value_per_tx=1,
        max_value=10,
        unit_price=50 * 10 ** 6,
        reserved_value=1,
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [6, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mintNew", [1337,0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available value") %}
    CarbonableMinter.airdrop(to=context.signers.anyone, value=5);
    %{ stop() %}
    return ();
}

@external
func test_airdrop_revert_not_enough_reserved_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to airdrop value 5 then 1 then 1
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current totalValue: 6
    // current reserved value: 1
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=20,
        min_value_per_tx=1,
        max_value=1000,
        unit_price=50 * 10 ** 6,
        reserved_value=1,
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [6, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mintNew", [1337,0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved value") %}
    CarbonableMinter.airdrop(to=context.signers.anyone, value=2);
    %{ stop() %}
    return ();
}
