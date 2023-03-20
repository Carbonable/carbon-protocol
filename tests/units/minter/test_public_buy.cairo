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
func test_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // User: anyone
    // Wants to buy 2 NFTs
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current NFT totalSupply: 5
    // current NFT reserved supply: 0
    // has enough funds: YES
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
    %{ stop=start_prank(context.signers.anyone) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [5, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mintNew", [1337, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ warp(blk_timestamp=200) %}
    %{ expect_events(dict(name="Buy", data=dict(address=context.signers.anyone, value=dict(low=2,high=0), time=200))) %}
    let (success) = CarbonableMinter.public_buy(value=2, force=FALSE);
    assert success = TRUE;
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_not_enough_value_available{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: anyone
    // Wants to buy 2 NFTs
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current NFT totalSupply: 10
    // current NFT reserved supply: 0
    // has enough funds: YES
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
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 2;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [10, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available value") %}
    CarbonableMinter.public_buy(value=value, force=FALSE);
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_not_enough_available_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: anyone
    // Wants to buy 2 NFTs
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current NFT totalSupply: 0
    // current NFT reserved supply: 9
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=9,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 2;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [0, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available value") %}
    CarbonableMinter.public_buy(value=value, force=FALSE);
    %{ stop() %}
    return ();
}

@external
func test_force_buy_over_min{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=9,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 2;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mintNew", [1337, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    CarbonableMinter.public_buy(value=value, force=TRUE);
    %{ stop() %}
    return ();
}

@external
func test_force_buy_below_min{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_value_per_tx=5,
        min_value_per_tx=2,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=9,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 2;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mintNew", [1337, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    CarbonableMinter.public_buy(value=value, force=TRUE);
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_transfer_failed{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: anyone
    // Wants to buy 2 NFTs
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current NFT totalSupply: 5
    // current NFT reserved supply: 0
    // has enough funds: NO
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
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 2;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: transfer failed") %}
    CarbonableMinter.public_buy(value=value, force=FALSE);
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_mint_not_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    // User: anyone
    // Wants to buy 2 NFTs
    // Whitelisted sale: CLOSED
    // Public sale: CLOSED
    // current NFT totalSupply: 5
    // current NFT reserved supply: 0
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=0,
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 2;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: public sale is not open") %}
    CarbonableMinter.public_buy(value=value, force=FALSE);
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_zero_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // User: anyone
    // Wants to buy 0 NFTs
    // Whitelisted sale: CLOSED
    // Public sale: OPEN
    // current NFT totalSupply: 5
    // current NFT reserved supply: 0
    // has enough funds: YES
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
    %{ stop=start_prank(context.signers.anyone) %}
    let value = 0;
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: value must be non-negative") %}
    CarbonableMinter.public_buy(value=value, force=FALSE);
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_not_boolean{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
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
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: force must be either 0 or 1") %}
    CarbonableMinter.public_buy(value=1, force=-1);

    return ();
}
