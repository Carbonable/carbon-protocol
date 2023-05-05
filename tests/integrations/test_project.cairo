// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

// Local dependencies
from tests.integrations.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
    carbonable_project_instance as project,
)

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@view
func test_metadata_nominal_case{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let slot = 1;

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=anyone_address, token_id=1, slot=slot, value=100);
    admin.revoke_minter(slot=slot, minter=admin_address);

    // Get implementation class hash
    let (implementation) = project.get_metadata_implementation();
    assert_not_zero(implementation);

    // Get contract metadata
    let (uri_len, uri) = project.contract_uri();
    %{
        uri_data = [memory[ids.uri + i] for i in range(ids.uri_len)]
        assert uri_data == [int.from_bytes(b"Contract: mock contractURI", 'big')]
    %}

    // Get slot implementation class hash
    let (implementation) = project.get_slot_metadata_implementation(1);
    assert_not_zero(implementation);

    // Get contract metadata
    let (uri_len, uri) = project.slot_uri(slot=1);
    %{
        uri_data = [memory[ids.uri + i] for i in range(ids.uri_len)]
        assert uri_data == [int.from_bytes(b"Contract: mock slotURI", 'big')]
    %}

    let (uri_len, uri) = project.token_uri(token_id=1);
    %{
        uri_data = [memory[ids.uri + i] for i in range(ids.uri_len)]
        assert uri_data == [int.from_bytes(b"Contract: mock tokenURI", 'big')]
    %}

    return ();
}
