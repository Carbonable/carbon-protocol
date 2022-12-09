// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableOffseter, CarbonableYielder

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);
    let (contract_address) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenByIndex", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [ids.contract_address]) %}

    %{ stop_mock_getAbsorption = mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1]) %}
    %{ stop_mock_getCurrentAbsorption = mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3]) %}

    // Deposit token #1
    let (success) = CarbonableOffseter.deposit(token_id=one);
    assert success = 1;

    %{
        stop_mock_getTotalClaimable = mock_call(context.mocks.carbonable_offseter_address, "getTotalClaimable", [1])
        stop_mock_getTotalClaimed = mock_call(context.mocks.carbonable_offseter_address, "getTotalClaimed", [1])
        stop_warp = warp(blk_timestamp=100)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.mocks.carbonable_project_address,
            previous_time=0,
            previous_project_absorption=1,
            previous_offseter_absorption=0,
            previous_yielder_absorption=0,
            current_time=100,
            current_project_absorption=3,
            current_offseter_absorption=2,
            current_yielder_absorption=2,
            period_project_absorption=2,
            period_offseter_absorption=2,
            period_yielder_absorption=2,
        )))
    %}
    CarbonableYielder.snapshot();
    let (time) = CarbonableYielder.snapshoted_time();
    assert time = 100;

    %{
        stop_warp()
        stop_mock_getAbsorption()
        stop_mock_getCurrentAbsorption()
        stop_mock_getTotalClaimable()
        stop_mock_getTotalClaimed()
        stop_mock_getAbsorption = mock_call(context.mocks.carbonable_project_address, "getAbsorption", [3])
        stop_mock_getCurrentAbsorption = mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [6])
        stop_mock_getTotalClaimable = mock_call(context.mocks.carbonable_offseter_address, "getTotalClaimable", [1])
        stop_mock_getTotalClaimed = mock_call(context.mocks.carbonable_offseter_address, "getTotalClaimed", [2])
        stop_warp = warp(blk_timestamp=200)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.mocks.carbonable_project_address,
            previous_time=100,
            previous_project_absorption=3,
            previous_offseter_absorption=2,
            previous_yielder_absorption=2,
            current_time=200,
            current_project_absorption=6,
            current_offseter_absorption=3,
            current_yielder_absorption=3,
            period_project_absorption=3,
            period_offseter_absorption=1,
            period_yielder_absorption=1,
        )))
    %}
    CarbonableYielder.snapshot();
    let (time) = CarbonableYielder.snapshoted_time();
    assert time = 200;

    return ();
}

@external
func test_snapshot_revert_not_snapshotable{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot or create vestings if no user has registered") %}
    CarbonableYielder.snapshot();
    return ();
}
