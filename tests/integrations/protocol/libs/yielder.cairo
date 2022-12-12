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
        return ICarbonableYielder.getCarbonableProjectAddress(contract_address=carbonable_yielder);
    }

    func carbonable_offseter_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (carbonable_offseter_address: felt) {
        return ICarbonableYielder.getCarbonableOffseterAddress(contract_address=carbonable_yielder);
    }

    func carbonable_vester_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (carbonable_vester_address: felt) {
        return ICarbonableYielder.getCarbonableVesterAddress(contract_address=carbonable_yielder);
    }

    func is_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (status: felt) {
        return ICarbonableYielder.isOpen(contract_address=carbonable_yielder);
    }

    func total_deposited{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (balance: Uint256) {
        return ICarbonableYielder.getTotalDeposited(contract_address=carbonable_yielder);
    }

    func total_claimed{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (total_claimed: felt) {
        return ICarbonableYielder.getTotalClaimed(contract_address=carbonable_yielder);
    }

    func total_claimable{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (total_claimable: felt) {
        return ICarbonableYielder.getTotalClaimable(contract_address=carbonable_yielder);
    }

    func claimable_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(address: felt) -> (claimable: felt) {
        return ICarbonableYielder.getClaimableOf(
            contract_address=carbonable_yielder, address=address
        );
    }

    func claimed_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(address: felt) -> (claimed: felt) {
        return ICarbonableYielder.getClaimedOf(
            contract_address=carbonable_yielder, address=address
        );
    }

    func registered_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256) -> (address: felt) {
        return ICarbonableYielder.getRegisteredOwnerOf(
            contract_address=carbonable_yielder, token_id=token_id
        );
    }

    func registered_time_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256) -> (time: felt) {
        return ICarbonableYielder.getRegisteredTimeOf(
            contract_address=carbonable_yielder, token_id=token_id
        );
    }

    func snapshoted_time{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (time: felt) {
        return ICarbonableYielder.getSnapshotedTime(contract_address=carbonable_yielder);
    }

    // Externals

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
