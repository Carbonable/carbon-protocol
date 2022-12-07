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

    // At t = 5
    %{ stop_warp = warp(blk_timestamp=5, target_contract_address=ids.offseter_address) %}

    // Anyone deposits token #3
    anyone.project_approve(approved=offseter_address, token_id=3);
    anyone.offseter_deposit(token_id=3);

    // Claimable is 0
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 0;
    %{ stop_warp() %}

    // At t = 103
    %{ stop_warp = warp(blk_timestamp=103, target_contract_address=ids.offseter_address) %}

    // Anyone withdraws token #3
    anyone.offseter_withdraw(token_id=3);

    // Claimable is 1179750
    let (claimable) = anyone.offseter_claimable_of(address=anyone_address);
    assert claimable = 1179750;

    // Claimed is 0
    let (claimed) = anyone.offseter_claimed_of(address=anyone_address);
    assert claimed = 0;
    %{ stop_warp() %}

    // At t = 104
    %{ stop_warp = warp(blk_timestamp=104, target_contract_address=ids.offseter_address) %}

    // Anyone deposits token #3
    anyone.offseter_deposit(token_id=3);
    %{ stop_warp() %}

    // At t = 105
    %{ stop_warp = warp(blk_timestamp=105, target_contract_address=ids.offseter_address) %}

    // Anyone deposits token #4
    anyone.project_approve(approved=offseter_address, token_id=4);
    anyone.offseter_deposit(token_id=4);
    %{ stop_warp() %}

    // Total deposited is 2
    let (total_deposited) = admin.offseter_total_deposited();
    assert total_deposited = 2;

    // At t = 109
    %{ stop_warp = warp(blk_timestamp=9, target_contract_address=ids.offseter_address) %}

    // Admin deposits token #1
    admin.project_approve(approved=offseter_address, token_id=1);
    admin.offseter_deposit(token_id=1);
    %{ stop_warp() %}

    let (owner) = anyone.offseter_registered_owner_of(token_id=3);
    assert owner = anyone_address;

    let (time) = anyone.offseter_registered_time_of(token_id=3);
    assert time = 107;

    let (owner) = anyone.offseter_registered_owner_of(token_id=1);
    assert owner = admin_address;

    let (time) = anyone.offseter_registered_time_of(token_id=1);
    assert time = 109;

    let (total_balance) = anyone.offseter_total_deposited();
    assert total_deposited = 3;

    %{ stop_warp = warp(blk_timestamp=110, target_contract_address=ids.offseter_address) %}

    let (claimable) = admin.offseter_claimable_of(admin_address);
    assert claimable = 0;

    let (claimable) = admin.offseter_claimable_of(anyone_address);
    assert claimable = 0;

    let (total_claimable) = admin.offseter_total_claimable();
    assert total_claimable = 0;

    %{ expect_events({"name": "Claim"}) %}
    anyone.offseter_claim();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableOffseter: token_id has not been registered") %}
    let (owner) = anyone.offseter_registered_owner_of(token_id=2);

    return ();
}
