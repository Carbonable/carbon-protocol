# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

# Local dependencies
from src.project.library import CarbonableProject

#
# Structs
#

struct Signers:
    member admin : felt
    member anyone : felt
end

struct TestContext:
    member signers : Signers
end

#
# Functions
#

func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/units/project/config.yml", context)
    %}

    return ()
end

func prepare{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    test_context : TestContext
):
    alloc_locals

    # Extract context variables
    local admin
    local anyone
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
    %}

    # Instantiate context, useful to avoid many hints in tests
    local signers : Signers = Signers(admin=admin, anyone=anyone)

    local context : TestContext = TestContext(signers=signers)
    return (test_context=context)
end
