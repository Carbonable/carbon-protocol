// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.offset.library import CarbonableOffseter
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
    carbonable_offseter_address: felt,
    carbonable_vester_address: felt,
}

struct Yield {
    slot: felt,
}

struct TestContext {
    signers: Signers,
    mocks: Mocks,
    yield: Yield,
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
    local carbonable_offseter_address;
    local carbonable_vester_address;
    local slot;
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.carbonable_offseter_address = context.mocks.carbonable_offseter_address
        ids.carbonable_vester_address = context.mocks.carbonable_vester_address
        ids.slot = context.yielder.slot
    %}
    // Instantiate offset farmer
    CarbonableOffseter.initializer(
        carbonable_project_address=carbonable_project_address,
        carbonable_project_slot=Uint256(low=slot, high=0),
    );

    // Instantiate yield farmer
    CarbonableYielder.initializer(
        carbonable_offseter_address=carbonable_offseter_address,
        carbonable_vester_address=carbonable_vester_address,
    );

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local mocks: Mocks = Mocks(
        carbonable_project_address=carbonable_project_address,
        carbonable_offseter_address=carbonable_offseter_address,
        carbonable_vester_address=carbonable_vester_address,
    );
    local yield: Yield = Yield(slot=slot);

    local context: TestContext = TestContext(signers=signers, mocks=mocks, yield=yield);
    return (test_context=context);
}
