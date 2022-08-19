# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_yield_manager.cairo)

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

from src.yield.library import YieldManager

const PROJECT_NFT_ADDRESS = 0x056d4ffea4ca664ffe1256af4b029998014471a87dec8036747a927ab3320b46
const reward_token_address = 0x073314940630fd6dcda0d772d4c972c4e0a9946bef9dabf4ef84eda8ef542b82
const CARBONABLE_TOKEN_ADDRESS = 0x043eB0d3D84CC1f850D4b6dEe9630cAc35Af99980BAA30577A76adEa72475598

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
    member reward_token_address : felt
    member project_nft_address : felt
    member carbonable_token_address : felt
end

struct TestContext:
    member signers : Signers
    member mocks : Mocks
end

@external
func test_initialization{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let (local context : TestContext) = test_internal.prepare()

    %{ stop=start_prank(ids.context.signers.anyone_1) %}
    let (reward_token_address) = YieldManager.reward_token_address()
    assert reward_token_address = context.mocks.reward_token_address
    let (project_nft_address) = YieldManager.project_nft_address()
    assert project_nft_address = context.mocks.project_nft_address
    let (carbonable_token_address) = YieldManager.carbonable_token_address()
    assert carbonable_token_address = context.mocks.carbonable_token_address
    %{ stop() %}
    return ()
end

namespace test_internal:
    func prepare{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        test_context : TestContext
    ):
        alloc_locals
        local signers : Signers = Signers(admin=ADMIN, anyone_1=ANYONE_1, anyone_2=ANYONE_2, anyone_3=ANYONE_3)

        local mocks : Mocks = Mocks(
            reward_token_address=reward_token_address,
            project_nft_address=PROJECT_NFT_ADDRESS,
            carbonable_token_address=CARBONABLE_TOKEN_ADDRESS,
            )

        local context : TestContext = TestContext(
            signers=signers,
            mocks=mocks,
            )

        YieldManager.constructor(
            signers.admin,
            mocks.project_nft_address,
            mocks.carbonable_token_address,
            mocks.reward_token_address,
        )
        return (test_context=context)
    end
end
