# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_minter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

from src.mint.library import CarbonableMinter

const PROJECT_NFT_ADDRESS = 0x056d4ffea4ca664ffe1256af4b029998014471a87dec8036747a927ab3320b46
const PAYMENT_TOKEN_ADDRESS = 0x073314940630fd6dcda0d772d4c972c4e0a9946bef9dabf4ef84eda8ef542b82
const ADMIN = 1000
const ANYONE_1 = 1001
const ANYONE_2 = 1002
const ANYONE_3 = 1003

# -------
# STRUCTS
# -------

struct Signers:
    member admin : felt
    member anyone_1 : felt
    member anyone_2 : felt
    member anyone_3 : felt
end

struct Mocks:
    member payment_token_address : felt
    member project_nft_address : felt
end

struct TestContext:
    member signers : Signers
    member mocks : Mocks

    member whitelisted_sale_open : felt
    member public_sale_open : felt
    member max_buy_per_tx : felt
    member unit_price : Uint256
    member max_supply_for_mint : Uint256
end

@external
func test_buy_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        FALSE, TRUE, 5, unit_price, max_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.project_nft_address, "mint", []) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    let (success) = CarbonableMinter.buy(quantity)
    assert success = TRUE
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_not_enough_nfts_available{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        FALSE, TRUE, 5, unit_price, max_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 10
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [10, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_not_enough_free_nfts{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        FALSE, TRUE, 5, unit_price, max_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 0
    # current NFT reserved supply: 9
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.admin) %}
    let reserved_quantity = Uint256(9, 0)
    CarbonableMinter.set_reserved_supply_for_mint(reserved_quantity)
    %{ stop() %}

    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [0, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_transfer_failed{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        FALSE, TRUE, 5, unit_price, max_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: NO
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: transfer failed") %}
    CarbonableMinter.buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_mint_not_open{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        FALSE, FALSE, 5, unit_price, max_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: CLOSED
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: mint is not open") %}
    CarbonableMinter.buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_buy_revert_not_whitelisted{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # Is user whitelisted: NO
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: no whitelisted slot available") %}
    CarbonableMinter.buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_add_to_whitelist_revert_if_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.add_to_whitelist(42, 1)
    %{ stop() %}
    return ()
end

@external
func test_add_to_whitelist_nominal_case{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )
    %{ stop=start_prank(ids.context.signers.admin) %}
    let (success) = CarbonableMinter.add_to_whitelist(42, 33)
    assert success = TRUE
    let (slots) = CarbonableMinter.whitelist(42)
    assert slots = 33
    %{ stop() %}
    return ()
end

@external
func test_buy_user_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )

    # Admin adds anyone_1 to whitelist
    %{ stop=start_prank(ids.context.signers.admin) %}
    CarbonableMinter.add_to_whitelist(context.signers.anyone_1, 2)
    %{ stop() %}

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # Is user whitelisted: YES
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.project_nft_address, "mint", []) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    let (success) = CarbonableMinter.buy(quantity)
    assert success = TRUE
    %{ stop() %}
    return ()
end

@external
func test_buy_user_whitelisted_but_not_enough_slots{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )

    # Admin adds anyone_1 to whitelist
    %{ stop=start_prank(ids.context.signers.admin) %}
    CarbonableMinter.add_to_whitelist(context.signers.anyone_1, 1)
    %{ stop() %}

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # Is user whitelisted: YES (but not enough slots)
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: no whitelisted slot available") %}
    CarbonableMinter.buy(quantity)
    %{ stop() %}
    return ()
end

@external
func test_airdrop_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )

    # User: admin
    # Wants to aidrop 5 NFTs
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # Is user whitelisted: NO
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    %{ stop=start_prank(ids.context.signers.admin) %}
    let quantity = 5
    CarbonableMinter.set_reserved_supply_for_mint(Uint256(quantity, 0))
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.context.mocks.project_nft_address, "mint", []) %}
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=quantity)
    %{ stop() %}
    return ()
end

@external
func test_airdrop_revert_if_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        TRUE, FALSE, 5, unit_price, max_supply
    )
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=1)
    %{ stop() %}
    return ()
end

@external
func test_airdrop_revert_not_enough_nfts_available{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let (local context : TestContext) = test_internal.prepare(
        FALSE, TRUE, 5, unit_price, max_supply
    )

    # User: admin
    # Wants to airdrop 5 NFTs then 1 NFT then 1 NFT
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 6
    # current NFT reserved supply: 1
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.admin) %}
    let quantity = 5
    let reserved_quantity = 1
    CarbonableMinter.set_reserved_supply_for_mint(Uint256(reserved_quantity, 0))
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [6, 0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=quantity)
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved NFTs") %}
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=1)
    %{ stop() %}
    return ()
end

namespace test_internal:
    func prepare{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        whitelisted_sale_open : felt,
        public_sale_open : felt,
        max_buy_per_tx : felt,
        unit_price : Uint256,
        max_supply_for_mint : Uint256,
    ) -> (test_context : TestContext):
        alloc_locals
        local signers : Signers = Signers(admin=ADMIN, anyone_1=ANYONE_1, anyone_2=ANYONE_2, anyone_3=ANYONE_3)

        local mocks : Mocks = Mocks(
            payment_token_address=PAYMENT_TOKEN_ADDRESS,
            project_nft_address=PROJECT_NFT_ADDRESS,
            )

        local context : TestContext = TestContext(
            signers=signers,
            mocks=mocks,
            whitelisted_sale_open=whitelisted_sale_open,
            public_sale_open=public_sale_open,
            max_buy_per_tx=max_buy_per_tx,
            unit_price=unit_price,
            max_supply_for_mint=max_supply_for_mint,
            )

        CarbonableMinter.constructor(
            signers.admin,
            mocks.project_nft_address,
            mocks.payment_token_address,
            context.whitelisted_sale_open,
            context.public_sale_open,
            context.max_buy_per_tx,
            context.unit_price,
            context.max_supply_for_mint,
        )
        return (test_context=context)
    end
end
