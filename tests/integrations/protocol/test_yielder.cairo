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
    carbonable_yielder_instance as yielder,
    carbonable_starkvest_instance as starkvest,
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
func test_deposit_and_withdraw_while_unlock{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 10s period with 5s unlock
    // And anyone approves yielder for token 3 at time 5
    // And anyone deposits token 3 to yielder at time 5
    // And anyone withdraws token 3 from yielder at time 5
    // And anyone approves yielder for token 3 at time 5
    // And anyone deposits token 3 to yielder at time 5
    // And anyone approves yielder for token 4 at time 5
    // And anyone deposits token 4 to yielder at time 5
    // Then anyone shares is 100%
    // When admin approves yielder for token 1 at time 5
    // And admin deposits token 1 to yielder at time 5
    // Then anyone shares is 66%
    // When anyone withdraws token 3 from yielder at time 10
    // Then anyone shares is 50%
    // When admin withdraws token 1 from yielder at time 10
    // Then anyone shares is 100%
    // When anyone withdraws token 4 from yielder at time 10
    // Then anyone shares is 0%
    // When check the owner of token 1
    // Then a failed transaction is expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (yielder_address) = yielder.get_address();

    // Mint tokens
    admin.mint(to=admin_address, token_id=1);
    admin.mint(to=admin_address, token_id=2);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=anyone_address, token_id=4);
    admin.mint(to=anyone_address, token_id=5);

    admin.yielder_start_period(unlocked_duration=5, period_duration=10);

    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.yielder_address) %}
    anyone.project_approve(approved=yielder_address, token_id=3);
    anyone.yielder_deposit(token_id=3);
    anyone.yielder_withdraw(token_id=3);
    anyone.project_approve(approved=yielder_address, token_id=3);
    anyone.yielder_deposit(token_id=3);
    anyone.project_approve(approved=yielder_address, token_id=4);
    anyone.yielder_deposit(token_id=4);

    let (shares) = anyone.yielder_shares_of(anyone_address, precision=100);
    assert shares = Uint256(low=100, high=0);

    admin.project_approve(approved=yielder_address, token_id=1);
    admin.yielder_deposit(token_id=1);
    %{ stop_warp() %}

    let (owner) = anyone.yielder_registred_owner_of(token_id=3);
    assert owner = anyone_address;

    let (owner) = anyone.yielder_registred_owner_of(token_id=1);
    assert owner = admin_address;

    let (shares) = anyone.yielder_shares_of(anyone_address, precision=100);
    assert shares = Uint256(low=66, high=0);

    let (balance) = anyone.yielder_total_locked();
    assert balance = Uint256(low=3, high=0);

    %{ stop_warp = warp(blk_timestamp=10, target_contract_address=ids.yielder_address) %}
    anyone.yielder_withdraw(token_id=3);

    let (shares) = anyone.yielder_shares_of(anyone_address, precision=100);
    assert shares = Uint256(low=50, high=0);

    admin.yielder_withdraw(token_id=1);

    let (shares) = anyone.yielder_shares_of(anyone_address, precision=100);
    assert shares = Uint256(low=100, high=0);

    anyone.yielder_withdraw(token_id=4);
    %{ stop_warp() %}

    let (shares) = anyone.yielder_shares_of(anyone_address, precision=100);
    assert shares = Uint256(low=0, high=0);

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: token_id has not been registred") %}
    let (owner) = anyone.yielder_registred_owner_of(token_id=1);

    return ();
}

@view
func test_deposit_revert_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When admin starts a 10s period with 5s unlock
    // And anyone approves yielder for token 3 at time 1
    // And anyone deposits token 3 to yielder at time 6
    // Then a failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (yielder_address) = yielder.get_address();

    // Mint tokens
    admin.mint(to=anyone_address, token_id=3);

    admin.yielder_start_period(unlocked_duration=5, period_duration=10);

    anyone.project_approve(approved=yielder_address, token_id=3);

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.yielder_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: deposits are currently locked") %}
    anyone.yielder_deposit(token_id=3);
    %{ stop_warp() %}

    return ();
}

