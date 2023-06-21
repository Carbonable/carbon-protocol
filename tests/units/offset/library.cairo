// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.farming.library import CarbonableFarming
from src.offset.library import CarbonableOffseter

//
// Structs
//

struct Signers {
    admin: felt,
    anyone: felt,
    someone: felt,
}

struct Mocks {
    carbonable_project_address: felt,
    carbonable_project_slot: felt,
}

struct Offset {
    minimum: felt,
}

struct TestContext {
    signers: Signers,
    mocks: Mocks,
    offset: Offset,
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
    local someone;
    local carbonable_project_address;
    local carbonable_project_slot;
    local minimum;
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.someone = context.signers.someone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.carbonable_project_slot = context.mocks.carbonable_project_slot
        ids.minimum = context.offseter.minimum
    %}

    // Instantiate farmer
    CarbonableFarming.initializer(
        carbonable_project_address=carbonable_project_address,
        carbonable_project_slot=Uint256(low=carbonable_project_slot, high=0),
    );
    CarbonableOffseter.set_min_claimable(minimum);

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone, someone=someone);

    local mocks: Mocks = Mocks(
        carbonable_project_address=carbonable_project_address,
        carbonable_project_slot=carbonable_project_slot,
    );
    local offset: Offset = Offset(minimum=minimum);

    local context: TestContext = TestContext(signers=signers, mocks=mocks, offset=offset);
    return (test_context=context);
}
