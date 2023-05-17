// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero

// Local dependencies
from src.interfaces.badgeMinter import ICarbonableBadgeMinter
from src.interfaces.badge import ICarbonableBadge
from tests.integrations.badge.minter.library import setup

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_transferBadgeContractOwnership{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_contract_address: felt;
    local badge_contract_address: felt;
    local minter_contract_owner: felt;
    local anyone: felt;
    %{
        ids.minter_contract_address = context.badge_minter.contract_address
        ids.badge_contract_address = context.badge.contract_address
        ids.minter_contract_owner = context.admin_account_contract
        ids.anyone = context.anyone_account_contract
    %}

    // Transfer ownership of the badge contract from the minter contract to a random user
    %{ stop_prank_callable = start_prank(ids.minter_contract_owner, target_contract_address=ids.minter_contract_address) %}
    ICarbonableBadgeMinter.transferBadgeContractOwnership(minter_contract_address, anyone);
    %{ stop_prank_callable() %}

    let (contract_owner) = ICarbonableBadge.owner(badge_contract_address);
    assert contract_owner = anyone;

    return ();
}

@external
func test_transferBadgeContractOwnership_from_non_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}() {
    alloc_locals;

    // Extract context variables
    local minter_contract_address: felt;
    local badge_contract_address: felt;
    local minter_contract_owner: felt;
    local anyone: felt;
    %{
        ids.minter_contract_address = context.badge_minter.contract_address
        ids.badge_contract_address = context.badge.contract_address
        ids.minter_contract_owner = context.admin_account_contract
        ids.anyone = context.anyone_account_contract
    %}

    // Transfer ownership of the badge contract from the minter contract to a random user as a random user
    %{ stop_prank_callable = start_prank(context.anyone_account_contract, target_contract_address=ids.minter_contract_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    ICarbonableBadgeMinter.transferBadgeContractOwnership(minter_contract_address, anyone);
    %{ stop_prank_callable() %}

    return ();
}
