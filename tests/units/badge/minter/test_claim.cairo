// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from tests.units.badge.minter.library import setup, prepare
from src.badge.minter import claim

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_claim_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_owner: felt;
    local proxy_admin: felt;
    local carbonable_badge_contract_address: felt;
    local public_key: felt;
    local sig0: felt;
    local sig1: felt;
    local badge_type: felt;
    %{
        ids.minter_owner = context.mocks.owner
        ids.proxy_admin = context.mocks.proxy_admin
        ids.carbonable_badge_contract_address = context.mocks.carbonable_badge_contract_address
        ids.public_key = context.whitelist.public_key
        ids.sig0 = context.whitelist.sig0
        ids.sig1 = context.whitelist.sig1
        ids.badge_type = context.whitelist.badge_type
    %}

    // Prepare minter instance
    prepare(minter_owner, public_key, carbonable_badge_contract_address, proxy_admin);

    // Claim badge
    %{ stop_prank_callable = start_prank(context.whitelist.whitelisted_user_address) %}
    %{ mock_call(context.mocks.carbonable_badge_contract_address, "mint", []) %}
    // The balance of the user should be 0, else the badge can't be minted.
    %{ mock_call(context.mocks.carbonable_badge_contract_address, "balanceOf", [0, 0]) %}
    claim((sig0, sig1), badge_type);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_claim_revert_invalid_user{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_owner: felt;
    local proxy_admin: felt;
    local carbonable_badge_contract_address: felt;
    local public_key: felt;
    local sig0: felt;
    local sig1: felt;
    local badge_type: felt;
    %{
        ids.minter_owner = context.mocks.owner
        ids.proxy_admin = context.mocks.proxy_admin
        ids.carbonable_badge_contract_address = context.mocks.carbonable_badge_contract_address
        ids.public_key = context.whitelist.public_key
        ids.sig0 = context.whitelist.sig0
        ids.sig1 = context.whitelist.sig1
        ids.badge_type = context.whitelist.badge_type
    %}

    // Prepare minter instance
    prepare(minter_owner, public_key, carbonable_badge_contract_address, proxy_admin);

    // Claim badge
    %{ stop_prank_callable = start_prank(context.mocks.anyone) %}
    // The transaction should fail because the signature is invalid with respect to the public key, the badge type and the user address.
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: invalid signature") %}
    claim((sig0, sig1), badge_type);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_claim_revert_whitelisted_user_but_invalid_badge_type{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_owner: felt;
    local proxy_admin: felt;
    local carbonable_badge_contract_address: felt;
    local public_key: felt;
    local sig0: felt;
    local sig1: felt;
    local badge_type: felt;
    %{
        ids.minter_owner = context.mocks.owner
        ids.proxy_admin = context.mocks.proxy_admin
        ids.carbonable_badge_contract_address = context.mocks.carbonable_badge_contract_address
        ids.public_key = context.whitelist.public_key
        ids.sig0 = context.whitelist.sig0
        ids.sig1 = context.whitelist.sig1
        ids.badge_type = context.whitelist.badge_type
    %}

    // Set badge type to an invalid value
    let badge_type = badge_type + 1;

    // Prepare minter instance
    prepare(minter_owner, public_key, carbonable_badge_contract_address, proxy_admin);

    // Claim badge
    %{ stop_prank_callable = start_prank(context.whitelist.whitelisted_user_address) %}
    // The transaction should fail because the signature is invalid with respect to the public key, the badge type and the user address.
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: invalid signature") %}
    claim((sig0, sig1), badge_type);
    %{ stop_prank_callable() %}

    return ();
}
