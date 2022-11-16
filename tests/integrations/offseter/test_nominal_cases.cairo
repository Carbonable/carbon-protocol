// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from tests.integrations.offseter.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
    carbonable_offseter_instance as offseter,
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
func test_e2e_deposit_and_withdraw_while_unlock{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin start a 10s period with 5s unlock
    // And anyone approves offseter for token 3 at time 5
    // And anyone deposits token 3 to offseter at time 5
    // And anyone withdraws token 3 from offseter at time 5
    // And anyone approves offseter for token 3 at time 5
    // And anyone deposits token 3 to offseter at time 5
    // And anyone approves offseter for token 4 at time 5
    // And anyone deposits token 4 to offseter at time 5
    // Then anyone balance is 2
    // When admin approves offseter for token 1 at time 5
    // And admin deposits token 1 to offseter at time 5
    // Then anyone balance is 2
    // And admin balance is 1
    // When anyone withdraws token 3 from offseter at time 10
    // Then anyone balance is 1
    // When admin withdraws token 1 from offseter at time 10
    // Then admin balance is 0
    // And anyone balance is 1
    // When anyone withdraws token 4 from offseter at time 10
    // Then anyone balance is 0
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.deployed();

    admin.start_period(unlocked_duration=5, period_duration=10);

    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.offseter_address) %}
    anyone.approve(approved=offseter_address, token_id=3);
    anyone.deposit(token_id=3);
    anyone.withdraw(token_id=3);
    anyone.approve(approved=offseter_address, token_id=3);
    anyone.deposit(token_id=3);
    anyone.approve(approved=offseter_address, token_id=4);
    anyone.deposit(token_id=4);

    let (balance) = anyone.balance_of(anyone_address);
    assert balance = 2;

    admin.approve(approved=offseter_address, token_id=1);
    admin.deposit(token_id=1);
    %{ stop_warp() %}

    let (owner) = anyone.registred_owner_of(token_id=3);
    assert owner = anyone_address;

    let (owner) = anyone.registred_owner_of(token_id=1);
    assert owner = admin_address;

    let (balance) = anyone.balance_of(anyone_address);
    assert balance = 2;

    let (balance) = anyone.balance_of(admin_address);
    assert balance = 1;

    let (total_balance) = anyone.total_locked();
    assert total_balance = Uint256(low=3, high=0);

    %{ stop_warp = warp(blk_timestamp=10, target_contract_address=ids.offseter_address) %}
    anyone.withdraw(token_id=3);

    let (balance) = anyone.balance_of(anyone_address);
    assert balance = 1;

    admin.withdraw(token_id=1);

    let (balance) = anyone.balance_of(admin_address);
    assert balance = 0;

    let (balance) = anyone.balance_of(anyone_address);
    assert balance = 1;

    anyone.withdraw(token_id=4);
    %{ stop_warp() %}

    let (balance) = anyone.balance_of(anyone_address);
    assert balance = 0;

    let (owner) = anyone.registred_owner_of(token_id=1);
    assert owner = 0;

    return ();
}

@view
func test_e2e_deposit_revert_locked{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin start a 10s period with 5s unlock
    // And anyone approves offseter for token 3 at time 1
    // And anyone deposits token 3 to offseter at time 6
    // Then a failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.deployed();

    admin.start_period(unlocked_duration=5, period_duration=10);

    anyone.approve(approved=offseter_address, token_id=3);

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.offseter_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarmer: deposits are currently locked") %}
    anyone.deposit(token_id=3);
    %{ stop_warp() %}

    return ();
}

@view
func test_e2e_withdraw_revert_locked{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin start a 10s period with 5s unlock
    // And anyone approves offseter for token 3 at time 1
    // And anyone deposits token 3 to offseter at time 5
    // And anyone withdraws token 3 from offseter at time 6
    // Then a failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.deployed();

    admin.start_period(unlocked_duration=5, period_duration=10);
    anyone.approve(approved=offseter_address, token_id=3);

    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.offseter_address) %}
    anyone.deposit(token_id=3);
    %{ stop_warp() %}

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.offseter_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarmer: withdrawals are currently locked") %}
    anyone.withdraw(token_id=3);
    %{ stop_warp() %}

    return ();
}

@view
func test_e2e_start_and_start_and_stop_period{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin start a 10s period with 5s unlock
    // And admin start a 20s period with 10s unlock
    // And admin stop the current period
    // Then no failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.deployed();

    admin.start_period(unlocked_duration=5, period_duration=10);
    admin.start_period(unlocked_duration=10, period_duration=20);
    admin.stop_period();

    return ();
}

@view
func test_e2e_start_period_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone starts a 10s period with 5s unlock
    // Then a failed transaction is expected
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.start_period(unlocked_duration=5, period_duration=10);

    return ();
}

@view
func test_e2e_stop_period_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 10s period with 5s unlock
    // And anyone stops the current period
    // Then a failed transaction is expected
    alloc_locals;

    admin.start_period(unlocked_duration=5, period_duration=10);
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.stop_period();

    return ();
}
