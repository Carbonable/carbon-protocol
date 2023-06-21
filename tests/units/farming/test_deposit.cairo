// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.farming.library import setup, prepare, CarbonableFarming

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let four = Uint256(low=4, high=0);
    let anyone_address = context.signers.anyone;
    let admin_address = context.signers.admin;

    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Simple deposit

    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}
    let (success) = CarbonableFarming.deposit(token_id=one, value=two);
    assert success = 1;
    %{ for stop in stops: stop() %}

    let (deposited) = CarbonableFarming.deposited_of(address=anyone_address);
    assert deposited = two;

    // Double deposit

    %{
        stops = [
            start_prank(context.signers.admin),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.admin])
        ]
    %}
    let (success) = CarbonableFarming.deposit(token_id=two, value=one);
    assert success = 1;

    let (deposited) = CarbonableFarming.deposited_of(address=admin_address);
    assert deposited = one;

    let (success) = CarbonableFarming.deposit(token_id=two, value=one);
    assert success = 1;

    let (deposited) = CarbonableFarming.deposited_of(address=admin_address);
    assert deposited = two;

    let (deposited) = CarbonableFarming.total_deposited();
    assert deposited = four;
    %{ stop() %}

    return ();
}

@external
func test_deposit_revert_token_not_u256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarming: token_id is not a valid Uint256") %}
    let two = Uint256(low=2, high=0);
    let invalid = Uint256(low=-1, high=-1);
    let (success) = CarbonableFarming.deposit(token_id=invalid, value=two);

    return ();
}

@external
func test_deposit_revert_value_not_u256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarming: value is not a valid Uint256") %}
    let two = Uint256(low=2, high=0);
    let invalid = Uint256(low=-1, high=-1);
    let (success) = CarbonableFarming.deposit(token_id=two, value=invalid);

    return ();
}

@external
func test_deposit_revert_value_is_zero{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableFarming: value is null") %}
    let zero = Uint256(low=0, high=0);
    let (success) = CarbonableFarming.deposit(token_id=zero, value=zero);

    return ();
}
