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
    snapshoter_instance as snapshoter,
    provisioner_instance as provisioner,
    carbonable_yielder_instance as yielder,
    carbonable_project_instance as project,
)

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@view
func test_snapshot_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "AccessControl: caller is missing role") %}
    anyone.snapshot();

    return ();
}

@view
func test_snapshot_at_t0{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot at a sooner time that previous snapshot") %}
    snapshoter.snapshot();

    return ();
}

@view
func test_snapshot_without_any_deposited{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ stop_warp = warp(blk_timestamp=1, target_contract_address=context.carbonable_yielder_contract) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot or provision if no user has registered") %}
    snapshoter.snapshot();
    %{ stop_warp() %}

    return ();
}

@view
func test_provision_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "AccessControl: caller is missing role") %}
    anyone.provision(amount=1000);

    return ();
}

@view
func test_provision_nominal_case{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
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

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}

    admin.set_approval_for_slot(slot=slot, operator=yielder_address);
    anyone.set_approval_for_slot(slot=slot, operator=yielder_address);
    admin.yielder_deposit(token_id=1, value=100);
    admin.yielder_deposit(token_id=2, value=100);
    anyone.yielder_deposit(token_id=3, value=100);
    anyone.yielder_deposit(token_id=4, value=100);
    anyone.yielder_deposit(token_id=5, value=100);

    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Snapshoter snapshot
    %{
        stop_warp_yielder = warp(blk_timestamp=1682899200, target_contract_address=ids.yielder_address)
        stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.carbonable_project_contract,
            previous_time=0,
            previous_project_absorption=0,
            previous_offseter_absorption=0,
            previous_yielder_absorption=0,
            current_time=1682899200,
            current_project_absorption=4719000,
            current_offseter_absorption=0,
            current_yielder_absorption=4719000,
            period_project_absorption=4719000,
            period_offseter_absorption=0,
            period_yielder_absorption=4719000,
        )))
    %}
    snapshoter.snapshot();

    %{
        expect_events(dict(name="Provision", data=dict(
            project=context.carbonable_project_contract,
            amount=1001,
            time=1682899200,
        )))
    %}

    admin.yielder_withdraw_to(value=200);
    let (claimable) = yielder.get_claimable_of(admin_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 0") {
        assert claimable = 0;
    }

    provisioner.approve(amount=1001);
    provisioner.provision(amount=1001);

    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    let (claimable) = yielder.get_claimable_of(anyone_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 600") {
        assert claimable = 600;
    }

    let (claimable) = yielder.get_claimable_of(admin_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 400") {
        assert claimable = 400;
    }

    // Snapshoter snapshot
    %{
        stop_warp_yielder = warp(blk_timestamp=1722470400, target_contract_address=ids.yielder_address)
        stop_warp_project = warp(blk_timestamp=1722470400, target_contract_address=ids.project_address)
    %}
    snapshoter.snapshot();
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    provisioner.approve(amount=2000);
    provisioner.provision(amount=2000);

    let (total_provisioned) = yielder.get_total_provisioned();
    assert total_provisioned = 2000 + 1001;

    let (claimable) = yielder.get_claimable_of(anyone_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 2601") {
        assert claimable = 2601;
    }

    let (claimable) = yielder.get_claimable_of(admin_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 400") {
        assert claimable = 400;
    }

    return ();
}

