# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

# Project dependencies
from src.yield.library import YieldManager

# Structs
struct Signers:
    member admin : felt
    member anyone : felt
end

struct Mocks:
    member project_nft_address : felt
    member carbonable_token_address : felt
    member reward_token_address : felt
end

struct TestContext:
    member signers : Signers
    member mocks : Mocks
end

# Functions
func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/units/yielder/config.yml", context)
    %}

    return ()
end

func prepare{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    test_context : TestContext
):
    alloc_locals

    # Extract context variables
    local admin
    local anyone
    local project_nft_address
    local carbonable_token_address
    local reward_token_address
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.project_nft_address = context.mocks.project_nft_address
        ids.carbonable_token_address = context.mocks.carbonable_token_address
        ids.reward_token_address = context.mocks.reward_token_address
    %}

    # Instantiate yielder
    YieldManager.constructor(
        owner=admin,
        project_nft_address=project_nft_address,
        carbonable_token_address=carbonable_token_address,
        reward_token_address=reward_token_address,
    )

    # Instantiate context, useful to avoid many hints in tests
    local signers : Signers = Signers(admin=admin, anyone=anyone)

    local mocks : Mocks = Mocks(
        project_nft_address=project_nft_address,
        carbonable_token_address=carbonable_token_address,
        reward_token_address=reward_token_address,
        )

    local context : TestContext = TestContext(signers=signers, mocks=mocks)
    return (test_context=context)
end
