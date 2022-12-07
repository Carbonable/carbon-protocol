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
func test_total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [9999999]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // At t=0
    %{ stop_warp=warp(blk_timestamp=0) %}

    // Total claimable is 0
    let (total_claimable) = CarbonableOffseter.total_claimable();
    assert total_claimable = 0;
    %{ stop_warp() %}

    // At t=357
    %{ stop_warp=warp(blk_timestamp=357) %}

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;
    %{ stop_warp() %}

    // At t=1000
    %{ stop_warp=warp(blk_timestamp=1000) %}

    // Total claimable is 0 because of mock feature
    let (total_claimable) = CarbonableOffseter.total_claimable();
    assert total_claimable = 0;
    %{ stop_warp() %}
    %{ stop() %}

    return ();
}
