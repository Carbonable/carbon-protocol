// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableYielder

// unites are in Wei
const TOTAL_AMOUNT_HIGH = 24663812000000000000000;  // 24663.812 ETH

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare yiler instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let total_amount = TOTAL_AMOUNT_HIGH;

    let cliff_delta = 0;
    let start = 1;
    let duration = 1;
    let slice_period_seconds = 1;
    let revocable = TRUE;

    let (contract_address) = get_contract_address();

    // start period at timestamp = 100
    %{ stop_warp = warp(100) %}
    let unlocked_duration = 30;
    let period_duration = 100;
    let (success) = CarbonableYielder.start_period(
        unlocked_duration=unlocked_duration, period_duration=period_duration
    );
    assert success = TRUE;
    %{ stop_warp() %}

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [2, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}

    // %{ mock_call(context.mocks.starkvest_address, "ownerOf", [ids.contract_address]) %}

    %{ stop=start_prank(context.signers.anyone) %}
    let (success) = CarbonableYielder.deposit(token_id=one);
    assert success = 1;
    let (success) = CarbonableYielder.deposit(token_id=two);
    assert success = 1;
    %{ stop() %}

    // create_vestings at timestamp = 131
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [2, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [2, 0]) %}
    %{ mock_call(context.mocks.starkvest_address, "create_vesting", [123456]) %}
    %{ stop_warp = warp(131) %}
    %{ stop=start_prank(context.signers.admin) %}

    let (success) = CarbonableYielder.create_vestings(
        total_amount=total_amount,
        cliff_delta=cliff_delta,
        start=start,
        duration=duration,
        slice_period_seconds=slice_period_seconds,
        revocable=revocable,
    );
    assert success = 1;
    %{ stop() %}
    %{ stop_warp() %}

    return ();
}
