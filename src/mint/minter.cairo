// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (minter.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from src.mint.library import CarbonableMinter

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt,
    carbonable_project_address: felt,
    payment_token_address: felt,
    public_sale_open: felt,
    max_buy_per_tx: felt,
    unit_price: Uint256,
    max_supply_for_mint: Uint256,
    reserved_supply_for_mint: Uint256,
) {
    return CarbonableMinter.constructor(
        owner,
        carbonable_project_address,
        payment_token_address,
        public_sale_open,
        max_buy_per_tx,
        unit_price,
        max_supply_for_mint,
        reserved_supply_for_mint,
    );
}

//
// Getters
//

@view
func carbonable_project_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableMinter.carbonable_project_address();
}

@view
func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    payment_token_address: felt
) {
    return CarbonableMinter.payment_token_address();
}

@view
func whitelisted_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    whitelisted_sale_open: felt
) {
    return CarbonableMinter.whitelisted_sale_open();
}

@view
func public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    public_sale_open: felt
) {
    return CarbonableMinter.public_sale_open();
}

@view
func max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_buy_per_tx: felt
) {
    return CarbonableMinter.max_buy_per_tx();
}

@view
func unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    unit_price: Uint256
) {
    return CarbonableMinter.unit_price();
}

@view
func reserved_supply_for_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (reserved_supply_for_mint: Uint256) {
    return CarbonableMinter.reserved_supply_for_mint();
}

@view
func max_supply_for_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_supply_for_mint: Uint256
) {
    return CarbonableMinter.max_supply_for_mint();
}

@view
func whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    whitelist_merkle_root: felt
) {
    return CarbonableMinter.whitelist_merkle_root();
}

@view
func whitelisted_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, slots: felt, proof_len: felt, proof: felt*
) -> (slots: felt) {
    return CarbonableMinter.whitelisted_slots(account, slots, proof_len, proof);
}

@view
func claimed_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (slots: felt) {
    return CarbonableMinter.claimed_slots(account);
}

//
// Externals
//

@external
func set_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    whitelist_merkle_root: felt
) {
    return CarbonableMinter.set_whitelist_merkle_root(whitelist_merkle_root);
}

@external
func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    public_sale_open: felt
) {
    return CarbonableMinter.set_public_sale_open(public_sale_open);
}

@external
func set_max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    max_buy_per_tx: felt
) {
    return CarbonableMinter.set_max_buy_per_tx(max_buy_per_tx);
}

@external
func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    unit_price: Uint256
) {
    return CarbonableMinter.set_unit_price(unit_price);
}

@external
func decrease_reserved_supply_for_mint{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(slots: Uint256) {
    return CarbonableMinter.decrease_reserved_supply_for_mint(slots);
}

@external
func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, quantity: felt
) -> (success: felt) {
    return CarbonableMinter.airdrop(to, quantity);
}

@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    return CarbonableMinter.withdraw();
}

@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_address: felt, recipient: felt, amount: Uint256
) -> (success: felt) {
    return CarbonableMinter.transfer(token_address, recipient, amount);
}

@external
func whitelist_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slots: felt, proof_len: felt, proof: felt*, quantity: felt
) -> (success: felt) {
    return CarbonableMinter.whitelist_buy(slots, proof_len, proof, quantity);
}

@external
func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    quantity: felt
) -> (success: felt) {
    return CarbonableMinter.public_buy(quantity);
}
