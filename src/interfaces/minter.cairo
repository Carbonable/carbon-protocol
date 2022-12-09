// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableMinter {
    func getImplementationHash() -> (implementation: felt) {
    }

    func getAdmin() -> (admin: felt) {
    }

    func upgrade(new_implementation: felt) {
    }

    func setAdmin(new_admin: felt) {
    }

    func owner() -> (owner: felt) {
    }

    func transferOwnership(newOwner: felt) {
    }

    func renounceOwnership() {
    }

    func carbonable_project_address() -> (carbonable_project_address: felt) {
    }

    func payment_token_address() -> (payment_token_address: felt) {
    }

    func whitelisted_sale_open() -> (whitelisted_sale_open: felt) {
    }

    func public_sale_open() -> (public_sale_open: felt) {
    }

    func max_buy_per_tx() -> (max_buy_per_tx: felt) {
    }

    func unit_price() -> (unit_price: Uint256) {
    }

    func max_supply_for_mint() -> (max_supply_for_mint: Uint256) {
    }

    func reserved_supply_for_mint() -> (reserved_supply_for_mint: Uint256) {
    }

    func whitelist_merkle_root() -> (whitelist_merkle_root: felt) {
    }

    //##
    // Get the reserved slots number of the specified address.
    // @param account the specified account
    // @param slots the expected slots
    // @param proof_len the len of proof array
    // @param proof the proof array
    // @return the number of reserved slots
    //##
    func whitelisted_slots(account: felt, slots: felt, proof_len: felt, proof: felt*) -> (
        slots: felt
    ) {
    }

    func claimed_slots(account: felt) -> (slots: felt) {
    }

    func sold_out() -> (status: felt) {
    }

    func set_whitelist_merkle_root(whitelist_merkle_root: felt) {
    }

    func set_public_sale_open(public_sale_open: felt) {
    }

    func set_max_buy_per_tx(max_buy_per_tx: felt) {
    }

    func set_unit_price(unit_price: Uint256) {
    }

    func decrease_reserved_supply_for_mint(slots: Uint256) {
    }

    func airdrop(to: felt, quantity: felt) -> (success: felt) {
    }

    func withdraw() -> (success: felt) {
    }

    func transfer(token_address: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func whitelist_buy(slots: felt, proof_len: felt, proof: felt*, quantity: felt) -> (
        success: felt
    ) {
    }

    func public_buy(quantity: felt) -> (success: felt) {
    }
}
