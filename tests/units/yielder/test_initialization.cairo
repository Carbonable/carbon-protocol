# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_yielder.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Local dependencies
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
    let (carbonable_project_address) = YieldManager.carbonable_project_address()
    assert carbonable_project_address = context.mocks.carbonable_project_address

    let (carbonable_token_address) = YieldManager.carbonable_token_address()
    assert carbonable_token_address = context.mocks.carbonable_token_address

    let (reward_token_address) = YieldManager.reward_token_address()
    assert reward_token_address = context.mocks.reward_token_address
    %{ stop() %}

    return ()
end
