# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Local dependencies
from src.badge.library import CarbonableBadge

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
        load("./tests/units/badge/config.yml", context)
    %}

    return ()
end

func prepare{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(uri_len : felt, uri : felt*, name : felt) -> (test_context : TestContext):
    alloc_locals

    # Extract context variables
    local admin
    local anyone
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
    %}

    CarbonableBadge.initializer(uri_len, uri, name)

    local signers : Signers = Signers(admin=admin, anyone=anyone)
    local context : TestContext = TestContext(signers=signers)
    return (test_context=context)
end
