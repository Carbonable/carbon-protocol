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
func test_snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let zero = Uint256(low=0, high=0);
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let (contract_address) = get_contract_address();

    // start period at timestamp = 100
    %{ stop_warp = warp(100) %}
    let unlocked_duration = 30;
    let period_duration = 100;
    let (success) = CarbonableOffseter.start_period(
        unlocked_duration=unlocked_duration, period_duration=period_duration, absorption=2
    );
    assert success = TRUE;
    %{ stop_warp() %}

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}

    %{ stop=start_prank(context.signers.anyone) %}
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;
    %{ stop() %}

    // snapshot at timestamp = 131
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}
    %{ stop_warp = warp(131) %}
    %{ stop=start_prank(context.signers.admin) %}
    let (success) = CarbonableOffseter.snapshot();
    assert success = 1;
    %{ stop() %}
    %{ stop_warp() %}

    %{ stop=start_prank(context.signers.anyone) %}
    let (success) = CarbonableOffseter.offset();
    assert success = 1;
    %{ stop() %}

    let (total_offseted) = CarbonableOffseter.total_offseted(context.signers.anyone);
    assert total_offseted = two;

    let (total_offsetable) = CarbonableOffseter.total_offsetable(context.signers.anyone);
    assert total_offsetable = zero;

    return ();
}
