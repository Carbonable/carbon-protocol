// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.farming.library import CarbonableFarming
from src.yield.library import CarbonableYielder

//
// Structs
//

struct Signers {
    admin: felt,
    anyone: felt,
}

struct Mocks {
    carbonable_project_address: felt,
    carbonable_project_slot: felt,
    payment_token_address: felt,
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
        load("./tests/units/yield/config.yml", context)
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
    local carbonable_project_slot;
    local payment_token_address;
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.carbonable_project_slot = context.mocks.carbonable_project_slot
        ids.payment_token_address = context.mocks.payment_token_address
    %}
    // Instantiate offset farmer
    CarbonableFarming.initializer(
        carbonable_project_address=carbonable_project_address,
        carbonable_project_slot=Uint256(low=carbonable_project_slot, high=0),
    );

    // Instantiate yield farmer
    CarbonableYielder.initializer(payment_token_address=payment_token_address);

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local mocks: Mocks = Mocks(
        carbonable_project_address=carbonable_project_address,
        carbonable_project_slot=carbonable_project_slot,
        payment_token_address=payment_token_address,
    );

    local context: TestContext = TestContext(signers=signers, mocks=mocks);
    return (test_context=context);
}
