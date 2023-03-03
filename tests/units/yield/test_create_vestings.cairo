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
func test_create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [2000000]) %}
    %{ mock_call(context.mocks.carbonable_vester_address, "withdrawable_amount", [ids.TOTAL_AMOUNT, 0]) %}
    %{ mock_call(context.mocks.carbonable_vester_address, "create_vesting", [1]) %}

    // Deposit value 1 from token #1
    CarbonableOffseter.deposit(token_id=one, value=one);

    // Snapshot
    %{ stop_warp = warp(blk_timestamp=100) %}
    CarbonableYielder.snapshot();
    %{ stop_warp() %}

    let (success) = CarbonableYielder.create_vestings(
        total_amount=TOTAL_AMOUNT,
        cliff_delta=CLIFF_DELTA,
        start=START,
        duration=DURATION,
        slice_period_seconds=SLICE_PERIOD_SECONDS,
        revocable=REVOCABLE,
    );
    assert success = 1;

    return ();
}

@external
func test_create_vestings_revert_not_snapshoted{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: create vestings must be executed after snapshot") %}
    let (success) = CarbonableYielder.create_vestings(
        total_amount=TOTAL_AMOUNT,
        cliff_delta=CLIFF_DELTA,
        start=START,
        duration=DURATION,
        slice_period_seconds=SLICE_PERIOD_SECONDS,
        revocable=REVOCABLE,
    );
    return ();
}

@external
func test_create_vestings_revert_not_vestable{
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
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [2000000]) %}
    %{ mock_call(context.mocks.carbonable_vester_address, "withdrawable_amount", [ids.TOTAL_AMOUNT - 1, 0]) %}

    // Deposit value 1 from token #1
    CarbonableOffseter.deposit(token_id=one, value=one);

    // Snapshot
    %{ stop_warp = warp(blk_timestamp=100) %}
    CarbonableYielder.snapshot();
    %{ stop_warp() %}

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: not enough unallocated amount into vester") %}
    let (success) = CarbonableYielder.create_vestings(
        total_amount=TOTAL_AMOUNT,
        cliff_delta=CLIFF_DELTA,
        start=START,
        duration=DURATION,
        slice_period_seconds=SLICE_PERIOD_SECONDS,
        revocable=REVOCABLE,
    );
    return ();
}

@external
func test_create_vestings_no_absorption{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [0]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [0]) %}
    %{ mock_call(context.mocks.carbonable_vester_address, "withdrawable_amount", [ids.TOTAL_AMOUNT, 0]) %}

    // Deposit value 1 from token #1
    CarbonableOffseter.deposit(token_id=one, value=one);

    // Snapshot
    %{ stop_warp = warp(blk_timestamp=100) %}
    CarbonableYielder.snapshot();
    %{ stop_warp() %}

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot vest if the total yielder contribution is null") %}
    let (success) = CarbonableYielder.create_vestings(
        total_amount=TOTAL_AMOUNT,
        cliff_delta=CLIFF_DELTA,
        start=START,
        duration=DURATION,
        slice_period_seconds=SLICE_PERIOD_SECONDS,
        revocable=REVOCABLE,
    );
    return ();
}
