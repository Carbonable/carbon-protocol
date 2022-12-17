// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

// Local dependencies
from src.interfaces.badgeMinter import ICarbonableBadgeMinter
from src.interfaces.badge import ICarbonableBadge

@external
func test_transferBadgeContractOwnership{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;

    local minter_contract_address: felt;
    local logic_class: felt;
    let public_key = 0x07c42ac1a6415ba91ce25cca6ea3ffcf8201151a722e6a07fe2f73e931f221c6;
    let initial_badge_contract_owner = 0x1;
    let minter_contract_owner = 0x6;

    // Deploy the minter contract
    %{
        from starkware.starknet.compiler.compile import get_selector_from_name
        ids.logic_class = declare("src/badge/minter.cairo").class_hash
        ids.minter_contract_address = deploy_contract("openzeppelin/upgrades/presets/Proxy.cairo", [ids.logic_class, get_selector_from_name("initializer"), 3, ids.minter_contract_owner, ids.public_key, 0]).contract_address
    %}

    local badge_contract_address: felt;
    // Deploy the badge contract
    %{
        ids.badge_contract_address = deploy_contract("src/badge/badge.cairo", [1, 1, 1, ids.initial_badge_contract_owner]).contract_address
    %}

    // Set the badge contract address in the minter contract
    %{ stop_prank_callable = start_prank(ids.minter_contract_owner, target_contract_address=ids.minter_contract_address) %}
        ICarbonableBadgeMinter.setBadgeContractAddress(minter_contract_address, badge_contract_address);
    %{ stop_prank_callable() %}

    // Transfer ownership of the badge contract to the minter contract
    %{ stop_prank_callable = start_prank(ids.initial_badge_contract_owner, target_contract_address=ids.badge_contract_address) %}
        ICarbonableBadge.transferOwnership(badge_contract_address, minter_contract_address);
        let (contract_owner,) = ICarbonableBadge.owner(badge_contract_address);
        assert contract_owner = minter_contract_address;
    %{ stop_prank_callable() %}

    // Transfer back ownership of the badge contract to the initial owner
    %{ stop_prank_callable = start_prank(ids.minter_contract_owner, target_contract_address=ids.minter_contract_address) %}
        ICarbonableBadgeMinter.transferBadgeContractOwnership(minter_contract_address, initial_badge_contract_owner);
        let (contract_owner,) = ICarbonableBadge.owner(badge_contract_address);
        assert contract_owner = initial_badge_contract_owner;
    %{ stop_prank_callable() %}

    return ();
}