// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.interfaces.vester import ICarbonableVester

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (carbonable_vester_contract: felt) {
        tempvar carbonable_vester_contract;
        %{ ids.carbonable_vester_contract = context.carbonable_vester_contract %}
        return (carbonable_vester_contract,);
    }

    // Views

    func withdrawable_amount{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(caller: felt) -> (releasable_amount: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (releasable_amount) = ICarbonableVester.withdrawable_amount(carbonable_vester);
        %{ stop_prank() %}
        return (releasable_amount,);
    }

    func vesting_count{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(caller: felt) -> (vesting_count: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (vesting_count) = ICarbonableVester.vesting_count(carbonable_vester, caller);
        %{ stop_prank() %}
        return (vesting_count,);
    }

    func get_vesting_id{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(vesting_index: felt, caller: felt) -> (vesting_id: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (vesting_id) = ICarbonableVester.get_vesting_id(
            carbonable_vester, caller, vesting_index
        );
        %{ stop_prank() %}
        return (vesting_id,);
    }

    func releasable_amount{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(vesting_id: felt, caller: felt) -> (releasable_amount: Uint256) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (releasable_amount) = ICarbonableVester.releasable_amount(
            carbonable_vester, vesting_id
        );
        %{ stop_prank() %}
        return (releasable_amount=releasable_amount);
    }

    func releasable_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(account: felt, caller: felt) -> (releasable_amount: Uint256) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (releasable_amount) = ICarbonableVester.releasableOf(carbonable_vester, account);
        %{ stop_prank() %}
        return (releasable_amount=releasable_amount);
    }

    func released_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(account: felt, caller: felt) -> (released_amount: Uint256) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (released_amount) = ICarbonableVester.releasedOf(carbonable_vester, account);
        %{ stop_prank() %}
        return (released_amount=released_amount);
    }

    func get_vesters{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(caller: felt) -> (vesters_len: felt, vesters: felt*) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (vesters_len, vesters) = ICarbonableVester.getVesters(carbonable_vester);
        %{ stop_prank() %}
        return (vesters_len, vesters);
    }

    // Externals

    func add_vester{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(vester: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        ICarbonableVester.addVester(carbonable_vester, vester);
        %{ stop_prank() %}
        return ();
    }

    func revoke_vester{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(vester: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        ICarbonableVester.revokeVester(carbonable_vester, vester);
        %{ stop_prank() %}
        return ();
    }

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(newOwner: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        ICarbonableVester.transferOwnership(carbonable_vester, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func create_vesting{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(
        beneficiary: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        amount_total: Uint256,
        caller: felt,
    ) -> (vesting_id: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        let (vesting_id) = ICarbonableVester.create_vesting(
            carbonable_vester,
            beneficiary,
            cliff_delta,
            start,
            duration,
            slice_period_seconds,
            revocable,
            amount_total,
        );
        %{ stop_prank() %}
        return (vesting_id,);
    }

    func release_all{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_vester: felt
    }(caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_vester) %}
        ICarbonableVester.releaseAll(carbonable_vester);
        %{ stop_prank() %}
        return ();
    }
}
