// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (library.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Project dependencies
from openzeppelin.access.ownable.library import Ownable

// Local dependencies
from src.project.library import CarbonableProject

//
// Structs
//

struct Signers {
    admin: felt,
    anyone: felt,
}

struct TestContext {
    signers: Signers,
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
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
    %}
    Ownable.initializer(admin);

    // Instantiate context, useful to avoid many hints in tests
    local signers: Signers = Signers(admin=admin, anyone=anyone);

    local context: TestContext = TestContext(signers=signers);
    return (test_context=context);
}
