// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

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
    start_time: felt,
    time_step: felt,
    values_len: felt,
    values: felt*,
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
    local start_time;
    local time_step;
    local absorptions_len;
    let (local absorptions: felt*) = alloc();
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.start_time = context.absorption.start_time
        ids.time_step = context.absorption.time_step
        ids.absorptions_len = len(context.absorption.values)
        for idx, absorption in enumerate(context.absorption.values):
            memory[ids.absorptions + idx] = absorption
    %}
    CarbonableProject.set_time(start_time=start_time, time_step=time_step);
    CarbonableProject.set_absorptions(absorptions_len=absorptions_len, absorptions=absorptions);

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local absorption: Absorption = Absorption(
        start_time=start_time, time_step=time_step, values_len=absorptions_len, values=absorptions
    );

    local context: TestContext = TestContext(signers=signers, absorption=absorption);
    return (test_context=context);
}
