// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero

// Local dependencies
from src.badge.minter import owner, initializer, getSignerPublicKey, getBadgeContractAddress, getAdmin
from tests.units.badge.minter.library import setup, prepare

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_owner: felt;
    local proxy_admin: felt;
    local carbonable_badge_contract_address: felt;
    local public_key: felt;
    %{ 
        ids.minter_owner = context.mocks.owner
        ids.proxy_admin = context.mocks.proxy_admin
        ids.carbonable_badge_contract_address = context.mocks.carbonable_badge_contract_address
        ids.public_key = context.whitelist.public_key
    %}

    // Prepare minter instance
    prepare(minter_owner, public_key, carbonable_badge_contract_address, proxy_admin);

    // Check initialization
    let (signer_public_key) = getSignerPublicKey();
    assert signer_public_key = public_key;

    let (badge_contract_address) = getBadgeContractAddress();
    assert badge_contract_address = carbonable_badge_contract_address;

    return ();
}