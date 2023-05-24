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
func test_total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 0;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    // Claim
    let (success) = CarbonableOffseter.claim(quantity=1000000);
    assert success = 1;

    // Total claimable is 1;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 1000000;

    let (claimed) = CarbonableOffseter.claimed_of(anyone_address);
    assert claimed = total_claimed;

    // Claim
    let (success) = CarbonableOffseter.claim_all();
    assert success = 1;

    // Total claimed is 1 + (3 - 1) - 1 = 2 / 1;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 2000000;

    let (claimed) = CarbonableOffseter.claimed_of(anyone_address);
    assert claimed = total_claimed;

    %{ stop() %}

    return ();
}

@external
func test_total_claimed_multi_users{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
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
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [1, 0]) %}
    %{ stop_mock_1 = mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ stop_mock_2 = mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}
    // Deposit 1 from token #1 and claim
    CarbonableOffseter.deposit(token_id=one, value=one);
    CarbonableOffseter.claim(quantity=1000000);
    %{ stop() %}

    // Admin
    %{ stop=start_prank(context.signers.admin) %}
    // Deposit 1 from token #2 and claim
    CarbonableOffseter.deposit(token_id=two, value=one);
    CarbonableOffseter.claim(quantity=1000000);
    %{ stop() %}

    // Someone
    %{ stop=start_prank(context.signers.someone) %}
    // Deposit 1 from token #3 and claim
    CarbonableOffseter.deposit(token_id=three, value=one);
    CarbonableOffseter.claim(quantity=1000000);
    %{ stop() %}

    // Total claimed is 3000000;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 3000000;

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
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [1999999]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 0;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    // Claim
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableOffseter: claimable balance must be not negligible") %}
    let (success) = CarbonableOffseter.claim_all();
    assert success = 1;

    %{ stop() %}

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
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}

    // Anyone
    %{ stop=start_prank(context.signers.anyone) %}

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    // Total claimable is 0;
    let (total_claimed) = CarbonableOffseter.total_claimed();
    assert total_claimed = 0;

    // Claim
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableOffseter: quantity to claim must be lower than the total claimable") %}
    let (success) = CarbonableOffseter.claim(quantity=3000000);

    %{ stop() %}

    return ();
}
