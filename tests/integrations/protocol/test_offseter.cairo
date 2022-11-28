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
func test_deposit_and_withdraw_while_unlock{
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
    // When check the owner of token 1
    // Then a failed transaction is expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();

    // Mint tokens
    admin.mint(to=admin_address, token_id=1);
    admin.mint(to=admin_address, token_id=2);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=anyone_address, token_id=4);
    admin.mint(to=anyone_address, token_id=5);

    // 0.5 T/year is 41700000000000 ng/month which is 8340000000000 ng/month per token for a total supply of 5 tokens
    admin.offseter_start_period(unlocked_duration=5, period_duration=10, removal=41700000000000);

    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.offseter_address) %}
    anyone.project_approve(approved=offseter_address, token_id=3);
    anyone.offseter_deposit(token_id=3);
    anyone.offseter_withdraw(token_id=3);
    anyone.project_approve(approved=offseter_address, token_id=3);
    anyone.offseter_deposit(token_id=3);
    anyone.project_approve(approved=offseter_address, token_id=4);
    anyone.offseter_deposit(token_id=4);

    let (balance) = anyone.offseter_balance_of(anyone_address);
    assert balance = 2;

    admin.project_approve(approved=offseter_address, token_id=1);
    admin.offseter_deposit(token_id=1);
    %{ stop_warp() %}

    let (owner) = anyone.offseter_registred_owner_of(token_id=3);
    assert owner = anyone_address;

    let (owner) = anyone.offseter_registred_owner_of(token_id=1);
    assert owner = admin_address;

    let (balance) = anyone.offseter_balance_of(anyone_address);
    assert balance = 2;

    let (balance) = anyone.offseter_balance_of(admin_address);
    assert balance = 1;

    let (total_balance) = anyone.offseter_total_locked();
    assert total_balance = Uint256(low=3, high=0);

    %{ stop_warp = warp(blk_timestamp=8, target_contract_address=ids.offseter_address) %}

    let (total_offsetable) = anyone.total_offsetable(admin_address);
    assert total_offsetable = 0;

    let (total_offsetable) = anyone.total_offsetable(anyone_address);
    assert total_offsetable = 0;

    %{ expect_events({"name": "Snapshot"}) %}
    admin.snapshot();

    let (total_offsetable) = anyone.total_offsetable(admin_address);
    assert total_offsetable = 8340000000000;

    let (total_offseted) = anyone.total_offseted(admin_address);
    assert total_offseted = 0;

    let (total_offsetable) = anyone.total_offsetable(anyone_address);
    assert total_offsetable = 16680000000000;

    let (total_offseted) = anyone.total_offseted(anyone_address);
    assert total_offseted = 0;

    %{ expect_events({"name": "Offset"}) %}
    anyone.offset();

    let (total_offsetable) = anyone.total_offsetable(admin_address);
    assert total_offsetable = 8340000000000;

    let (total_offseted) = anyone.total_offseted(admin_address);
    assert total_offseted = 0;

    let (total_offsetable) = anyone.total_offsetable(anyone_address);
    assert total_offsetable = 0;

    let (total_offseted) = anyone.total_offseted(anyone_address);
    assert total_offseted = 16680000000000;

    %{ stop_warp() %}

    %{ stop_warp = warp(blk_timestamp=10, target_contract_address=ids.offseter_address) %}
    anyone.offseter_withdraw(token_id=3);

    let (balance) = anyone.offseter_balance_of(anyone_address);
    assert balance = 1;

    admin.offseter_withdraw(token_id=1);

    let (balance) = anyone.offseter_balance_of(admin_address);
    assert balance = 0;

    let (balance) = anyone.offseter_balance_of(anyone_address);
    assert balance = 1;

    anyone.offseter_withdraw(token_id=4);
    %{ stop_warp() %}

    let (balance) = anyone.offseter_balance_of(anyone_address);
    assert balance = 0;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarmer: token_id has not been registred") %}
    let (owner) = anyone.offseter_registred_owner_of(token_id=1);

    return ();
}

@view
func test_deposit_revert_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When admin start a 10s period with 5s unlock
    // And anyone approves offseter for token 3 at time 1
    // And anyone deposits token 3 to offseter at time 6
    // Then a failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();

    // Mint tokens
    admin.mint(to=anyone_address, token_id=3);

    admin.offseter_start_period(unlocked_duration=5, period_duration=10, removal=41700000000000);

    anyone.project_approve(approved=offseter_address, token_id=3);

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.offseter_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarmer: deposits are currently locked") %}
    anyone.offseter_deposit(token_id=3);
    %{ stop_warp() %}

    return ();
}

@view
func test_withdraw_revert_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    // When admin start a 10s period with 5s unlock
    // And anyone approves offseter for token 3 at time 1
    // And anyone deposits token 3 to offseter at time 5
    // And anyone withdraws token 3 from offseter at time 6
    // Then a failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();

    // Mint tokens
    admin.mint(to=anyone_address, token_id=3);

    admin.offseter_start_period(unlocked_duration=5, period_duration=10, removal=41700000000000);
    anyone.project_approve(approved=offseter_address, token_id=3);

    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.offseter_address) %}
    anyone.offseter_deposit(token_id=3);
    %{ stop_warp() %}

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.offseter_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarmer: withdrawals are currently locked") %}
    anyone.offseter_withdraw(token_id=3);
    %{ stop_warp() %}

    return ();
}

@view
func test_start_and_start_and_stop_period{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin start a 10s period with 5s unlock
    // And admin start a 20s period with 10s unlock
    // And admin stop the current period
    // Then no failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (offseter_address) = offseter.get_address();

    admin.offseter_start_period(unlocked_duration=5, period_duration=10, removal=41700000000000);
    admin.offseter_start_period(unlocked_duration=10, period_duration=20, removal=41700000000000);
    admin.offseter_stop_period();

    return ();
}

@view
func test_start_period_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone starts a 10s period with 5s unlock
    // Then a failed transaction is expected
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.offseter_start_period(unlocked_duration=5, period_duration=10, removal=41700000000000);

    return ();
}

@view
func test_stop_period_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 10s period with 5s unlock
    // And anyone stops the current period
    // Then a failed transaction is expected
    alloc_locals;

    admin.offseter_start_period(unlocked_duration=5, period_duration=10, removal=41700000000000);
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.offseter_stop_period();

    return ();
}