@view
func test_withdraw_revert_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    // When admin starts a 10s period with 5s unlock
    // And anyone approves yielder for token 3 at time 1
    // And anyone deposits token 3 to yielder at time 5
    // And anyone withdraws token 3 from yielder at time 6
    // Then a failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (yielder_address) = yielder.get_address();

    // Mint tokens
    admin.mint(to=anyone_address, token_id=3);

    admin.yielder_start_period(unlocked_duration=5, period_duration=10);
    anyone.project_approve(approved=yielder_address, token_id=3);

    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.yielder_address) %}
    anyone.yielder_deposit(token_id=3);
    %{ stop_warp() %}

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.yielder_address) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: withdrawals are currently locked") %}
    anyone.yielder_withdraw(token_id=3);
    %{ stop_warp() %}

    return ();
}

@view
func test_start_and_start_and_stop_period{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When admin starts a 10s period with 5s unlock
    // And admin starts a 20s period with 10s unlock
    // And admin stops the current period
    // Then no failed transactions expected
    alloc_locals;
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (yielder_address) = yielder.get_address();

    admin.yielder_start_period(unlocked_duration=5, period_duration=10);
    admin.yielder_start_period(unlocked_duration=10, period_duration=20);
    admin.yielder_stop_period();

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
    anyone.yielder_start_period(unlocked_duration=5, period_duration=10);

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

    admin.yielder_start_period(unlocked_duration=5, period_duration=10);
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.yielder_stop_period();

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
    let total_amount = 10;

    admin.yielder_start_period(unlocked_duration=5, period_duration=10);
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.create_vestings(total_amount=total_amount);

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
    let (yielder_address) = yielder.get_address();
    let (starkvest_address) = starkvest.get_address();
    let total_amount = 10;

    admin.yielder_start_period(unlocked_duration=5, period_duration=100);

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.yielder_address) %}
    admin.create_vestings(total_amount=total_amount);
    %{ stop_warp %}
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

    // # Setup for prerequis
    alloc_locals;
    let zero = Uint256(low=0, high=0);
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (yielder_address) = yielder.get_address();
    let (starkvest_address) = starkvest.get_address();

    // Mint tokens
    admin.mint(to=admin_address, token_id=1);
    admin.mint(to=admin_address, token_id=2);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=anyone_address, token_id=4);
    admin.mint(to=anyone_address, token_id=5);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    admin.yielder_start_period(unlocked_duration=5, period_duration=100);
    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.yielder_address) %}
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
    %{ stop_warp %}

    // # Start testing create vestings
    let total_amount = 1000;

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.yielder_address) %}
    admin.create_vestings(total_amount=total_amount);
    %{ stop_warp %}

    %{ stop_warp = warp(blk_timestamp=10, target_contract_address=ids.starkvest_address) %}
    let (vesting_id) = anyone.get_vesting_id();
    let (releasable_amount) = anyone.releasable_amount(vesting_id);

    let expected_amount = Uint256(low=200, high=0);
    let (is_zero) = uint256_eq(releasable_amount, expected_amount);
    with_attr error_message("Testing: releasable amount should be expected amount: 200") {
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

    // # Setup for prerequis
    alloc_locals;
    let zero = Uint256(low=0, high=0);
    let (admin_address) = admin.get_address();
    let (anyone_address) = anyone.get_address();
    let (yielder_address) = yielder.get_address();
    let (starkvest_address) = starkvest.get_address();

    // Mint tokens
    admin.mint(to=admin_address, token_id=1);
    admin.mint(to=admin_address, token_id=2);
    admin.mint(to=anyone_address, token_id=3);
    admin.mint(to=anyone_address, token_id=4);
    admin.mint(to=anyone_address, token_id=5);

    // Deposit 3 NFT from anyone and 2 NFT from admin into yielder
    admin.yielder_start_period(unlocked_duration=5, period_duration=100);
    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.yielder_address) %}
    anyone.project_approve(approved=yielder_address, token_id=3);
    anyone.yielder_deposit(token_id=3);
    %{ stop_warp %}

    // # Start testing create vestings
    let total_amount = 1000;

    %{ stop_warp = warp(blk_timestamp=6, target_contract_address=ids.yielder_address) %}
    admin.create_vestings(total_amount=total_amount);
    %{ stop_warp %}

    %{ stop_warp = warp(blk_timestamp=10, target_contract_address=ids.starkvest_address) %}
    let (vesting_id) = anyone.get_vesting_id();
    let (releasable_amount) = anyone.releasable_amount(vesting_id);

    let expected_amount = Uint256(low=1000, high=0);
    let (is_zero) = uint256_eq(releasable_amount, expected_amount);
    with_attr error_message("Testing: releasable amount should be expected amount: 1000") {
        assert is_zero = TRUE;
    }

    %{ stop_warp %}

    return ();
}
