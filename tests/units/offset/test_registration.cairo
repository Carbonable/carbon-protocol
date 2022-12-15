// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.offset.library import setup, prepare, CarbonableOffseter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_registration{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let (local contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [2, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [1]) %}
    %{ stop_mock = mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}

    %{ stop_mock_ownerOf = mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    %{ stop_warp=warp(blk_timestamp=10) %}
    %{ stop=start_prank(context.signers.anyone) %}
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;
    %{ stop() %}
    %{ stop_warp=() %}

    %{ stop_warp=warp(blk_timestamp=20) %}
    %{ stop=start_prank(context.signers.admin) %}
    let (success) = CarbonableOffseter.deposit(token_id=two);
    assert success = 1;
    %{ stop() %}
    %{ stop_warp=() %}

    %{ stop_mock() %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [2, 0]) %}

    let (balance) = CarbonableOffseter.total_deposited();
    assert balance = Uint256(low=2, high=0);

    let (owner) = CarbonableOffseter.registered_owner_of(one);
    assert owner = context.signers.anyone;

    let (time) = CarbonableOffseter.registered_time_of(one);
    assert time = 10;

    let (owner) = CarbonableOffseter.registered_owner_of(two);
    assert owner = context.signers.admin;

    let (time) = CarbonableOffseter.registered_time_of(two);
    assert time = 20;
    %{ stop_mock_ownerOf() %}

    %{ stop_mock_ownerOf = mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.admin]) %}
    %{ stop_warp=warp(blk_timestamp=30) %}
    %{ stop=start_prank(context.signers.admin) %}
    let (success) = CarbonableOffseter.withdraw(token_id=two);
    assert success = 1;
    %{ stop() %}
    %{ stop_warp=() %}
    %{ stop_mock_ownerOf() %}

    %{ stop_mock_ownerOf = mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    %{ stop_warp=warp(blk_timestamp=40) %}
    %{ stop=start_prank(context.signers.admin) %}
    let (success) = CarbonableOffseter.deposit(token_id=two);
    assert success = 1;
    %{ stop() %}
    %{ stop_warp=() %}

    let (owner) = CarbonableOffseter.registered_owner_of(two);
    assert owner = context.signers.admin;

    let (time) = CarbonableOffseter.registered_time_of(two);
    assert time = 40;
    %{ stop_mock_ownerOf() %}

    return ();
}

@external
func test_registration_revert_not_registered{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);

    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [0]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableOffseter: token_id has not been registered") %}
    let (owner) = CarbonableOffseter.registered_owner_of(one);

    return ();
}
@external
func test_registered_tokens_no_deposit{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;
    let admin_address = context.signers.admin;

    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}

    let (tokens_len, tokens) = CarbonableOffseter.registered_tokens_of(address=anyone_address);
    assert tokens_len = 0;

    let (tokens_len, tokens) = CarbonableOffseter.registered_tokens_of(address=admin_address);
    assert tokens_len = 0;

    return ();
}
