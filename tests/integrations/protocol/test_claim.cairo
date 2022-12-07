// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.offset.library import setup, prepare, CarbonableOffseter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (local contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // At t=0
    %{ stop_warp = warp(0) %}

    // Deposit token #1
    %{ stop_mock = mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;
    %{ stop_mock() %}

    // Claimable must be 0
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 0;
    %{ stop_warp() %}

    // At t=3
    %{ stop_warp = warp(3) %}
    // Claimable must be 1179750
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 1179750;
    let (claimed) = CarbonableOffseter.claimed_of(address=context.signers.anyone);
    assert claimed = 0;

    // Withdraw
    %{ stop_mock = mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone]) %}
    let (success) = CarbonableOffseter.withdraw(token_id=one);
    assert success = 1;
    %{ stop_mock() %}
    %{ stop_warp() %}

    // At t=6
    %{ stop_warp = warp(6) %}

    // Deposit token #1
    %{ stop_mock = mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;
    %{ stop_mock() %}

    // Claimable must be 1179750
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 1179750;
    let (claimed) = CarbonableOffseter.claimed_of(address=context.signers.anyone);
    assert claimed = 0;
    %{ stop_warp() %}

    // At t=12
    %{ stop_warp = warp(12) %}

    // Claimable must be 3539250 = 1179750 + (4719000 - 2359500)
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 3539250;
    let (claimed) = CarbonableOffseter.claimed_of(address=context.signers.anyone);
    assert claimed = 0;

    // Claim his balance
    let (success) = CarbonableOffseter.claim();
    assert success = 1;

    // Claimable must be 0
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 0;

    // Claimed must be 3539250
    let (claimed) = CarbonableOffseter.claimed_of(address=context.signers.anyone);
    assert claimed = 3539250;

    %{ stop_warp() %}
    %{ stop() %}

    // At t=13
    %{ stop_warp = warp(13) %}

    // Claimable must be:
    // At t=13 => 5374416 = [(15 - 13) * 4719000 + (13 - 12) * 6685250)] / (15 - 12)
    // At t=12 => 4719000
    // Claimable = 5374416 - 4719000 = 655416
    let (claimed) = CarbonableOffseter.claimed_of(address=context.signers.anyone);
    assert claimed = 3539250;
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 655416;

    %{ stop_warp() %}

    return ();
}

@external
func test_claim_after{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (local contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // At t=0
    %{ stop_warp = warp(0) %}

    // Deposit token #1
    %{ stop_mock = mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;
    %{ stop_mock() %}
    %{ stop_warp() %}

    // At t=3
    %{ stop_warp = warp(365) %}
    // Claimable must be 1573000000
    let (claimable) = CarbonableOffseter.claimable_of(address=context.signers.anyone);
    assert claimable = 1573000000;
    %{ stop_warp() %}

    return ();
}
