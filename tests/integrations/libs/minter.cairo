// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.interfaces.minter import ICarbonableMinter
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
        %{ ids.contract_address = context.carbonable_minter_contract %}
        return (contract_address,);
    }

    //
    // Proxy administration
    //

    func get_implementation_hash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (implementation: felt) {
        let (contract_address) = instance.get_address();
        let (implementation) = ICarbonableMinter.getImplementationHash(
            contract_address=contract_address
        );
        return (implementation,);
    }

    func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        admin: felt
    ) {
        let (contract_address) = instance.get_address();
        let (admin) = ICarbonableMinter.getAdmin(contract_address);
        return (admin,);
    }

    func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_implementation: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.upgrade(contract_address, new_implementation);
        %{ stop_prank() %}
        return ();
    }

    func set_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        new_admin: felt
    ) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setAdmin(contract_address, new_admin);
        %{ stop_prank() %}
        return ();
    }

    //
    // Ownership administration
    //

    func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
        let (contract_address) = instance.get_address();
        let (owner) = ICarbonableMinter.owner(contract_address);
        return (owner,);
    }

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(newOwner: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.transferOwnership(contract_address, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func renounce_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }() {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.renounceOwnership(contract_address);
        %{ stop_prank() %}
        return ();
    }

    func set_withdrawer{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(withdrawer: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setWithdrawer(contract_address, withdrawer);
        %{ stop_prank() %}
        return ();
    }

    func get_withdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        withdrawer: felt
    ) {
        let (contract_address) = instance.get_address();
        let (withdrawer) = ICarbonableMinter.getWithdrawer(contract_address);
        return (withdrawer,);
    }

    //
    // Getters
    //

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (contract_address) = instance.get_address();
        let (carbonable_project_address) = ICarbonableMinter.getCarbonableProjectAddress(
            contract_address
        );
        return (carbonable_project_address,);
    }

    func carbonable_project_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (slot: felt) {
        let (contract_address) = instance.get_address();
        let (slot_u256) = ICarbonableMinter.getCarbonableProjectSlot(
            contract_address=contract_address
        );
        let (slot) = _uint_to_felt(slot_u256);
        return (slot,);
    }

    func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address: felt) {
        let (contract_address) = instance.get_address();
        let (payment_token_address) = ICarbonableMinter.getPaymentTokenAddress(
            contract_address=contract_address
        );
        return (payment_token_address,);
    }

    func is_pre_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        pre_sale_open: felt
    ) {
        let (contract_address) = instance.get_address();
        let (pre_sale_open) = ICarbonableMinter.isPreSaleOpen(contract_address);
        return (pre_sale_open,);
    }

    func is_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        public_sale_open: felt
    ) {
        let (contract_address) = instance.get_address();
        let (public_sale_open) = ICarbonableMinter.isPublicSaleOpen(
            contract_address=contract_address
        );
        return (public_sale_open,);
    }

    func get_max_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (max_value_per_tx: felt) {
        let (contract_address) = instance.get_address();
        let (max_value_per_tx) = ICarbonableMinter.getMaxValuePerTx(
            contract_address=contract_address
        );
        return (max_value_per_tx,);
    }

    func get_min_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (min_value_per_tx: felt) {
        let (contract_address) = instance.get_address();
        let (min_value_per_tx) = ICarbonableMinter.getMinValuePerTx(
            contract_address=contract_address
        );
        return (min_value_per_tx,);
    }

    func get_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        unit_price: felt
    ) {
        let (contract_address) = instance.get_address();
        let (unit_price) = ICarbonableMinter.getUnitPrice(contract_address);
        return (unit_price,);
    }

    func get_reserved_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        reserved_value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (reserved_value) = ICarbonableMinter.getReservedValue(contract_address);
        return (reserved_value,);
    }

    func get_max_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        max_value: felt
    ) {
        let (contract_address) = instance.get_address();
        let (max_value) = ICarbonableMinter.getMaxValue(contract_address);
        return (max_value,);
    }

    func get_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (whitelist_merkle_root: felt) {
        let (contract_address) = instance.get_address();
        let (whitelist_merkle_root) = ICarbonableMinter.getWhitelistMerkleRoot(
            contract_address=contract_address
        );
        return (whitelist_merkle_root,);
    }

    func get_whitelist_allocation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt, allocation: felt, proof_len: felt, proof: felt*
    ) -> (allocation: felt) {
        let (contract_address) = instance.get_address();
        let (allocation) = ICarbonableMinter.getWhitelistAllocation(
            contract_address, account, allocation, proof_len, proof
        );
        return (allocation,);
    }

    func get_claimed_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (value: felt) {
        let (contract_address) = instance.get_address();
        let (value) = ICarbonableMinter.getClaimedValue(contract_address, account);
        return (value,);
    }

    func is_sold_out{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (contract_address) = instance.get_address();
        let (status) = ICarbonableMinter.isSoldOut(contract_address);
        return (status,);
    }

    //
    // Externals
    //

    func set_whitelist_merkle_root{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(whitelist_merkle_root: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setWhitelistMerkleRoot(
            contract_address=contract_address, whitelist_merkle_root=whitelist_merkle_root
        );
        %{ stop_prank() %}
        return ();
    }

    func set_public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(public_sale_open: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setPublicSaleOpen(contract_address, public_sale_open);
        %{ stop_prank() %}
        return ();
    }

    func set_max_value_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(max_value_per_tx: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setMaxValuePerTx(contract_address, max_value_per_tx);
        %{ stop_prank() %}
        return ();
    }

    func set_min_value_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(min_value_per_tx: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setMinValuePerTx(contract_address, min_value_per_tx);
        %{ stop_prank() %}
        return ();
    }

    func set_unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(unit_price: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.setUnitPrice(contract_address, unit_price);
        %{ stop_prank() %}
        return ();
    }

    func decrease_reserved_value{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt
    }(value: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        ICarbonableMinter.decreaseReservedValue(contract_address, value);
        %{ stop_prank() %}
        return ();
    }

    func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        to: felt, value: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableMinter.airdrop(contract_address, to, value);
        %{ stop_prank() %}
        return (success,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableMinter.withdraw(contract_address);
        %{ stop_prank() %}
        return (success,);
    }

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        token_address: felt, recipient: felt, amount: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (amount_u256) = _felt_to_uint(amount);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableMinter.transfer(
            contract_address, token_address, recipient, amount_u256
        );
        %{ stop_prank() %}
        return (success,);
    }

    func pre_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        allocation: felt, proof_len: felt, proof: felt*, value: felt, force: felt
    ) -> (success: felt) {
        alloc_locals;

        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableMinter.preBuy(
            contract_address, allocation, proof_len, proof, value, force
        );
        %{ stop_prank() %}
        return (success,);
    }

    func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        value: felt, force: felt
    ) -> (success: felt) {
        alloc_locals;

        let (contract_address) = instance.get_address();
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = ICarbonableMinter.publicBuy(contract_address, value, force);
        %{ stop_prank() %}
        return (success,);
    }
}
