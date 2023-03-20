// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.library import (
    setup,
    carbonable_project_instance as project,
    carbonable_minter_instance as minter,
    admin_instance as admin,
    withdrawer_instance as withdrawer,
    anyone_instance as anyone,
)

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@view
func test_access_control{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let slot = 1;
    let (minters_len, minters) = project.get_minters(slot);
    assert 1 = minters_len;

    admin.add_minter(slot, 123);
    admin.add_minter(slot, 456);
    admin.add_minter(slot, 789);
    let (minters_len, minters) = project.get_minters(slot);
    assert 4 = minters_len;
    assert 789 = [minters + 0];
    assert 456 = [minters + 1];
    assert 123 = [minters + 2];

    admin.revoke_minter(slot, 456);
    let (minters_len, minters) = project.get_minters(slot);
    assert 3 = minters_len;
    assert 789 = [minters + 0];
    assert 123 = [minters + 1];

    admin.revoke_minter(slot, 123);
    let (minters_len, minters) = project.get_minters(slot);
    assert 2 = minters_len;
    assert 789 = [minters + 0];

    admin.revoke_minter(slot, 789);
    let (minters_len, minters) = project.get_minters(slot);
    assert 1 = minters_len;

    admin.set_certifier(slot, 1234);
    let (certifier) = project.get_certifier(slot);
    assert 1234 = certifier;

    admin.set_certifier(slot, 5678);
    let (certifier) = project.get_certifier(slot);
    assert 5678 = certifier;

    admin.set_certifier(slot, 0);
    let (certifier) = project.get_certifier(slot);
    assert 0 = certifier;

    return ();
}

@view
func test_whitelisted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    anyone.approve(value=5);
    anyone.whitelist_buy(value=5, force=0);

    let (sold_out) = minter.is_sold_out();
    assert sold_out = FALSE;

    admin.set_public_sale_open(TRUE);
    anyone.approve(value=1);
    anyone.public_buy(value=1, force=0);
    withdrawer.withdraw();

    let (sold_out) = minter.is_sold_out();
    assert sold_out = TRUE;

    return ();
}

@view
func test_not_whitelisted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    admin.set_whitelist_merkle_root(123);
    anyone.approve(value=1);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: caller address is not whitelisted") %}
    anyone.whitelist_buy(value=1, force=0);

    return ();
}

@view
func test_airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (minter_address) = minter.get_address();
    let (anyone_address) = anyone.get_address();

    %{ warp(blk_timestamp=200, target_contract_address=ids.minter_address) %}
    anyone.approve(value=5);
    %{ expect_events(dict(name="Buy", data=dict(address=context.anyone_account_contract, value=dict(low=5, high=0), time=200))) %}
    anyone.whitelist_buy(value=5, force=0);
    admin.set_public_sale_open(TRUE);
    %{ expect_events(dict(name="Airdrop", data=dict(address=context.anyone_account_contract, value=dict(low=3, high=0), time=200))) %}
    admin.airdrop(to=anyone_address, value=3);
    admin.decrease_reserved_value(value=1);
    anyone.approve(value=2);
    %{ expect_events(dict(name="Buy", data=dict(address=context.anyone_account_contract, value=dict(low=1, high=0), time=200))) %}
    anyone.public_buy(value=1, force=0);
    %{ expect_events(dict(name="SoldOut", data=dict(time=200))) %}
    anyone.public_buy(value=2, force=1);
    withdrawer.withdraw();

    return ();
}

@view
func test_public_buy_not_enough_available_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    anyone.approve(value=5);
    anyone.whitelist_buy(value=5, force=0);
    admin.set_public_sale_open(TRUE);
    anyone.approve(value=2);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available value") %}
    anyone.public_buy(value=2, force=0);

    return ();
}

@view
func test_airdrop_not_enough_available_reserved_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    anyone.approve(value=5);
    anyone.whitelist_buy(value=5, force=0);
    admin.set_public_sale_open(TRUE);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved value") %}
    admin.airdrop(to=anyone_address, value=5);

    return ();
}

@view
func test_over_airdropped{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available value") %}
    admin.airdrop(to=anyone_address, value=11);

    return ();
}

@view
func test_revert_set_public_sale_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_public_sale_open(FALSE);

    return ();
}

@view
func test_revert_set_max_value_per_tx_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_max_value_per_tx(3);

    return ();
}

@view
func test_revert_set_min_value_per_tx_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_min_value_per_tx(3);

    return ();
}

@view
func test_revert_set_unit_price_revert_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_unit_price(2);

    return ();
}
