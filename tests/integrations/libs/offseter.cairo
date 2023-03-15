// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.interfaces.offseter import ICarbonableOffseter
from src.utils.type.library import _felt_to_uint, _uint_to_felt

//
// Functions
//

namespace instance {
    // Internals

    func get_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        contract_address: felt
    ) {
        tempvar contract_address;
        %{ ids.contract_address = context.carbonable_offseter_contract %}
        return (contract_address,);
    }

    //
    // Proxy administration
    //

    func get_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (implementation: felt) {
        let (contract_address) = instance.get_address();
        let (implementation) = ICarbonableOffseter.getImplementationHash(
            contract_address=contract_address
        );
        return (implementation,);
    }

    func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        admin: felt
    ) {
        let (contract_address) = instance.get_address();
        let (admin) = ICarbonableOffseter.getAdmin(contract_address);
        return (admin,);
    }

    func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_implementation: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableOffseter.upgrade(contract_address, new_implementation);
        %{ stop_prank() %}
        return ();
    }

    func set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_admin: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableOffseter.setAdmin(contract_address, new_admin);
        %{ stop_prank() %}
        return ();
    }

    //
    // Ownership administration
    //

    func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
        let (contract_address) = instance.get_address();
        let (owner) = ICarbonableOffseter.owner(contract_address);
        return (owner,);
    }

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(newOwner: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableOffseter.transferOwnership(contract_address, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func renounce_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }() {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableOffseter.renounceOwnership(contract_address);
        %{ stop_prank() %}
        return ();
    }

    //
    // Getters
    //

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (contract_address) = instance.get_address();
        let (carbonable_project_address) = ICarbonableOffseter.getCarbonableProjectAddress(
            contract_address
        );
        return (carbonable_project_address,);
    }

    func carbonable_project_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (slot: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = ICarbonableOffseter.getCarbonableProjectSlot(
            contract_address=contract_address
        );
        let (slot) = _uint_to_felt(slot_u256);
        return (slot,);
    }

    func get_min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        min_claimable: felt
    ) {
        let (contract_address) = instance.get_address();
        let (min_claimable) = ICarbonableOffseter.getMinClaimable(
            contract_address=contract_address
        );
        return (min_claimable,);
    }

    func get_total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (value_u256) = ICarbonableOffseter.getTotalDeposited(contract_address=contract_address);
        let (value) = _uint_to_felt(value_u256);
        return (value,);
    }

    func get_total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (total_absorption: felt) {
        let (contract_address) = instance.get_address();
        let (total_absorption) = ICarbonableOffseter.getTotalAbsorption(
            contract_address=contract_address
        );
        return (total_absorption,);
    }

    func get_total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_claimed: felt
    ) {
        let (contract_address) = instance.get_address();
        let (total_claimed) = ICarbonableOffseter.getTotalClaimed(
            contract_address=contract_address
        );
        return (total_claimed,);
    }

    func get_total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_claimable: felt
    ) {
        let (contract_address) = instance.get_address();
        let (total_claimable) = ICarbonableOffseter.getTotalClaimable(
            contract_address=contract_address
        );
        return (total_claimable,);
    }

    func get_deposited_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (value: felt) {
        let (contract_address) = instance.get_address();
        let (value_u256) = ICarbonableOffseter.getDepositedOf(
            contract_address=contract_address, address=address
        );
        let (value) = _uint_to_felt(value_u256);
        return (value,);
    }

    func get_absorption_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        let (contract_address) = instance.get_address();
        let (absorption) = ICarbonableOffseter.getAbsorptionOf(
            contract_address=contract_address, address=address
        );
        return (absorption,);
    }

    func get_claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        let (contract_address) = instance.get_address();
        let (claimable) = ICarbonableOffseter.getClaimableOf(
            contract_address=contract_address, address=address
        );
        return (claimable,);
    }

    func get_claimed_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimed: felt) {
        let (contract_address) = instance.get_address();
        let (claimed) = ICarbonableOffseter.getClaimedOf(
            contract_address=contract_address, address=address
        );
        return (claimed,);
    }

    //
    // Externals
    //

    func set_min_claimable{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(min_claimable: felt) -> () {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableOffseter.setMinClaimable(
            contract_address=contract_address, min_claimable=min_claimable
        );
        %{ stop_prank() %}
        return ();
    }

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        quantity: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableOffseter.claim(
            contract_address=contract_address, quantity=quantity
        );
        %{ stop_prank() %}
        return (success,);
    }

    func claim_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableOffseter.claimAll(contract_address=contract_address);
        %{ stop_prank() %}
        return (success,);
    }

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        token_id: felt, value: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableOffseter.deposit(
            contract_address=contract_address, token_id=token_id_u256, value=value_u256
        );
        %{ stop_prank() %}
        return (success,);
    }

    func withdraw_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        value: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableOffseter.withdrawTo(
            contract_address=contract_address, value=value_u256
        );
        %{ stop_prank() %}
        return (success,);
    }

    func withdraw_to_token{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(token_id: felt, value: felt) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableOffseter.withdrawToToken(
            contract_address=contract_address, token_id=token_id_u256, value=value_u256
        );
        %{ stop_prank() %}
        return (success,);
    }
}
