// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableMinter {
    //
    // Proxy administration
    //

    func getImplementationHash() -> (implementation: felt) {
    }

    func getAdmin() -> (admin: felt) {
    }

    func upgrade(new_implementation: felt) {
    }

    func setAdmin(new_admin: felt) {
    }

    //
    // Ownership administration
    //

    func owner() -> (owner: felt) {
    }

    func transferOwnership(newOwner: felt) {
    }

    func renounceOwnership() {
    }

    func setWithdrawer(withdrawer: felt) {
    }

    func getWithdrawer() -> (withdrawer: felt) {
    }

    //
    // Views
    //

    func getCarbonableProjectAddress() -> (carbonable_project_address: felt) {
    }

    func getCarbonableProjectSlot() -> (carbonable_project_slot: Uint256) {
    }

    func getPaymentTokenAddress() -> (payment_token_address: felt) {
    }

    func isPreSaleOpen() -> (pre_sale_open: felt) {
    }

    func isPublicSaleOpen() -> (public_sale_open: felt) {
    }

    func getMinValuePerTx() -> (min_value_per_tx: felt) {
    }

    func getMaxValuePerTx() -> (max_value_per_tx: felt) {
    }

    func getUnitPrice() -> (unit_price: felt) {
    }

    func getReservedValue() -> (reserved_value: felt) {
    }

    func getMaxValue() -> (max_value: felt) {
    }

    func getWhitelistMerkleRoot() -> (whitelist_merkle_root: felt) {
    }

    func getWhitelistAllocation(account: felt, allocation: felt, proof_len: felt, proof: felt*) -> (
        allocation: felt
    ) {
    }

    func getClaimedValue(account: felt) -> (value: felt) {
    }

    func isSoldOut() -> (status: felt) {
    }

    //
    // Externals
    //

    func setWhitelistMerkleRoot(whitelist_merkle_root: felt) {
    }

    func setPublicSaleOpen(public_sale_open: felt) {
    }

    func setMaxValuePerTx(max_value_per_tx: felt) {
    }

    func setMinValuePerTx(min_value_per_tx: felt) {
    }

    func setUnitPrice(unit_price: felt) {
    }

    func decreaseReservedValue(value: felt) {
    }

    func airdrop(to: felt, value: felt) -> (success: felt) {
    }

    func withdraw() -> (success: felt) {
    }

    func transfer(token_address: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func preBuy(allocation: felt, proof_len: felt, proof: felt*, value: felt, force: felt) -> (success: felt) {
    }

    func publicBuy(value: felt, force: felt) -> (success: felt) {
    }
}
