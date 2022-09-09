# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

# Project dependencies
from openzeppelin.security.safemath.library import SafeUint256

# Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_buy_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: anyone
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [5, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mint", []) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    let (success) = CarbonableMinter.public_buy(2)
    assert success = TRUE
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_not_enough_nfts_available{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    # User: anyone
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 10
    # current NFT reserved supply: 0
    # has enough funds: YES
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let quantity = 2
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [10, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.public_buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_not_enough_free_nfts{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    # User: anyone
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 0
    # current NFT reserved supply: 9
    # has enough funds: YES
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(9, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let quantity = 2
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [0, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.public_buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_transfer_failed{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    # User: anyone
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: NO
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let quantity = 2
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: transfer failed") %}
    CarbonableMinter.public_buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_mint_not_open{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    # User: anyone
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: CLOSED
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let quantity = 2
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: public sale is not open") %}
    CarbonableMinter.public_buy(quantity)
    %{ stop() %}
    return ()
end
