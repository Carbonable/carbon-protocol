// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.interfaces.vester import ICarbonableVester
from src.utils.type.library import _felt_to_uint, _uint_to_felt

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (contract_address: felt) {
        tempvar contract_address;
        %{ ids.contract_address = context.carbonable_vester_contract %}
        return (contract_address,);
    }

    //
    // Proxy administration
    //

    func get_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (implementation: felt) {
        let (contract_address) = instance.get_address();
        let (implementation) = ICarbonableVester.getImplementationHash(
            contract_address=contract_address
        );
        return (implementation,);
    }

    func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        admin: felt
    ) {
        let (contract_address) = instance.get_address();
        let (admin) = ICarbonableVester.getAdmin(contract_address);
        return (admin,);
    }

    func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_implementation: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.upgrade(contract_address, new_implementation);
        %{ stop_prank() %}
        return ();
    }

    func set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_admin: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.setAdmin(contract_address, new_admin);
        %{ stop_prank() %}
        return ();
    }

    //
    // Ownership administration
    //

    func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
        let (contract_address) = instance.get_address();
        let (owner) = ICarbonableVester.owner(contract_address);
        return (owner,);
    }

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(newOwner: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.transferOwnership(contract_address, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func renounce_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }() {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.renounceOwnership(contract_address);
        %{ stop_prank() %}
        return ();
    }

    func get_vesters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        vesters_len: felt, vesters: felt*
    ) {
        let (contract_address) = instance.get_address();
        let (vesters_len, vesters) = ICarbonableVester.getVesters(
            contract_address=contract_address
        );
        return (vesters_len, vesters);
    }

    func add_vester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        vester: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.addVester(contract_address=contract_address, vester=vester);
        %{ stop_prank() %}
        return ();
    }

    func revoke_vester{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(vester: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.revokeVester(contract_address=contract_address, vester=vester);
        %{ stop_prank() %}
        return ();
    }

    //
    // Getters
    //

    func withdrawable_amount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        releasable_amount: felt
    ) {
        let (contract_address) = instance.get_address();
        let (releasable_amount_u256) = ICarbonableVester.withdrawable_amount(
            contract_address=contract_address
        );
        let (releasable_amount) = _uint_to_felt(releasable_amount_u256);
        return (releasable_amount,);
    }

    func vesting_count{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (vesting_count: felt) {
        let (contract_address) = instance.get_address();
        let (vesting_count) = ICarbonableVester.vesting_count(
            contract_address=contract_address, account=account
        );
        return (vesting_count,);
    }

    func get_vesting_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        vesting_index: felt, account: felt
    ) -> (vesting_id: felt) {
        let (contract_address) = instance.get_address();
        let (vesting_id) = ICarbonableVester.get_vesting_id(
            contract_address=contract_address, account=account, vesting_index=vesting_index
        );
        return (vesting_id,);
    }

    func releasable_amount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        vesting_id: felt
    ) -> (releasable_amount: felt) {
        let (contract_address) = instance.get_address();
        let (releasable_amount_u256) = ICarbonableVester.releasable_amount(
            contract_address=contract_address, vesting_id=vesting_id
        );
        let (releasable_amount) = _uint_to_felt(releasable_amount_u256);
        return (releasable_amount=releasable_amount);
    }

    func releasable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (releasable_amount: felt) {
        let (contract_address) = instance.get_address();
        let (releasable_amount_u256) = ICarbonableVester.releasableOf(
            contract_address=contract_address, account=account
        );
        let (releasable_amount) = _uint_to_felt(releasable_amount_u256);
        return (releasable_amount=releasable_amount);
    }

    func released_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (released_amount: felt) {
        let (contract_address) = instance.get_address();
        let (released_amount_u256) = ICarbonableVester.releasedOf(
            contract_address=contract_address, account=account
        );
        let (released_amount) = _uint_to_felt(released_amount_u256);
        return (released_amount=released_amount);
    }

    //
    // Externals
    //

    func create_vesting{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(
        beneficiary: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        amount_total: felt,
    ) -> (vesting_id: felt) {
        let (contract_address) = instance.get_address();
        let (amount_total_u256) = _felt_to_uint(amount_total);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (vesting_id) = ICarbonableVester.create_vesting(
            contract_address=contract_address,
            beneficiary=beneficiary,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
            amount_total=amount_total_u256,
        );
        %{ stop_prank() %}
        return (vesting_id,);
    }

    func release_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableVester.releaseAll(contract_address=contract_address);
        %{ stop_prank() %}
        return ();
    }
}
