// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
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

struct Absorption {
    times_len: felt,
    times: felt*,
    values_len: felt,
    values: felt*,
}

struct TestContext {
    signers: Signers,
    mocks: Mocks,
    absorption: Absorption,
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
    local times_len;
    let (local times: felt*) = alloc();
    local absorptions_len;
    let (local absorptions: felt*) = alloc();
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.times_len = len(context.absorption.times)
        for idx, time in enumerate(context.absorption.times):
            memory[ids.times + idx] = time
        ids.absorptions_len = len(context.absorption.values)
        for idx, absorption in enumerate(context.absorption.values):
            memory[ids.absorptions + idx] = absorption
    %}

    // Instantiate farmer
    CarbonableOffseter.initializer(
        carbonable_project_address=carbonable_project_address,
        times_len=times_len,
        times=times,
        absorptions_len=absorptions_len,
        absorptions=absorptions,
    );

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local mocks: Mocks = Mocks(
        carbonable_project_address=carbonable_project_address,
        );

    local absorption: Absorption = Absorption(
        times_len=times_len,
        times=times,
        values_len=absorptions_len,
        values=absorptions,
        );

    local context: TestContext = TestContext(signers=signers, mocks=mocks, absorption=absorption);
    return (test_context=context);
}
