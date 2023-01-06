// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.interfaces.offseter import ICarbonableOffseter

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (carbonable_offseter_contract: felt) {
        tempvar carbonable_offseter_contract;
        %{ ids.carbonable_offseter_contract = context.carbonable_offseter_contract %}
        return (carbonable_offseter_contract=carbonable_offseter_contract);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableOffseter.getCarbonableProjectAddress(
            carbonable_offseter
        );
        return (carbonable_project_address=carbonable_project_address);
    }

    func total_deposited{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (balance: Uint256) {
        let (balance) = ICarbonableOffseter.getTotalDeposited(contract_address=carbonable_offseter);
        return (balance=balance);
    }

    func total_claimed{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (total_claimed: felt) {
        let (total_claimed) = ICarbonableOffseter.getTotalClaimed(
            contract_address=carbonable_offseter
        );
        return (total_claimed=total_claimed);
    }

    func total_claimable{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (total_claimable: felt) {
        let (total_claimable) = ICarbonableOffseter.getTotalClaimable(
            contract_address=carbonable_offseter
        );
        return (total_claimable=total_claimable);
    }

    func claimable_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (claimable: felt) {
        let (claimable) = ICarbonableOffseter.getClaimableOf(
            contract_address=carbonable_offseter, address=address
        );
        return (claimable=claimable);
    }

    func claimed_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (claimed: felt) {
        let (claimed) = ICarbonableOffseter.getClaimedOf(
            contract_address=carbonable_offseter, address=address
        );
        return (claimed=claimed);
    }

    func registered_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256) -> (address: felt) {
        let (address) = ICarbonableOffseter.getRegisteredOwnerOf(
            contract_address=carbonable_offseter, token_id=token_id
        );
        return (address=address);
    }

    func registered_time_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256) -> (time: felt) {
        let (time) = ICarbonableOffseter.getRegisteredTimeOf(
            contract_address=carbonable_offseter, token_id=token_id
        );
        return (time=time);
    }

    func registered_tokens_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (tokens_len: felt, tokens: Uint256*) {
        let (tokens_len, tokens) = ICarbonableOffseter.getRegisteredTokensOf(
            contract_address=carbonable_offseter, address=address
        );
        return (tokens_len=tokens_len, tokens=tokens);
    }

    func owner{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (owner: felt) {
        let (owner) = ICarbonableOffseter.owner(contract_address=carbonable_offseter);
        return (owner=owner);
    }

    // Externals

    func claim{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.claim(
            contract_address=carbonable_offseter, quantity=quantity
        );
        %{ stop_prank_offseter() %}
        return (success=success);
    }

    func claim_all{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.claimAll(contract_address=carbonable_offseter);
        %{ stop_prank_offseter() %}
        return (success=success);
    }

    func deposit{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256, caller: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.deposit(carbonable_offseter, token_id);
        %{ stop_prank_offseter() %}
        return (success=success);
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256, caller: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.withdraw(carbonable_offseter, token_id);
        %{ stop_prank_offseter() %}
        return (success=success);
    }

    func transferOwnership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(newOwner: felt, caller: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        ICarbonableOffseter.transferOwnership(
            contract_address=carbonable_offseter, newOwner=newOwner
        );
        %{ stop_prank_offseter() %}
        return ();
    }

    func renounceOwnership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(caller: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        ICarbonableOffseter.renounceOwnership(contract_address=carbonable_offseter);
        %{ stop_prank_offseter() %}
        return ();
    }
}
