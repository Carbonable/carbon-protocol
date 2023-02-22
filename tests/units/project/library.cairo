// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.project.library import CarbonableProject

//
// Structs
//

struct Signers {
    admin: felt,
    anyone: felt,
}

struct Absorption {
    slot: Uint256,
    times_len: felt,
    times: felt*,
    values_len: felt,
    values: felt*,
    ton_equivalent: felt,
}

struct TestContext {
    signers: Signers,
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
        load("./tests/units/project/config.yml", context)
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
    local slot;
    local times_len;
    let (local times: felt*) = alloc();
    local absorptions_len;
    let (local absorptions: felt*) = alloc();
    local ton_equivalent;
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.slot = context.absorption.slot
        ids.times_len = len(context.absorption.times)
        ids.absorptions_len = len(context.absorption.values)
        for idx, absorption in enumerate(context.absorption.values):
            memory[ids.absorptions + idx] = absorption
        for idx, time in enumerate(context.absorption.times):
            memory[ids.times + idx] = time
        ids.ton_equivalent = context.absorption.ton_equivalent
    %}
    CarbonableProject.set_absorptions(
        slot=Uint256(low=slot, high=0),
        times_len=times_len,
        times=times,
        absorptions_len=absorptions_len,
        absorptions=absorptions,
        ton_equivalent=ton_equivalent,
    );

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local absorption: Absorption = Absorption(
        slot=Uint256(low=slot, high=0),
        times_len=times_len,
        times=times,
        values_len=absorptions_len,
        values=absorptions,
        ton_equivalent=ton_equivalent,
    );

    local context: TestContext = TestContext(signers=signers, absorption=absorption);
    return (test_context=context);
}
