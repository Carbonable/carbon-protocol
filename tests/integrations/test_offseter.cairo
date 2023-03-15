// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from tests.integrations.protocol.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
    carbonable_offseter_instance as offseter,
    carbonable_project_instance as project,
)

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Given a deployed user contracts
    // And an admin with address 1000
    // And an anyone with address 1001
    // Given a deployed project contact
    // And owned by admin
    // And with token 1 owned by admin
    // And with token 2 owned by admin
    // And with token 3 owned by anyone
    // And with token 4 owned by anyone
    // And with token 5 owned by anyone
    // Given a deployed farmer contract
    // And owned by admin
    return setup();
}

@view
func test_access_control{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (minters_len, minters) = admin.get_minters();
    assert 1 = minters_len;

    admin.add_minter(123);
    admin.add_minter(456);
    admin.add_minter(789);
    let (minters_len, minters) = admin.get_minters();
    assert 4 = minters_len;
    assert 789 = [minters + 0];
    assert 456 = [minters + 1];
    assert 123 = [minters + 2];

    admin.revoke_minter(456);
    let (minters_len, minters) = admin.get_minters();
    assert 3 = minters_len;
    assert 789 = [minters + 0];
    assert 123 = [minters + 1];

    admin.revoke_minter(123);
    let (minters_len, minters) = admin.get_minters();
    assert 2 = minters_len;
    assert 789 = [minters + 0];

    admin.revoke_minter(789);
    let (minters_len, minters) = admin.get_minters();
    assert 1 = minters_len;

    admin.set_certifier(1234);
    let (certifier) = admin.get_certifier();
    assert 1234 = certifier;

    admin.set_certifier(5678);
    let (certifier) = admin.get_certifier();
    assert 5678 = certifier;

    admin.set_certifier(0);
    let (certifier) = admin.get_certifier();
    assert 0 = certifier;

    return ();
}

@view
func test_nominal_single_user_case{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();
    let (project_address) = project.get_address();

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(admin_address);
    admin.mint(to=anyone_address, token_id=1);
    admin.revoke_minter(admin_address);

    // At t = 0
    %{ stop_warp_offseter = warp(blk_timestamp=0, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=0, target_contract_address=ids.project_address) %}

    // Anyone deposits token #1
    anyone.project_approve(approved=offseter_address, token_id=1);
    anyone.offseter_deposit(token_id=1);

    // Claimable is 0
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 0;

    // Claimed is 0
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
    assert claimed = 0;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1659312000
    %{ stop_warp_offseter = warp(blk_timestamp=1659312000, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1659312000, target_contract_address=ids.project_address) %}

    // Claimable is 1179750
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 1179750;

    // Claimed is 0
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
    assert claimed = 0;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1667260800
    %{ stop_warp_offseter = warp(blk_timestamp=1667260800, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1667260800, target_contract_address=ids.project_address) %}

    // Anyone claims
    %{ expect_events({"name": "Claim"}) %}
    anyone.offseter_claim_all();

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1675209600
    %{ stop_warp_offseter = warp(blk_timestamp=1675209600, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1675209600, target_contract_address=ids.project_address) %}

    // Claimable is 1179750
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 1179750;

    // Claimed is 1179750
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
    assert claimed = 2359500;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1682899200
    %{ stop_warp_offseter = warp(blk_timestamp=1682899200, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address) %}

    // Anyone wtihdraws token #1
    anyone.offseter_withdraw(token_id=1);

    // Total absorption
    let (absorption) = admin.get_current_absorption();
    assert absorption = 4719000;

    // Claimable is 2359500
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 2359500;

    // Claimed is 2359500
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
    assert claimed = 2359500;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1690848000
    %{ stop_warp_offseter = warp(blk_timestamp=1690848000, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1690848000, target_contract_address=ids.project_address) %}

    // Claimable is 2359500
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 2359500;

    // Claimed is 1179750
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
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

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(admin_address);
    admin.mint(to=admin_address, token_id=1);
    admin.mint(to=admin_address, token_id=2);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=anyone_address, token_id=4);
    admin.mint(to=anyone_address, token_id=5);
    admin.revoke_minter(admin_address);

    // At t = 0
    %{ stop_warp_offseter = warp(blk_timestamp=0, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=0, target_contract_address=ids.project_address) %}

    // Admin deposits tokens #1, #2
    // Anyone deposits tokens #3, #4, #5
    admin.project_approve(approved=offseter_address, token_id=1);
    admin.offseter_deposit(token_id=1);
    admin.project_approve(approved=offseter_address, token_id=2);
    admin.offseter_deposit(token_id=2);
    anyone.project_approve(approved=offseter_address, token_id=3);
    anyone.offseter_deposit(token_id=3);
    anyone.project_approve(approved=offseter_address, token_id=4);
    anyone.offseter_deposit(token_id=4);
    anyone.project_approve(approved=offseter_address, token_id=5);
    anyone.offseter_deposit(token_id=5);

    // Claimable is 0
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 0;

    // Claimed is 0
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
    assert claimed = 0;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    // At t = 1659312000
    %{ stop_warp_offseter = warp(blk_timestamp=1659312000, target_contract_address=ids.offseter_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1659312000, target_contract_address=ids.project_address) %}

    // Total claimable is 471900 + 707850 = 1179750
    let (total_claimable) = anyone.offseter_total_claimable();
    assert total_claimable = 1179750;

    // Admin claimable is 1179750 * 2 / 5 = 471900
    let (claimable) = admin.offseter_claimable_of(address=admin_address);
    assert claimable = 471900;

    // Anyone claimable is 1179750 * 3 / 5 = 707850
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 707850;

    %{ stop_warp_offseter() %}
    %{ stop_warp_project() %}

    return ();
}
