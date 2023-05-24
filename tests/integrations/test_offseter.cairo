// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
    carbonable_offseter_instance as offseter,
    carbonable_project_instance as project,
)

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@view
func test_nominal_single_user_case{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();
    let (project_address) = project.get_address();
    let slot = 1;

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=anyone_address, token_id=1, slot=slot, value=100);
    admin.revoke_minter(slot=slot, minter=admin_address);

    // Set project value to total minted value
    let (project_value) = project.total_value(slot=slot);
    admin.set_project_value(slot=slot, project_value=project_value);

    // Set project value to total minted value
    let (project_value) = project.total_value(slot=slot);
    admin.set_project_value(slot=slot, project_value=project_value);

    // At t = 0
    %{ stop_warp_offseter = warp(blk_timestamp=0, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=0, target_contract_address=ids.project_address) %}

    // Anyone deposits token #1
    anyone.set_approval_for_slot(slot=slot, operator=offseter_address);
    anyone.offseter_deposit(token_id=1, value=100);

    // Claimable is 0
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 0;

    // Claimed is 0
    let (claimed) = offseter.get_claimed_of(address=anyone_address);
    assert claimed = 0;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1659312000
    %{ stop_warp_offseter = warp(blk_timestamp=1659312000, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1659312000, target_contract_address=ids.project_address) %}

    // Claimable is 1179750
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 1179750;

    // Claimed is 0
    let (claimed) = offseter.get_claimed_of(address=anyone_address);
    assert claimed = 0;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1667260800
    %{ stop_warp_offseter = warp(blk_timestamp=1667260800, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1667260800, target_contract_address=ids.project_address) %}

    // Anyone claims
    %{ expect_events({"name": "Claim"}) %}
    anyone.claim_all();

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1675209600
    %{ stop_warp_offseter = warp(blk_timestamp=1675209600, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1675209600, target_contract_address=ids.project_address) %}

    // Claimable is 1179750
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 1179750;

    // Claimed is 1179750
    let (claimed) = offseter.get_claimed_of(address=anyone_address);
    assert claimed = 2359500;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1682899200
    %{ stop_warp_offseter = warp(blk_timestamp=1682899200, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address) %}

    // Anyone wtihdraws token #1
    anyone.offseter_withdraw_to(value=100);

    // Total absorption
    let (absorption) = project.get_current_absorption(slot=slot);
    assert absorption = 4719000;

    // Claimable is 2359500
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 2359500;

    // Claimed is 2359500
    let (claimed) = offseter.get_claimed_of(address=anyone_address);
    assert claimed = 2359500;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1690848000
    %{ stop_warp_offseter = warp(blk_timestamp=1690848000, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1690848000, target_contract_address=ids.project_address) %}

    // Claimable is 2359500
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 2359500;

    // Claimed is 1179750
    let (claimed) = offseter.get_claimed_of(address=anyone_address);
    assert claimed = 2359500;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    return ();
}

@view
func test_nominal_multi_user_case{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();
    let (project_address) = project.get_address();
    let slot = 1;

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=admin_address, token_id=1, slot=slot, value=100);
    admin.mint(to=admin_address, token_id=2, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=3, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=4, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=5, slot=slot, value=100);
    admin.revoke_minter(slot=slot, minter=admin_address);

    // Set project value to total minted value
    let (project_value) = project.total_value(slot=slot);
    admin.set_project_value(slot=slot, project_value=project_value);

    // At t = 0
    %{ stop_warp_offseter = warp(blk_timestamp=0, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=0, target_contract_address=ids.project_address) %}

    // Admin deposits tokens #1, #2
    // Anyone deposits tokens #3, #4, #5
    admin.set_approval_for_slot(slot=slot, operator=offseter_address);
    anyone.set_approval_for_slot(slot=slot, operator=offseter_address);
    admin.offseter_deposit(token_id=1, value=100);
    admin.offseter_deposit(token_id=2, value=100);
    anyone.offseter_deposit(token_id=3, value=100);
    anyone.offseter_deposit(token_id=4, value=100);
    anyone.offseter_deposit(token_id=5, value=100);

    // Claimable is 0
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 0;

    // Claimed is 0
    let (claimed) = offseter.get_claimed_of(address=anyone_address);
    assert claimed = 0;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1659312000
    %{ stop_warp_offseter = warp(blk_timestamp=1659312000, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1659312000, target_contract_address=ids.project_address) %}

    // Total claimable is 471900 + 707850 = 1179750
    let (total_claimable) = offseter.get_total_claimable();
    assert total_claimable = 1179750;

    // Admin claimable is 1179750 * 2 / 5 = 471900
    let (claimable) = offseter.get_claimable_of(address=admin_address);
    assert claimable = 471900;

    // Anyone claimable is 1179750 * 3 / 5 = 707850
    let (claimable) = offseter.get_claimable_of(address=anyone_address);
    assert claimable = 707850;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    return ();
}
