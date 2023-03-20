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
    carbonable_yielder_instance as yielder,
    carbonable_vester_instance as vester,
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
func test_create_vestings_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.create_vestings(
        total_amount=1000,
        cliff_delta=0,
        start=120,
        duration=10,
        slice_period_seconds=1,
        revocable=TRUE,
    );

    return ();
}

@view
func test_create_vestings_without_any_deposited{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot at a sooner time that previous snapshot") %}
    snapshoter.snapshot();

    return ();
}

@view
func test_create_vestings_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let (vester_address) = vester.get_address();
    let slot = 1;

    // Transfer funds to vester
    admin.transfer(recipient=vester_address, amount=1000);

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=admin_address, token_id=1, slot=slot, value=100);
    admin.mint(to=admin_address, token_id=2, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=3, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=4, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=5, slot=slot, value=100);
    admin.revoke_minter(slot=slot, minter=admin_address);

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
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Start testing create vestings
    %{ stop_warp_yielder = warp(blk_timestamp=1706745600, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1706745600, target_contract_address=ids.project_address) %}

    admin.create_vestings(
        total_amount=1000,
        cliff_delta=0,
        start=1706745600,
        duration=5,
        slice_period_seconds=1,
        revocable=TRUE,
    );
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    %{ stop_warp = warp(blk_timestamp=1730419200, target_contract_address=ids.vester_address) %}
    let (releasable_amount) = vester.releasable_of(anyone_address);
    with_attr error_message("Testing: releasable amount should be expected amount: 600") {
        assert releasable_amount = 600;
    }

    let (releasable_amount) = vester.releasable_of(admin_address);
    with_attr error_message("Testing: releasable amount should be expected amount: 400") {
        assert releasable_amount = 400;
    }
    %{ stop_warp %}

    return ();
}

@view
func test_create_vestings_only_one_deposited{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let (vester_address) = vester.get_address();
    let slot = 1;

    // Transfer funds to vester
    admin.transfer(recipient=vester_address, amount=1000);

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=admin_address, token_id=1, slot=slot, value=100);
    admin.mint(to=admin_address, token_id=2, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=3, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=4, slot=slot, value=100);
    admin.mint(to=anyone_address, token_id=5, slot=slot, value=100);
    admin.revoke_minter(slot=slot, minter=admin_address);

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

    // Start testing create vestings
    %{ stop_warp_yielder = warp(blk_timestamp=1706745600, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1706745600, target_contract_address=ids.project_address) %}

    admin.create_vestings(
        total_amount=1000,
        cliff_delta=0,
        start=1706745600,
        duration=5,
        slice_period_seconds=1,
        revocable=TRUE,
    );
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    %{ stop_warp = warp(blk_timestamp=1730419200, target_contract_address=ids.vester_address) %}
    let (releasable_amount) = vester.releasable_of(anyone_address);
    with_attr error_message("Testing: releasable amount should be expected amount: 1000") {
        assert releasable_amount = 1000;
    }

    anyone.release_all();

    let (released_amount) = vester.released_of(anyone_address);
    with_attr error_message("Testing: released amount should be expected amount: 1000") {
        assert released_amount = 1000;
    }

    %{ stop_warp %}

    return ();
}

@view
func test_create_vestings_not_enough_fund_vester{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let (vester_address) = vester.get_address();
    let slot = 1;

    // Mint tokens with temporary MINTER_ROLE
    admin.add_minter(slot=slot, minter=admin_address);
    admin.mint(to=anyone_address, token_id=3, slot=slot, value=100);
    admin.revoke_minter(slot=slot, minter=admin_address);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}

    anyone.set_approval_for_slot(slot=slot, operator=yielder_address);
    anyone.yielder_deposit(token_id=3, value=100);

    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Snapshoter snapshot
    %{ stop_warp_yielder = warp(blk_timestamp=1682899200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1682899200, target_contract_address=ids.project_address) %}
    snapshoter.snapshot();
    %{ stop_warp_yielder() %}
    %{ stop_warp_project() %}

    // Start testing create vestings
    %{ stop_warp = warp(blk_timestamp=1706745600, target_contract_address=ids.yielder_address) %}
    admin.transfer(recipient=vester_address, amount=800);

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: not enough unallocated amount into vester") %}
    admin.create_vestings(
        total_amount=1000,
        cliff_delta=0,
        start=1706745600,
        duration=10,
        slice_period_seconds=1,
        revocable=TRUE,
    );
    %{ stop_warp %}

    return ();
}
