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
    let (local contract_address: felt) = get_contract_address();

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [0]) %}
    %{ stop_mock_getAbsorption = mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ stop_mock_getCurrentAbsorption = mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    // Deposit value 1 from token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    %{
        stop_mock_getTotalAbsorption = mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [2000000])
        stop_mock_getAbsorptionOf = mock_call(context.mocks.carbonable_offseter_address, "getAbsorptionOf", [1000000])
        stop_warp = warp(blk_timestamp=100)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.mocks.carbonable_project_address,
            previous_time=0,
            previous_project_absorption=1000000,
            previous_offseter_absorption=0,
            previous_yielder_absorption=0,
            current_time=100,
            current_project_absorption=3000000,
            current_offseter_absorption=2000000,
            current_yielder_absorption=2000000,
            period_project_absorption=2000000,
            period_offseter_absorption=2000000,
            period_yielder_absorption=2000000,
        )))
    %}
    CarbonableYielder.snapshot();
    let (time) = CarbonableYielder.snapshoted_time();
    assert time = 100;

    %{
        stop_warp()
        stop_mock_getAbsorption()
        stop_mock_getCurrentAbsorption()
        stop_mock_getTotalAbsorption()
        stop_mock_getAbsorptionOf()
        mock_call(context.mocks.carbonable_project_address, "getAbsorption", [3000000])
        mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [6000000])
        mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [3000000])
        mock_call(context.mocks.carbonable_offseter_address, "getAbsorptionOf", [3000000])
        store(target_contract_address=ids.contract_address, variable_name="CarbonableYielder_provisioned_", value=[1], )
        stop_warp = warp(blk_timestamp=200)
        expect_events(dict(name="Snapshot", data=dict(
            project=context.mocks.carbonable_project_address,
            previous_time=100,
            previous_project_absorption=3000000,
            previous_offseter_absorption=2000000,
            previous_yielder_absorption=2000000,
            current_time=200,
            current_project_absorption=6000000,
            current_offseter_absorption=3000000,
            current_yielder_absorption=3000000,
            period_project_absorption=3000000,
            period_offseter_absorption=1000000,
            period_yielder_absorption=1000000,
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

    %{
        warp(blk_timestamp=200)
        mock_call(context.mocks.carbonable_project_address, "isSetup", [1])
        expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot or provision if no user has registered")
    %}
    CarbonableYielder.snapshot();
    return ();
}

@external
func test_snapshot_revert_not_possible{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [1000000]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [3000000]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [3000000]) %}

    // Deposit value 1 from token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    %{
        stop_warp = warp(blk_timestamp=0)
        expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot at a sooner time that previous snapshot")
    %}
    CarbonableYielder.snapshot();
    return ();
}

@external
func test_snapshot_revert_no_contribution{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();
    let one = Uint256(low=1, high=0);

    %{ mock_call(context.mocks.carbonable_project_address, "isSetup", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "transferValueFrom", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "balanceOf", [1, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "tokenOfOwnerByIndex", [0, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getProjectValue", [100, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getAbsorption", [0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "getCurrentAbsorption", [0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "ownerOf", [0]) %}
    %{ mock_call(context.mocks.carbonable_offseter_address, "getTotalAbsorption", [0]) %}

    // Deposit value 1 from token #1
    let (success) = CarbonableOffseter.deposit(token_id=one, value=one);
    assert success = 1;

    %{
        stop_warp = warp(blk_timestamp=200)
        expect_revert("TRANSACTION_FAILED", "CarbonableYielder: cannot snapshot if the current yielder contribution is null")
    %}
    CarbonableYielder.snapshot();
    return ();
}
