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
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;
    let admin_address = context.signers.admin;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone deposit

    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}
    CarbonableOffseter.deposit(token_id=one, value=two);
    %{ for stop in stops: stop() %}

    let (count) = CarbonableOffseter.total_user_count();
    assert count = 1;

    let (user) = CarbonableOffseter.user_by_index(index=count - 1);
    assert user = anyone_address;

    // Admin deposit

    %{
        stops = [
            start_prank(context.signers.admin),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.admin])
        ]
    %}
    CarbonableOffseter.deposit(token_id=two, value=one);
    %{ for stop in stops: stop() %}

    let (count) = CarbonableOffseter.total_user_count();
    assert count = 2;

    let (user) = CarbonableOffseter.user_by_index(index=count - 1);
    assert user = admin_address;

    %{
        stops = [
            start_prank(context.signers.admin),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.admin])
        ]
    %}
    CarbonableOffseter.deposit(token_id=two, value=one);
    %{ for stop in stops: stop() %}

    let (count) = CarbonableOffseter.total_user_count();
    assert count = 2;

    let (user) = CarbonableOffseter.user_by_index(index=count - 1);
    assert user = admin_address;

    // Anyone withdraw 50%

    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}
    CarbonableOffseter.withdraw_to(value=one);
    %{ for stop in stops: stop() %}

    let (count) = CarbonableOffseter.total_user_count();
    assert count = 2;

    let (user) = CarbonableOffseter.user_by_index(index=count - 1);
    assert user = admin_address;

    // Anyone withdraw 100%

    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}
    CarbonableOffseter.withdraw_to(value=one);
    %{ for stop in stops: stop() %}

    let (count) = CarbonableOffseter.total_user_count();
    assert count = 2;

    let (user) = CarbonableOffseter.user_by_index(index=count - 1);
    assert user = admin_address;

    return ();
}
