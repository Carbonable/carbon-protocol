// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from utils.initializer.library import CarbonableInitializer

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let name = 'initializer';
    CarbonableInitializer.initialize(name=name);
    CarbonableInitializer.assert_initialized(name=name);

    return ();
}

@external
func test_initialization_revert_not_initialized{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let name = 'name';
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableInitializer: not initialized") %}
    CarbonableInitializer.assert_initialized(name=name);

    return ();
}

@external
func test_initialization_revert_other_not_initialized{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let name = 'name';
    let other = 'other';
    CarbonableInitializer.initialize(name=name);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableInitializer: not initialized") %}
    CarbonableInitializer.assert_initialized(name=other);

    return ();
}
