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
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // Total claimable is 0
    let (total_claimable) = CarbonableOffseter.total_claimable();
    assert total_claimable = 0;

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 3 - 1 = 2 / 100
    let (total_claimable) = CarbonableOffseter.total_claimable();
    assert total_claimable = 20000;

    let (claimable) = CarbonableOffseter.claimable_of(anyone_address);
    assert claimable = total_claimable;
    %{ stop() %}

    return ();
}

@external
func test_total_claimable_multi_users{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let three = Uint256(low=3, high=0);
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [1, 0]) %}
    %{ stop_mock_1 = mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ stop_mock_2 = mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}
    // Deposit 1 from token #1 and claim
    CarbonableOffseter.deposit(token_id=one, value=one);
    %{ stop() %}

    // Admin
    %{ stop=start_prank(context.signers.admin) %}
    // Deposit 1 from token #2 and claim
    CarbonableOffseter.deposit(token_id=two, value=one);
    %{ stop() %}

    // Someone
    %{ stop=start_prank(context.signers.someone) %}
    // Deposit 1 from token #3 and claim
    CarbonableOffseter.deposit(token_id=three, value=one);
    %{ stop() %}

    // Total claimable is 6000000;
    let (total_claimable) = CarbonableOffseter.total_claimable();
    assert total_claimable = 6000000;

    return ();
}
