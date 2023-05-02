// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.interfaces.yielder import ICarbonableYielder
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
        %{ ids.contract_address = context.carbonable_yielder_contract %}
        return (contract_address,);
    }

    //
    // Proxy administration
    //

    func get_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (implementation: felt) {
        let (contract_address) = instance.get_address();
        let (implementation) = ICarbonableYielder.getImplementationHash(
            contract_address=contract_address
        );
        return (implementation,);
    }

    func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        admin: felt
    ) {
        let (contract_address) = instance.get_address();
        let (admin) = ICarbonableYielder.getAdmin(contract_address);
        return (admin,);
    }

    func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_implementation: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableYielder.upgrade(contract_address, new_implementation);
        %{ stop_prank() %}
        return ();
    }

    func set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_admin: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableYielder.setAdmin(contract_address, new_admin);
        %{ stop_prank() %}
        return ();
    }

    //
    // Ownership administration
    //

    func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
        let (contract_address) = instance.get_address();
        let (owner) = ICarbonableYielder.owner(contract_address);
        return (owner,);
    }

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(newOwner: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableYielder.transferOwnership(contract_address, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func renounce_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }() {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableYielder.renounceOwnership(contract_address);
        %{ stop_prank() %}
        return ();
    }

    func get_snapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        snapshoter: felt
    ) {
        let (contract_address) = instance.get_address();
        let (snapshoter) = ICarbonableYielder.getSnapshoter(contract_address=contract_address);
        return (snapshoter,);
    }

    func set_snapshoter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(snapshoter: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableYielder.setSnapshoter(contract_address=contract_address, snapshoter=snapshoter);
        %{ stop_prank() %}
        return ();
    }

    func get_provisioner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        provisioner: felt
    ) {
        let (contract_address) = instance.get_address();
        let (provisioner) = ICarbonableYielder.getprovisioner(contract_address=contract_address);
        return (provisioner,);
    }

    func set_provisioner{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(provisioner: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableYielder.setprovisioner(
            contract_address=contract_address, provisioner=provisioner
        );
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
        let (carbonable_project_address) = ICarbonableYielder.getCarbonableProjectAddress(
            contract_address
        );
        return (carbonable_project_address,);
    }

    func carbonable_project_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (slot: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = ICarbonableYielder.getCarbonableProjectSlot(
            contract_address=contract_address
        );
        let (slot) = _uint_to_felt(slot_u256);
        return (slot,);
    }

    func carbonable_offseter_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_offseter_address: felt) {
        let (contract_address) = instance.get_address();
        let (carbonable_offseter_address) = ICarbonableYielder.getCarbonableOffseterAddress(
            contract_address=contract_address
        );
        return (carbonable_offseter_address,);
    }

    func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address: felt) {
        let (contract_address) = instance.get_address();
        let (payment_token_address) = ICarbonableYielder.getPaymentTokenAddress(
            contract_address=contract_address
        );
        return (payment_token_address,);
    }

    func get_total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (value_u256) = ICarbonableYielder.getTotalDeposited(contract_address=contract_address);
        let (value) = _uint_to_felt(value_u256);
        return (value,);
    }

    func get_total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (total_absorption: felt) {
        let (contract_address) = instance.get_address();
        let (total_absorption) = ICarbonableYielder.getTotalAbsorption(
            contract_address=contract_address
        );
        return (total_absorption,);
    }

    func get_deposited_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (value: felt) {
        let (contract_address) = instance.get_address();
        let (value_u256) = ICarbonableYielder.getDepositedOf(
            contract_address=contract_address, address=address
        );
        let (value) = _uint_to_felt(value_u256);
        return (value,);
    }

    func get_absorption_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        let (contract_address) = instance.get_address();
        let (absorption) = ICarbonableYielder.getAbsorptionOf(
            contract_address=contract_address, address=address
        );
        return (absorption,);
    }

    func get_claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        let (contract_address) = instance.get_address();
        let (claimable) = ICarbonableYielder.getClaimableOf(
            contract_address=contract_address, address=address
        );
        return (claimable,);
    }

    func get_claimed_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimed: felt) {
        let (contract_address) = instance.get_address();
        let (claimed) = ICarbonableYielder.getClaimedOf(
            contract_address=contract_address, address=address
        );
        return (claimed,);
    }

    func get_snapshoted_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        let (contract_address) = instance.get_address();
        let (time) = ICarbonableYielder.getSnapshotedTime(contract_address=contract_address);
        return (time,);
    }

    func get_snapshoted_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        let (contract_address) = instance.get_address();
        let (absorption) = ICarbonableYielder.getSnapshotedOf(
            contract_address=contract_address, address=address
        );
        return (absorption,);
    }

    //
    // Externals
    //

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        token_id: felt, value: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (token_id_u256) = _felt_to_uint(token_id);
        let (value_u256) = _felt_to_uint(value);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableYielder.deposit(
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
        let (success) = ICarbonableYielder.withdrawTo(
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
        let (success) = ICarbonableYielder.withdrawToToken(
            contract_address=contract_address, token_id=token_id_u256, value=value_u256
        );
        %{ stop_prank() %}
        return (success,);
    }

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}() -> (
        success: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableYielder.claim(contract_address=contract_address);
        %{ stop_prank() %}
        return (success,);
    }

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableYielder.snapshot(contract_address=contract_address);
        %{ stop_prank() %}
        return (success,);
    }

    func provision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        amount: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableYielder.provision(
            contract_address=contract_address, amout=amout
        );
        %{ stop_prank() %}
        return (success,);
    }
}
