// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.interfaces.badgeMinter import ICarbonableBadgeMinter
from src.interfaces.badge import ICarbonableBadge
from tests.integrations.badge.minter.library import setup

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_claim_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_contract_address: felt;
    local badge_contract_address: felt;
    local whitelisted_user: felt;
    local sig0: felt;
    local sig1: felt;
    local badge_type: felt;
    %{ 
        ids.minter_contract_address = context.badge_minter.contract_address
        ids.badge_contract_address = context.badge.contract_address
        ids.whitelisted_user = context.badge_minter.whitelisted_user
        ids.sig0 = context.badge_minter.sig0
        ids.sig1 = context.badge_minter.sig1
        ids.badge_type = context.badge_minter.badge_type
    %}

    // Claim the badge
    %{ stop_prank_callable = start_prank(context.badge_minter.whitelisted_user, target_contract_address=context.badge_minter.contract_address) %}
    // The whitelisted user address must be known before running the test because the signature is checked against it.
    // So, as it cannot be deployed, we need to mock the mint function of the badge contract, because it check the validity of the user contract.
    %{ mock_call(context.badge.contract_address, "mint", []) %}
    ICarbonableBadgeMinter.claim(minter_contract_address, (sig0, sig1), badge_type);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_claim_revert_invalid_user{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local sig0: felt;
    local sig1: felt;
    local badge_type: felt;
    local minter_contract_address: felt;
    local whitelisted_user: felt;
    %{ 
        ids.sig0 = context.badge_minter.sig0
        ids.sig1 = context.badge_minter.sig1
        ids.badge_type = context.badge_minter.badge_type
        ids.minter_contract_address = context.badge_minter.contract_address
        ids.whitelisted_user = context.badge_minter.whitelisted_user
    %}

    let invalid_user = whitelisted_user + 1;

    // Claim badge
    %{ stop_prank_callable = start_prank(ids.invalid_user, target_contract_address=context.badge_minter.contract_address) %}

    // The transaction should fail because the signature is invalid with respect to the public key, the badge type and the user address.
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: invalid signature") %}
    ICarbonableBadgeMinter.claim(minter_contract_address, (sig0, sig1), badge_type);

    %{ stop_prank_callable() %}

    return ();
}

@external
func test_claim_revert_whitelisted_user_but_invalid_badge_type{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_contract_address: felt;
    local badge_contract_address: felt;
    local whitelisted_user: felt;
    local sig0: felt;
    local sig1: felt;
    local badge_type: felt;
    %{ 
        ids.minter_contract_address = context.badge_minter.contract_address
        ids.badge_contract_address = context.badge.contract_address
        ids.whitelisted_user = context.badge_minter.whitelisted_user
        ids.sig0 = context.badge_minter.sig0
        ids.sig1 = context.badge_minter.sig1
        ids.badge_type = context.badge_minter.badge_type
    %}

    // Set badge type to an invalid value
    let badge_type = badge_type + 1;

    // Claim the badge
    %{ 
        stop_prank_callable = start_prank(context.badge_minter.whitelisted_user, target_contract_address=context.badge_minter.contract_address)
        expect_revert("TRANSACTION_FAILED", "CarbonableBadge: invalid signature")
    %}
    ICarbonableBadgeMinter.claim(minter_contract_address, (sig0, sig1), badge_type);
    %{ stop_prank_callable() %}

    return ();
}