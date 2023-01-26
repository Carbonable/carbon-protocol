// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.interfaces.yielder import ICarbonableYielder

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (carbonable_yielder_contract: felt) {
        tempvar carbonable_yielder_contract;
        %{ ids.carbonable_yielder_contract = context.carbonable_yielder_contract %}
        return (carbonable_yielder_contract=carbonable_yielder_contract);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableYielder.getCarbonableProjectAddress(
            contract_address=carbonable_yielder
        );
        return (carbonable_project_address=carbonable_project_address);
    }

    func carbonable_offseter_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (carbonable_offseter_address: felt) {
        let (carbonable_offseter_address) = ICarbonableYielder.getCarbonableOffseterAddress(
            contract_address=carbonable_yielder
        );
        return (carbonable_offseter_address=carbonable_offseter_address);
    }

    func carbonable_vester_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (carbonable_vester_address: felt) {
        let (carbonable_vester_address) = ICarbonableYielder.getCarbonableVesterAddress(
            contract_address=carbonable_yielder
        );
        return (carbonable_vester_address=carbonable_vester_address);
    }

    func total_deposited{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (balance: Uint256) {
        let (balance) = ICarbonableYielder.getTotalDeposited(contract_address=carbonable_yielder);
        return (balance=balance);
    }

    func total_absorption{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (total_absorption: felt) {
        let (total_absorption) = ICarbonableYielder.getTotalAbsorption(
            contract_address=carbonable_yielder
        );
        return (total_absorption=total_absorption);
    }

    func absorption_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(address: felt) -> (absorption: felt) {
        let (absorption) = ICarbonableYielder.getAbsorptionOf(
            contract_address=carbonable_yielder, address=address
        );
        return (absorption=absorption);
    }

    func registered_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256) -> (address: felt) {
        let (address) = ICarbonableYielder.getRegisteredOwnerOf(
            contract_address=carbonable_yielder, token_id=token_id
        );
        return (address=address);
    }

    func registered_time_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256) -> (time: felt) {
        let (time) = ICarbonableYielder.getRegisteredTimeOf(
            contract_address=carbonable_yielder, token_id=token_id
        );
        return (time=time);
    }

    func registered_tokens_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (tokens_len: felt, tokens: Uint256*) {
        let (tokens_len, tokens) = ICarbonableYielder.getRegisteredTokensOf(
            contract_address=carbonable_offseter, address=address
        );
        return (tokens_len=tokens_len, tokens=tokens);
    }

    func snapshoted_time{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (time: felt) {
        let (time) = ICarbonableYielder.getSnapshotedTime(contract_address=carbonable_yielder);
        return (time=time);
    }

    func snapshoted_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(address: felt) -> (absorption: felt) {
        let (absorption) = ICarbonableYielder.getSnapshotedOf(address);
        return (absorption=absorption);
    }

    func get_snapshoter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(caller: felt) -> (snapshoter: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (snapshoter) = ICarbonableYielder.getSnapshoter(carbonable_yielder);
        %{ stop_prank() %}
        return (snapshoter);
    }

    // Externals

    func set_snapshoter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(snapshoter: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        ICarbonableYielder.setSnapshoter(carbonable_yielder, snapshoter);
        %{ stop_prank() %}
        return ();
    }

    func deposit{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (success) = ICarbonableYielder.deposit(carbonable_yielder, token_id);
        %{ stop_prank() %}
        return (success=success);
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (success) = ICarbonableYielder.withdraw(carbonable_yielder, token_id);
        %{ stop_prank() %}
        return (success=success);
    }

    func snapshot{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (success) = ICarbonableYielder.snapshot(contract_address=carbonable_yielder);
        %{ stop_prank() %}
        return (success=success);
    }

    func create_vestings{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        caller: felt,
    ) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (success) = ICarbonableYielder.createVestings(
            contract_address=carbonable_yielder,
            total_amount=total_amount,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
        );
        %{ stop_prank() %}
        return (success=success);
    }
}
