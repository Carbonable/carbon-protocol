// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

// Local dependencies
from tests.integrations.protocol.library import (
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
    // Given a get_address user contracts
    // And an admin with address 1000
    // And an anyone with address 1001
    // Given a get_address project contact
    // And owned by admin
    // And with token 1 owned by admin
    // And with token 2 owned by admin
    // And with token 3 owned by anyone
    // And with token 4 owned by anyone
    // And with token 5 owned by anyone
    // Given a get_address farmer contract
    // And owned by admin
    return setup();
}

@view
func test_snapshot_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 10s period with 5s unlock
    // And anyone snapshots
    // Then a failed transaction is expected
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "AccessControl: caller is missing role") %}
    anyone.snapshot();

    return ();
}

@view
func test_create_vestings_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 10s period with 5s unlock
    // And anyone create vestings
    // Then a failed transaction is expected
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
    // When admin starts a 100s period with 5s unlock
    // And admin create vestings during lock period
    // Then no failed transactions expected
    // And no vesting will be created
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot at a sooner time that previous snapshot") %}
    snapshoter.snapshot();

    return ();
}

@view
func test_create_vestings_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 100s period with 5s unlock
    // And admin mint token_id from 1 to 5
    // And anyone approves yielder for token 3 at time 5
    // And anyone deposits token 3 to yielder at time 5
    // And anyone approves yielder for token 4 at time 5
    // And anyone deposits token 4 to yielder at time 5
    // And anyone approves yielder for token 5 at time 5
    // And anyone deposits token 5 to yielder at time 5
    // And admin approves yielder for token 1 at time 5
    // And admin deposits token 1 to yielder at time 5
    // And admin approves yielder for token 2 at time 5
    // And admin deposits token 2 to yielder at time 5
    // When admin deposits 1000 ERC-20 token into at time 6
    // And admin create vesting for anyone and admin who deposited token during unlock period
    // Then anyone request the releasable amount of vesting for the last vesting created at time 10
    // And releasable amount of anyone must be equal to expected amount of vesting

    // Setup for prerequis
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let (vester_address) = vester.get_address();

    // Mint tokens with temporary role
    admin.add_minter(admin_address);
    admin.transfer(recipient=vester_address, amount=1000);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=anyone_address, token_id=4);
    admin.mint(to=anyone_address, token_id=5);
    admin.mint(to=admin_address, token_id=1);
    admin.mint(to=admin_address, token_id=2);
    admin.revoke_minter(admin_address);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}

    anyone.project_approve(approved=yielder_address, token_id=3);
    anyone.yielder_deposit(token_id=3);
    anyone.project_approve(approved=yielder_address, token_id=4);
    anyone.yielder_deposit(token_id=4);
    anyone.project_approve(approved=yielder_address, token_id=5);
    anyone.yielder_deposit(token_id=5);

    admin.project_approve(approved=yielder_address, token_id=1);
    admin.yielder_deposit(token_id=1);
    admin.project_approve(approved=yielder_address, token_id=2);
    admin.yielder_deposit(token_id=2);

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
    let (vesting_id) = anyone.get_vesting_id();
    let (releasable_amount) = anyone.releasable_amount(vesting_id);
    let expected_amount = Uint256(low=600, high=0);
    let (is_zero) = uint256_eq(releasable_amount, expected_amount);
    with_attr error_message("Testing: releasable amount should be expected amount: 600") {
        assert is_zero = TRUE;
    }

    let (vesting_id) = admin.get_vesting_id();
    let (releasable_amount) = admin.releasable_amount(vesting_id);
    let expected_amount = Uint256(low=400, high=0);
    let (is_zero) = uint256_eq(releasable_amount, expected_amount);
    with_attr error_message("Testing: releasable amount should be expected amount: 400") {
        assert is_zero = TRUE;
    }
    %{ stop_warp %}

    return ();
}

@view
func test_create_vestings_only_one_deposited{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 100s period with 5s unlock
    // And admin mint token_id from 1 to 5
    // And anyone approves yielder for token 3 at time 5
    // And anyone deposits token 3 to yielder at time 5
    // When admin deposits 1000 ERC-20 token into at time 6
    // And admin create vesting for anyone and admin who deposited token during unlock period
    // Then anyone request the releasable amount of vesting for the last vesting created at time 10
    // And releasable amount of anyone must be equal to the total of amount deposited by admin

    // Setup for prerequis
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let (vester_address) = vester.get_address();

    // Mint tokens with temporary role
    admin.add_minter(admin_address);
    admin.transfer(recipient=vester_address, amount=1000);
    admin.mint(to=anyone_address, token_id=1);
    admin.mint(to=anyone_address, token_id=2);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=admin_address, token_id=4);
    admin.mint(to=admin_address, token_id=5);
    admin.revoke_minter(admin_address);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}

    anyone.project_approve(approved=yielder_address, token_id=3);
    anyone.yielder_deposit(token_id=3);

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
    let (releasable_amount) = anyone.releasable_of(anyone_address);

    let expected_amount = Uint256(low=1000, high=0);
    let (is_zero) = uint256_eq(releasable_amount, expected_amount);
    with_attr error_message("Testing: releasable amount should be expected amount: 1000") {
        assert is_zero = TRUE;
    }

    anyone.release_all();

    let (released_amount) = anyone.released_of(anyone_address);
    let (is_zero) = uint256_eq(released_amount, expected_amount);
    with_attr error_message("Testing: released amount should be expected amount: 1000") {
        assert is_zero = TRUE;
    }

    %{ stop_warp %}

    return ();
}

@view
func test_create_vestings_not_enough_fund_vester{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 100s period with 5s unlock
    // And admin mint token_id from 1 to 5
    // And anyone approves yielder for token 3 at time 5
    // And anyone deposits token 3 to yielder at time 5
    // When admin deposits 800 ERC-20 token into at time 6
    // And admin create vesting for anyone and admin who deposited token during unlock period
    // Then a failed transactions expected
    // And error_messages of not enough unallocated amount into vester expected

    // Setup for prerequis
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (project_address) = project.get_address();
    let (yielder_address) = yielder.get_address();
    let (vester_address) = vester.get_address();

    // Mint tokens with temporary role
    admin.add_minter(admin_address);
    admin.mint(to=anyone_address, token_id=3);
    admin.revoke_minter(admin_address);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    %{ stop_warp_yielder = warp(blk_timestamp=1651363200, target_contract_address=ids.yielder_address) %}
    %{ stop_warp_project = warp(blk_timestamp=1651363200, target_contract_address=ids.project_address) %}
    anyone.project_approve(approved=yielder_address, token_id=3);
    anyone.yielder_deposit(token_id=3);
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
