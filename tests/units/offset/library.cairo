// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.offset.library import CarbonableOffseter

//
// Structs
//

struct Signers {
    admin: felt,
    anyone: felt,
}

struct Mocks {
    carbonable_project_address: felt,
}

struct Claim {
    minimum: felt,
}

struct TestContext {
    signers: Signers,
    mocks: Mocks,
    claim: Claim,
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
        load("./tests/units/offset/config.yml", context)
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
    local carbonable_minter_address;
    local minimum;
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.minimum = context.claim.minimum
    %}

    // Instantiate farmer
    CarbonableOffseter.initializer(carbonable_project_address=carbonable_project_address);
    CarbonableOffseter.set_min_claimable(minimum);

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local mocks: Mocks = Mocks(carbonable_project_address=carbonable_project_address);
    local claim: Claim = Claim(minimum=minimum);

    local context: TestContext = TestContext(signers=signers, mocks=mocks, claim=claim);
    return (test_context=context);
}
