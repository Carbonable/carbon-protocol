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
func test_total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 0;
    let (total_absorption) = CarbonableOffseter.total_absorption();
    assert total_absorption = 2000000;

    let (absorption) = CarbonableOffseter.absorption_of(anyone_address);
    assert absorption = total_absorption;

    // Claim
    let (success) = CarbonableOffseter.claim(quantity=1000000);
    assert success = 1;

    // Total claimable is 1;
    let (total_absorption) = CarbonableOffseter.total_absorption();
    assert total_absorption = 2000000;

    let (absorption) = CarbonableOffseter.absorption_of(anyone_address);
    assert absorption = total_absorption;

    %{ stop() %}

    return ();
}