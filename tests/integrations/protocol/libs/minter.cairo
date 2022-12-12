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
        let (carbonable_project_address) = ICarbonableMinter.carbonable_project_address(
            carbonable_minter
        );
        return (carbonable_project_address,);
    }

    func payment_token_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (payment_token_address: felt) {
        let (payment_token_address) = ICarbonableMinter.payment_token_address(carbonable_minter);
        return (payment_token_address,);
    }

    func whitelisted_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (whitelisted_sale_open: felt) {
        let (whitelisted_sale_open) = ICarbonableMinter.whitelisted_sale_open(carbonable_minter);
        return (whitelisted_sale_open,);
    }

    func public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (public_sale_open: felt) {
        let (public_sale_open) = ICarbonableMinter.public_sale_open(carbonable_minter);
        return (public_sale_open,);
    }

    func max_buy_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (max_buy_per_tx: felt) {
        let (max_buy_per_tx) = ICarbonableMinter.max_buy_per_tx(carbonable_minter);
        return (max_buy_per_tx,);
    }

    func unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (unit_price: Uint256) {
        let (unit_price) = ICarbonableMinter.unit_price(carbonable_minter);
        return (unit_price,);
    }

    func max_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (max_supply_for_mint: Uint256) {
        let (max_supply_for_mint) = ICarbonableMinter.max_supply_for_mint(carbonable_minter);
        return (max_supply_for_mint,);
    }

    func reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (reserved_supply_for_mint: Uint256) {
        let (reserved_supply_for_mint) = ICarbonableMinter.reserved_supply_for_mint(
            carbonable_minter
        );
        return (reserved_supply_for_mint,);
    }

    func whitelist_merkle_root{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (whitelist_merkle_root: felt) {
        let (whitelist_merkle_root) = ICarbonableMinter.whitelist_merkle_root(carbonable_minter);
        return (whitelist_merkle_root,);
    }

    func whitelisted_slots{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(account: felt, slots: felt, proof_len: felt, proof: felt*) -> (slots: felt) {
        let (slots) = ICarbonableMinter.whitelisted_slots(
            carbonable_minter, account, slots, proof_len, proof
        );
        return (slots,);
    }

    func claimed_slots{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(account: felt) -> (slots: felt) {
        let (slots) = ICarbonableMinter.claimed_slots(carbonable_minter, account);
        return (slots=slots);
    }

    func sold_out{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (status: felt) {
        let (status) = ICarbonableMinter.sold_out(carbonable_minter);
        return (status=status);
    }

    // Externals

    func decrease_reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(slots: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.decrease_reserved_supply_for_mint(carbonable_minter, slots);
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
        ICarbonableMinter.set_whitelist_merkle_root(carbonable_minter, whitelist_merkle_root);
        %{ stop_prank() %}
        return ();
    }

    func set_public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(public_sale_open: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_public_sale_open(carbonable_minter, public_sale_open);
        %{ stop_prank() %}
        return ();
    }

    func set_max_buy_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(max_buy_per_tx: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_max_buy_per_tx(carbonable_minter, max_buy_per_tx);
        %{ stop_prank() %}
        return ();
    }

    func set_unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(unit_price: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_unit_price(carbonable_minter, unit_price);
        %{ stop_prank() %}
        return ();
    }

    func whitelist_buy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(slots: felt, proof_len: felt, proof: felt*, quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.whitelist_buy(
            carbonable_minter, slots, proof_len, proof, quantity
        );
        %{ stop_prank() %}
        return (success,);
    }

    func public_buy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.public_buy(carbonable_minter, quantity);
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
