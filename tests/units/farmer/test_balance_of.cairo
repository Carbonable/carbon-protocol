// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.farmer.library import setup, prepare, CarbonableFarmer

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_share{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let zero = Uint256(low=0, high=0);
    let one = Uint256(low=1, high=0);
    let ten = Uint256(low=10, high=0);
    let hundred = Uint256(low=100, high=0);
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}

    %{ stop=start_prank(context.signers.anyone) %}
    let (success) = CarbonableFarmer.deposit(token_id=one);
    assert success = 1;
    %{ stop() %}

    let (balance) = CarbonableFarmer.balance_of(address=context.signers.anyone);
    assert balance = 1;

    let (balance) = CarbonableFarmer.balance_of(address=context.signers.admin);
    assert balance = 0;

    return ();
}