@view
func test_provision_not_fully_minted_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let slot = 1;

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=admin_address, token_id=1, slot=slot, value=100);
    admin.mint(to=admin_address, token_id=2, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=3, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=4, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=5, slot=slot, value=100);

    // Set project value to total minted value
    let (project_value) = project.total_value(slot=slot);
    admin.set_project_value(slot=slot, project_value=project_value * 10);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}

    admin.set_approval_for_slot(slot=slot, operator=yielder_address);
    anyone.set_approval_for_slot(slot=slot, operator=yielder_address);
    admin.yielder_deposit(token_id=1, value=100);
    admin.yielder_deposit(token_id=2, value=100);
    anyone.yielder_deposit(token_id=3, value=100);
    anyone.yielder_deposit(token_id=4, value=100);
    anyone.yielder_deposit(token_id=5, value=100);

    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Snapshoter snapshot
    %{
        stop_warp_yielder = warp(blk_timestamp=1682899200, target_contract_address=ids.yielder_address)
        stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.carbonable_project_contract,
            previous_time=0,
            previous_project_absorption=0,
            previous_offseter_absorption=0,
            previous_yielder_absorption=0,
            current_time=1682899200,
            current_project_absorption=4719000,
            current_offseter_absorption=0,
            current_yielder_absorption=471900, # 10% of 4719000
            period_project_absorption=4719000,
            period_offseter_absorption=0,
            period_yielder_absorption=471900, # 10% of 4719000
        )))
    %}
    snapshoter.snapshot();

    %{
        expect_events(dict(name="Provision", data=dict(
            project=context.carbonable_project_contract,
            amount=1001,
            time=1682899200,
        )))
    %}

    admin.yielder_withdraw_to(value=200);
    let (claimable) = yielder.get_claimable_of(admin_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 0") {
        assert claimable = 0;
    }

    provisioner.approve(amount=1001);
    provisioner.provision(amount=1001);

    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    let (claimable) = yielder.get_claimable_of(anyone_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 600") {
        assert claimable = 600;
    }

    let (claimable) = yielder.get_claimable_of(admin_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 400") {
        assert claimable = 400;
    }

    admin.mint(to=anyone_address, token_id=8, slot=slot, value=500);
    admin.revoke_minter(slot=slot, minter=admin_address);

    // Snapshoter snapshot
    %{
        stop_warp_yielder = warp(blk_timestamp=1722470400, target_contract_address=ids.yielder_address)
        stop_warp_project = warp(blk_timestamp=1722470400, target_contract_address=ids.project_address)
    %}
    snapshoter.snapshot();
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    provisioner.approve(amount=2000);
    provisioner.provision(amount=2000);

    let (total_provisioned) = yielder.get_total_provisioned();
    assert total_provisioned = 2000 + 1001;

    let (claimable) = yielder.get_claimable_of(anyone_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 2601") {
        assert claimable = 2601;
    }

    let (claimable) = yielder.get_claimable_of(admin_address);
    with_attr error_message("Testing: claimable amount should be expected amount: 400") {
        assert claimable = 400;
    }

    return ();
}

@view
func test_claim_only_one_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
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

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}

    anyone.set_approval_for_slot(slot=slot, operator=yielder_address);
    anyone.yielder_deposit(token_id=3, value=100);

    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Snapshoter snapshot
    %{
        stop_warp_yielder = warp(blk_timestamp=1682899200, target_contract_address=ids.yielder_address)
        stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.carbonable_project_contract,
            previous_time=0,
            previous_project_absorption=0,
            previous_offseter_absorption=0,
            previous_yielder_absorption=0,
            current_time=1682899200,
            current_project_absorption=4719000,
            current_offseter_absorption=0,
            current_yielder_absorption=943800,
            period_project_absorption=4719000,
            period_offseter_absorption=0,
            period_yielder_absorption=943800,
        )))
    %}
    snapshoter.snapshot();
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    provisioner.approve(amount=1000);
    provisioner.provision(amount=1000);

    let (claimable) = yielder.get_claimable_of(anyone_address);
    with_attr error_message("Testing: releasable amount should be expected amount: 1000") {
        assert claimable = 1000;
    }

    anyone.yielder_claim();

    let (claimed) = yielder.get_claimed_of(anyone_address);
    with_attr error_message("Testing: released amount should be expected amount: 1000") {
        assert claimed = 1000;
    }
    return ();
}

@view
func test_claim_redeposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
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
    anyone.set_approval_for_slot(slot=slot, operator=yielder_address);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}
    anyone.yielder_deposit(token_id=3, value=100);
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Snapshoter snapshot
    %{ stop_warp_yielder = warp(blk_timestamp=1659312000, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1659312000, target_contract_address=ids.project_address) %}
    snapshoter.snapshot();
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    provisioner.approve(amount=1000);
    provisioner.provision(amount=1000);

    // Claim and withdraw
    anyone.yielder_claim();

    %{ stop_warp_yielder = warp(blk_timestamp=1659312000, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1659312000, target_contract_address=ids.project_address) %}
    anyone.yielder_withdraw_to_token(token_id=3, value=100);
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Deposite again
    %{ stop_warp_yielder = warp(blk_timestamp=1675209600, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1675209600, target_contract_address=ids.project_address) %}
    anyone.yielder_deposit(token_id=3, value=100);
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Snapshoter snapshot
    %{ stop_warp_yielder = warp(blk_timestamp=1682899200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address) %}
    snapshoter.snapshot();
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    return ();
}
