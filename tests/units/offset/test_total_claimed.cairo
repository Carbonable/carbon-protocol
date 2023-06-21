// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.offset.library import setup, prepare, CarbonableFarming, CarbonableOffseter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
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

    // Deposit token #1
    let (success) = CarbonableFarming.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 0;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    // Claim
    CarbonableOffseter.claim(quantity=1000000);

    // Total claimable is 1;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 1000000;

    let (claimed) = CarbonableOffseter.claimed_of(anyone_address);
    assert claimed = total_claimed;

    // Claim
    CarbonableOffseter.claim_all();

    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 2000000;

    let (claimed) = CarbonableOffseter.claimed_of(anyone_address);
    assert claimed = total_claimed;

    %{ for stop in stops: stop() %}

    return ();
}

@external
func test_claimed_revert_claimable_negligible{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [1999999]) %}

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

    // Total claimable is 0;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    // Claim
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableOffseter: quantity must be not negligible") %}
    CarbonableOffseter.claim_all();

    %{ for stop in stops: stop() %}

    return ();
}

@external
func test_claimed_revert_too_high_quantity{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
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

    // Deposit token #1
    let (success) = CarbonableFarming.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 0;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    // Claim
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableOffseter: claim quantity too high") %}
    CarbonableOffseter.claim(quantity=3000000);

    %{ for stop in stops: stop() %}

    return ();
}
