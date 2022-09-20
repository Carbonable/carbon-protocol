// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.yield.library import YieldManager

//
// Structs
//

struct Signers {
    admin: felt,
    anyone: felt,
}

struct Mocks {
    carbonable_project_address: felt,
    carbonable_token_address: felt,
    reward_token_address: felt,
}

struct TestContext {
    signers: Signers,
    mocks: Mocks,
}

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/units/yielder/config.yml", context)
    %}

    return ();
}

func prepare{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    test_context: TestContext
) {
    alloc_locals;

    // Extract context variables
    local admin;
    local anyone;
    local carbonable_project_address;
    local carbonable_token_address;
    local reward_token_address;
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.carbonable_token_address = context.mocks.carbonable_token_address
        ids.reward_token_address = context.mocks.reward_token_address
    %}

    // Instantiate yielder
    YieldManager.constructor(
        owner=admin,
        carbonable_project_address=carbonable_project_address,
        carbonable_token_address=carbonable_token_address,
        reward_token_address=reward_token_address,
    );

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local mocks: Mocks = Mocks(
        carbonable_project_address=carbonable_project_address,
        carbonable_token_address=carbonable_token_address,
        reward_token_address=reward_token_address,
        );

    local context: TestContext = TestContext(signers=signers, mocks=mocks);
    return (test_context=context);
}
