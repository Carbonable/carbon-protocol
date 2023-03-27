// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.interfaces.minter import ICarbonableMinter

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (carbonable_minter_contract: felt) {
        tempvar carbonable_minter_contract;
        %{ ids.carbonable_minter_contract = context.carbonable_minter_contract %}
        return (carbonable_minter_contract,);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableMinter.getCarbonableProjectAddress(
            carbonable_minter
        );
        return (carbonable_project_address,);
    }

    func payment_token_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (payment_token_address: felt) {
        let (payment_token_address) = ICarbonableMinter.getPaymentTokenAddress(carbonable_minter);
        return (payment_token_address,);
    }

    func whitelisted_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (whitelisted_sale_open: felt) {
        let (whitelisted_sale_open) = ICarbonableMinter.isPreSaleOpen(carbonable_minter);
        return (whitelisted_sale_open,);
    }

    func public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (public_sale_open: felt) {
        let (public_sale_open) = ICarbonableMinter.isPublicSaleOpen(carbonable_minter);
        return (public_sale_open,);
    }

    func max_buy_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (max_buy_per_tx: felt) {
        let (max_buy_per_tx) = ICarbonableMinter.getMaxBuyPerTx(carbonable_minter);
        return (max_buy_per_tx,);
    }

    func unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (unit_price: Uint256) {
        let (unit_price) = ICarbonableMinter.getUnitPrice(carbonable_minter);
        return (unit_price,);
    }

    func reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (reserved_supply_for_mint: Uint256) {
        let (reserved_supply_for_mint) = ICarbonableMinter.getReservedSupplyForMint(
            carbonable_minter
        );
        return (reserved_supply_for_mint,);
    }

    func max_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (max_supply_for_mint: Uint256) {
        let (max_supply_for_mint) = ICarbonableMinter.getMaxSupplyForMint(carbonable_minter);
        return (max_supply_for_mint,);
    }

    func whitelist_merkle_root{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (whitelist_merkle_root: felt) {
        let (whitelist_merkle_root) = ICarbonableMinter.getWhitelistMerkleRoot(carbonable_minter);
        return (whitelist_merkle_root,);
    }

    func whitelisted_slots{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(account: felt, slots: felt, proof_len: felt, proof: felt*) -> (slots: felt) {
        let (slots) = ICarbonableMinter.getWhitelistedSlots(
            carbonable_minter, account, slots, proof_len, proof
        );
        return (slots,);
    }

    func claimed_slots{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(account: felt) -> (slots: felt) {
        let (slots) = ICarbonableMinter.getClaimedSlots(carbonable_minter, account);
        return (slots=slots);
    }

    func sold_out{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (status: felt) {
        let (status) = ICarbonableMinter.isSoldOut(carbonable_minter);
        return (status=status);
    }

    func total_value{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (total_value: Uint256) {
        let (total_value) = ICarbonableMinter.getTotalValue(carbonable_minter);
        return (total_value=total_value);
    }

    func get_withdrawer{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (withdrawer: felt) {
        let (withdrawer) = ICarbonableMinter.getWithdrawer(carbonable_minter);
        return (withdrawer=withdrawer);
    }

    func get_migration_source_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (address: felt) {
        let (address) = ICarbonableMinter.getMigrationSourceAddress(carbonable_minter);
        return (address=address);
    }

    func get_migration_target_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (address: felt) {
        let (address) = ICarbonableMinter.getMigrationTargetAddress(carbonable_minter);
        return (address=address);
    }

    func get_migration_slot{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (slot: Uint256) {
        let (slot) = ICarbonableMinter.getMigrationSlot(carbonable_minter);
        return (slot=slot);
    }

    func get_migration_value{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (value: Uint256) {
        let (value) = ICarbonableMinter.getMigrationValue(carbonable_minter);
        return (value);
    }

    // Externals

    func initialize_migration{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(target_address: felt, slot: Uint256, value: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.initializeMigration(carbonable_minter, target_address, slot, value);
        %{ stop_prank() %}
        return ();
    }

    func migrate{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(tokenId: Uint256, caller: felt) -> (newTokenId: Uint256) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (new_token_id) = ICarbonableMinter.migrate(carbonable_minter, tokenId);
        %{ stop_prank() %}
        return (newTokenId=new_token_id);
    }

    func set_withdrawer{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(withdrawer: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.setWithdrawer(carbonable_minter, withdrawer);
        %{ stop_prank() %}
        return ();
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.withdraw(carbonable_minter);
        %{ stop_prank() %}
        return (success,);
    }

    func set_whitelist_merkle_root{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(whitelist_merkle_root: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.setWhitelistMerkleRoot(carbonable_minter, whitelist_merkle_root);
        %{ stop_prank() %}
        return ();
    }

    func set_public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(public_sale_open: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.setPublicSaleOpen(carbonable_minter, public_sale_open);
        %{ stop_prank() %}
        return ();
    }

    func set_max_buy_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(max_buy_per_tx: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.setMaxBuyPerTx(carbonable_minter, max_buy_per_tx);
        %{ stop_prank() %}
        return ();
    }

    func set_unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(unit_price: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.setUnitPrice(carbonable_minter, unit_price);
        %{ stop_prank() %}
        return ();
    }

    func decrease_reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(slots: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.decreaseReservedSupplyForMint(carbonable_minter, slots);
        %{ stop_prank() %}
        return ();
    }

    func whitelist_buy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(slots: felt, proof_len: felt, proof: felt*, quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.preBuy(
            carbonable_minter, slots, proof_len, proof, quantity
        );
        %{ stop_prank() %}
        return (success,);
    }

    func public_buy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.publicBuy(carbonable_minter, quantity);
        %{ stop_prank() %}
        return (success,);
    }

    func airdrop{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(to: felt, quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.airdrop(carbonable_minter, to, quantity);
        %{ stop_prank() %}
        return (success,);
    }
}
