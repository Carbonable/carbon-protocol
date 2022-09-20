// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.integrations.yield.library import setup

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Given a deployed user contracts
    // And an admin with address 1000
    // And an anyone with address 1001
    // Given a deployed project contact
    // And owned by admin
    // Given a deployed reward token contact
    // And owned by admin
    // And a total supply set to 1,000,000
    // And anyone owns the whole supply
    // Given a deployed carbonable token contact
    // And owned by admin
    // And a total supply set to 1,000,000
    // And anyone owns the whole supply
    // Given a deployed yielder contract
    // And owned by admin
    return setup();
}

@view
func test_e2e{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When

    return ();
}
