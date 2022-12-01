// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableYielder

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}
    %{ stop_mock = mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}

    %{ stop=start_prank(context.signers.anyone) %}
    let (success) = CarbonableYielder.deposit(token_id=one);
    assert success = 1;
    %{ stop() %}

    %{ stop=start_prank(context.signers.admin) %}
    let (success) = CarbonableYielder.deposit(token_id=two);
    assert success = 1;
    %{ stop() %}

    %{ stop_mock() %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [2, 0]) %}

    let (balance) = CarbonableYielder.total_locked();
    assert balance = Uint256(low=2, high=0);

    let (owner) = CarbonableYielder.registred_owner_of(one);
    assert owner = context.signers.anyone;

    let (owner) = CarbonableYielder.registred_owner_of(two);
    assert owner = context.signers.admin;

    return ();
}
