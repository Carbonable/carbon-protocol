# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_minter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_airdrop_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: admin
    # Wants to aidrop 5 NFTs
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # current NFT totalSupply: 5
    # current NFT reserved supply: 5
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(5, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [5, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mint", []) %}
    CarbonableMinter.airdrop(to=context.signers.anyone, quantity=5)
    %{ stop() %}
    return ()
end

@external
func test_airdrop_revert_if_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
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
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.airdrop(to=context.signers.anyone, quantity=1)
    %{ stop() %}
    return ()
end

@external
func test_airdrop_revert_not_enough_nfts_available{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    # User: admin
    # Wants to airdrop 5 NFTs then 1 NFT then 1 NFT
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 6
    # current NFT reserved supply: 1
    # has enough funds: YES
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=TRUE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(1, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [6, 0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.airdrop(to=context.signers.anyone, quantity=5)
    CarbonableMinter.airdrop(to=context.signers.anyone, quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved NFTs") %}
    CarbonableMinter.airdrop(to=context.signers.anyone, quantity=1)
    %{ stop() %}
    return ()
end
