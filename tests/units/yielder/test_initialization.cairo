# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_yielder.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

from tests.units.yielder.library import setup, prepare, YieldManager

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_initialization{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    # prepare yielder instance
    let (local context) = prepare()

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    let (project_nft_address) = YieldManager.project_nft_address()
    assert project_nft_address = context.mocks.project_nft_address

    let (carbonable_token_address) = YieldManager.carbonable_token_address()
    assert carbonable_token_address = context.mocks.carbonable_token_address

    let (reward_token_address) = YieldManager.reward_token_address()
    assert reward_token_address = context.mocks.reward_token_address
    %{ stop() %}

    return ()
end
