# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_minter.cairo)

%lang starknet

from starkware.cairo.common.alloc import alloc
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

const MERKLE_ROOT = 3236969588476960619958150604131083087415975923122021901088942336874683133579
const PROOF = 1489335374474017495857579265074565262713421005832572026644103123081435719307

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

    member whitelist_merkle_root : felt
    member public_sale_open : felt
    member max_buy_per_tx : felt
    member unit_price : Uint256
    member max_supply_for_mint : Uint256
    member reserved_supply_for_mint : Uint256
end

@external
func test_buy_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
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
    let (success) = CarbonableMinter.public_buy(quantity)
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
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
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
    CarbonableMinter.public_buy(quantity)
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
    let reserved_supply = Uint256(9, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
    )

    # User: anyone_1
    # Wants to buy 2 NFTs
    # Whitelisted sale: CLOSED
    # Public sale: OPEN
    # current NFT totalSupply: 0
    # current NFT reserved supply: 9
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let quantity = 2
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [0, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.public_buy(quantity)
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
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
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
    CarbonableMinter.public_buy(quantity)
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
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        0, FALSE, 5, unit_price, max_supply, reserved_supply
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
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: public sale is not open") %}
    CarbonableMinter.public_buy(quantity)
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
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        MERKLE_ROOT, FALSE, 5, unit_price, max_supply, reserved_supply
    )
    let (local proof : felt*) = alloc()
    assert [proof] = 1

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
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: caller address is not whitelisted") %}
    CarbonableMinter.whitelist_buy(slots=5, proof_len=1, proof=proof, quantity=quantity)
    %{ stop() %}
    return ()
end

@external
func test_set_whitelist_merkle_root_nominal_case{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        MERKLE_ROOT, FALSE, 5, unit_price, max_supply, reserved_supply
    )
    let (local proof : felt*) = alloc()
    assert [proof] = PROOF

    %{ stop=start_prank(ids.context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist_merkle_root)
    let (slots) = CarbonableMinter.whitelisted_slots(
        account=context.signers.anyone_1, slots=5, proof_len=1, proof=proof
    )
    assert slots = 5
    %{ stop() %}
    return ()
end

@external
func test_set_merkle_tree_revert_if_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        MERKLE_ROOT, FALSE, 5, unit_price, max_supply, reserved_supply
    )
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.set_whitelist_merkle_root(123)
    %{ stop() %}
    return ()
end

@external
func test_buy_user_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        MERKLE_ROOT, FALSE, 5, unit_price, max_supply, reserved_supply
    )
    let (local proof : felt*) = alloc()
    assert [proof] = PROOF

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
    let (success) = CarbonableMinter.whitelist_buy(
        slots=5, proof_len=1, proof=proof, quantity=quantity
    )
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
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        MERKLE_ROOT, FALSE, 5, unit_price, max_supply, reserved_supply
    )
    let (local proof : felt*) = alloc()
    assert [proof] = PROOF

    # User: anyone_1
    # Wants to buy 6 NFTs
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # Is user whitelisted: YES (but not enough slots)
    # current NFT totalSupply: 5
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [3, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough whitelisted slots available") %}
    CarbonableMinter.whitelist_buy(slots=5, proof_len=1, proof=proof, quantity=6)
    %{ stop() %}
    return ()
end

@external
func test_buy_user_whitelisted_but_not_enough_slots_after_claim{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        MERKLE_ROOT, FALSE, 5, unit_price, max_supply, reserved_supply
    )
    let (local proof : felt*) = alloc()
    assert [proof] = PROOF

    # User: anyone_1
    # Wants to buy 5 NFTs and then 1 NFT
    # Whitelisted sale: OPEN
    # Public sale: CLOSED
    # Is user whitelisted: YES (but not enough slots for second buy)
    # current NFT totalSupply: 3
    # current NFT reserved supply: 0
    # has enough funds: YES
    %{ stop=start_prank(ids.context.signers.anyone_1) %}

    # Mock
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [3, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ mock_call(ids.context.mocks.project_nft_address, "mint", []) %}

    # First buy
    # Call whitelist_buy
    CarbonableMinter.whitelist_buy(slots=5, proof_len=1, proof=proof, quantity=5)

    # Expect error
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough whitelisted slots available") %}

    # Second buy
    # Call whitelist_buy
    CarbonableMinter.whitelist_buy(slots=5, proof_len=1, proof=proof, quantity=1)
    %{ stop() %}
    return ()
end

@external
func test_airdrop_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(5, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, FALSE, 5, unit_price, max_supply, reserved_supply
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
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, FALSE, 5, unit_price, max_supply, reserved_supply
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
    let reserved_supply = Uint256(1, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
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
    %{ mock_call(ids.context.mocks.project_nft_address, "totalSupply", [6, 0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=quantity)
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved NFTs") %}
    CarbonableMinter.airdrop(to=context.signers.anyone_1, quantity=1)
    %{ stop() %}
    return ()
end

@external
func test_withdraw_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
    )

    # User: admin
    # Withdraw contract balance
    %{ stop=start_prank(ids.context.signers.admin) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "balanceOf", [5, 0]) %}
    %{ mock_call(ids.context.mocks.payment_token_address, "transfer", [1]) %}
    let (success) = CarbonableMinter.withdraw()
    assert success = TRUE
    %{ stop() %}
    return ()
end

@external
func test_withdraw_revert_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals
    let unit_price = Uint256(10, 0)
    let max_supply = Uint256(10, 0)
    let reserved_supply = Uint256(0, 0)
    let (local context : TestContext) = test_internal.prepare(
        1, TRUE, 5, unit_price, max_supply, reserved_supply
    )

    # User: anyone_1
    # Withdraw contract balance
    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.withdraw()
    %{ stop() %}
    return ()
end

namespace test_internal:
    func prepare{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        whitelist_merkle_root : felt,
        public_sale_open : felt,
        max_buy_per_tx : felt,
        unit_price : Uint256,
        max_supply_for_mint : Uint256,
        reserved_supply_for_mint : Uint256,
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
            whitelist_merkle_root=whitelist_merkle_root,
            public_sale_open=public_sale_open,
            max_buy_per_tx=max_buy_per_tx,
            unit_price=unit_price,
            max_supply_for_mint=max_supply_for_mint,
            reserved_supply_for_mint=reserved_supply_for_mint,
            )

        CarbonableMinter.constructor(
            signers.admin,
            mocks.project_nft_address,
            mocks.payment_token_address,
            context.public_sale_open,
            context.max_buy_per_tx,
            context.unit_price,
            context.max_supply_for_mint,
            context.reserved_supply_for_mint,
        )

        # Admin adds whitelist_merkle_root including anyone_1 with 5 slots
        %{ stop=start_prank(ids.context.signers.admin) %}
        CarbonableMinter.set_whitelist_merkle_root(context.whitelist_merkle_root)
        %{ stop() %}

        return (test_context=context)
    end
end
