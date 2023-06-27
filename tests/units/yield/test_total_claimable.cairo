// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableFarming, CarbonableYielder

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
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}

    // Total claimable is 0
    let (total_claimable) = CarbonableYielder.total_claimable();
    assert total_claimable = 0;

    // Deposit token #1
    let (success) = CarbonableFarming.deposit(token_id=one, value=one);
    assert success = 1;

    let (total_claimable) = CarbonableYielder.total_claimable();
    assert total_claimable = 0;

    let (claimable) = CarbonableYielder.claimable_of(anyone_address);
    assert claimable = total_claimable;
    %{ for stop in stops: stop() %}

    return ();
}

@external
func test_total_claimable_multi_users{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let two = Uint256(low=2, high=0);
    let three = Uint256(low=3, high=0);
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [3, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}
    // Deposit 1 from token #1 and claim
    CarbonableFarming.deposit(token_id=one, value=one);
    %{ for stop in stops: stop() %}

    // Admin
    %{
        stops = [
            start_prank(context.signers.admin),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.admin])
        ]
    %}
    // Deposit 1 from token #2 and claim
    CarbonableFarming.deposit(token_id=two, value=one);
    %{ for stop in stops: stop() %}

    // Someone
    %{
        stops = [
            start_prank(context.signers.someone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.someone])
        ]
    %}
    // Deposit 1 from token #3 and claim
    CarbonableFarming.deposit(token_id=three, value=one);
    %{ for stop in stops: stop() %}

    let (total_claimable) = CarbonableYielder.total_claimable();
    assert total_claimable = 0;

    return ();
}
