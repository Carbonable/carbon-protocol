// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableOffseter, CarbonableYielder

const TOTAL_AMOUNT = 24663812000000000000000;  // 24663.812 ETH
const CLIFF_DELTA = 0;
const START = 1;
const DURATION = 1;
const SLICE_PERIOD_SECONDS = 1;
const REVOCABLE = TRUE;

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [2000000]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.payment_token_address, "transfer", [1]) %}

    // Deposit value 1 from token #1
    %{ stop=start_prank(context.signers.anyone) %}
    CarbonableOffseter.deposit(token_id=one, value=one);

    let (claimable) = CarbonableYielder.claimable_of(anyone_address);
    assert claimable = 0;

    // Snapshot
    %{ stop_warp = warp(blk_timestamp=100) %}
    CarbonableYielder.snapshot();
    %{ stop_warp() %}

    let (success) = CarbonableYielder.provision(amount=TOTAL_AMOUNT);
    assert success = 1;

    let (claimable) = CarbonableYielder.claimable_of(anyone_address);
    assert claimable = TOTAL_AMOUNT;

    let (success) = CarbonableYielder.claim();
    assert success = 1;

    let (claimed) = CarbonableYielder.claimed_of(anyone_address);
    assert claimable = claimed;

    let (claimable) = CarbonableYielder.claimable_of(anyone_address);
    assert claimable = 0;

    %{ stop() %}
    return ();
}

@external
func test_claim_revert_nothing_to_claim{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [2000000]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.payment_token_address, "transfer", [1]) %}

    // Deposit value 1 from token #1
    %{ stop=start_prank(context.signers.anyone) %}
    CarbonableOffseter.deposit(token_id=one, value=one);

    // Snapshot
    %{ stop_warp = warp(blk_timestamp=100) %}
    CarbonableYielder.snapshot();
    %{ stop_warp() %}

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: nothing to claim") %}
    let (success) = CarbonableYielder.claim();

    %{ stop() %}
    return ();
}

@external
func test_claim_revert_transfer_failed{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();
    let anyone_address = context.signers.anyone;

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [2000000]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.payment_token_address, "transfer", [0]) %}

    // Deposit value 1 from token #1
    %{ stop=start_prank(context.signers.anyone) %}
    CarbonableOffseter.deposit(token_id=one, value=one);

    // Snapshot
    %{ stop_warp = warp(blk_timestamp=100) %}
    CarbonableYielder.snapshot();
    %{ stop_warp() %}

    let (success) = CarbonableYielder.provision(amount=TOTAL_AMOUNT);
    assert success = 1;

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: transfer failed") %}
    let (success) = CarbonableYielder.claim();

    %{ stop() %}
    return ();
}
