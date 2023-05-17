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
    // Migrator
    //

    func getMigrationSourceAddress() -> (address: felt) {
    }

    func getMigrationTargetAddress() -> (address: felt) {
    }

    func getMigrationSlot() -> (slot: Uint256) {
    }

    func getMigrationValue() -> (value: Uint256) {
    }

    func initializeMigration(source_address: felt, target_address: felt, slot: Uint256) {
    }

    func migrate(tokenIds_len: felt, tokenIds: Uint256*) -> (newTokenId: Uint256) {
    }

    //
    // Views
    //

    func getCarbonableProjectAddress() -> (carbonable_project_address: felt) {
    }

    func getPaymentTokenAddress() -> (payment_token_address: felt) {
    }

    func isPreSaleOpen() -> (pre_sale_open: felt) {
    }

    func isPublicSaleOpen() -> (public_sale_open: felt) {
    }

    func getMaxBuyPerTx() -> (max_buy_per_tx: felt) {
    }

    func getUnitPrice() -> (unit_price: Uint256) {
    }

    func getReservedSupplyForMint() -> (reserved_supply_for_mint: Uint256) {
    }

    func getMaxSupplyForMint() -> (max_supply_for_mint: Uint256) {
    }

    func getWhitelistMerkleRoot() -> (whitelist_merkle_root: felt) {
    }

    func getWhitelistedSlots(account: felt, slots: felt, proof_len: felt, proof: felt*) -> (
        slots: felt
    ) {
    }

    func getClaimedSlots(account: felt) -> (slots: felt) {
    }

    func isSoldOut() -> (status: felt) {
    }

    func getTotalValue() -> (total_value: Uint256) {
    }

    //
    // Externals
    //

    func setWhitelistMerkleRoot(whitelist_merkle_root: felt) {
    }

    func setPublicSaleOpen(public_sale_open: felt) {
    }

    func setMaxBuyPerTx(max_buy_per_tx: felt) {
    }

    func setUnitPrice(unit_price: Uint256) {
    }

    func decreaseReservedSupplyForMint(slots: Uint256) {
    }

    func airdrop(to: felt, quantity: felt) -> (success: felt) {
    }

    func withdraw() -> (success: felt) {
    }

    func transfer(token_address: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func preBuy(slots: felt, proof_len: felt, proof: felt*, quantity: felt) -> (success: felt) {
    }

    func publicBuy(quantity: felt) -> (success: felt) {
    }
}
