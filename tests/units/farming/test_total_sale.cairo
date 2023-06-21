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
func test_total_sale{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
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
    %{ mock_call(context.mocks.carbonable_project_address, "getStartTime", [0]) %}

    // Anyone
    %{
        stops = [
            start_prank(context.signers.anyone),
            mock_call(context.mocks.carbonable_project_address, "ownerOf", [context.signers.anyone])
        ]
    %}

    // Deposit token #1
    let (success) = CarbonableFarming.deposit(token_id=one, value=one);
    assert success = 1;

    %{ for stop in stops: stop() %}

    // Cannot mock cumsale build since it computes the diff with getAbsorption twice per iter, which is 0
    let (total_sale) = CarbonableFarming.total_sale();
    assert total_sale = 0;

    let (max_sale) = CarbonableFarming.max_sale();
    assert max_sale = 0;

    let (sale) = CarbonableFarming.sale_of(anyone_address);
    assert sale = 0;

    return ();
}

@external
func test_total_sale_multi_users{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
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
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getStartTime", [0]) %}

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

    // Cannot mock cumsale build since it computes the diff with getAbsorption twice per iter, which is 0
    let (total_sale) = CarbonableFarming.total_sale();
    assert total_sale = 0;

    return ();
}
