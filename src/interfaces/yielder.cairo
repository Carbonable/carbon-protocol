// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableYielder {
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

    func setSnapshoter(snapshoter: felt) {
    }

    func getSnapshoter() -> (snapshoter: felt) {
    }

    func setProvisioner(provisioner: felt) {
    }

    func getProvisioner() -> (provisioner: felt) {
    }

    //
    // Views
    //

    func getCarbonableProjectAddress() -> (carbonable_project_address: felt) {
    }

    func getCarbonableProjectSlot() -> (carbonable_project_slot: Uint256) {
    }

    func getCarbonableOffseterAddress() -> (carbonable_offseter_address: felt) {
    }

    func getPaymentTokenAddress() -> (payment_token_address: felt) {
    }

    func getTotalDeposited() -> (value: Uint256) {
    }

    func getTotalAbsorption() -> (total_absorption: felt) {
    }

    func getTotalClaimable() -> (total_claimable: felt) {
    }

    func getTotalClaimed() -> (total_claimed: felt) {
    }

    func getDepositedOf(address: felt) -> (value: Uint256) {
    }

    func getAbsorptionOf(address: felt) -> (absorption: felt) {
    }

    func getClaimableOf(address: felt) -> (claimable: felt) {
    }

    func getClaimedOf(address: felt) -> (claimed: felt) {
    }

    func getCurrentPrice() -> (current_price: felt) {
    }

    func getPrices() -> (
        len: felt, times: felt*, prices: felt*, updated_prices: felt*, cumsales: felt*
    ) {
    }

    //
    // Externals
    //

    func deposit(token_id: Uint256, value: Uint256) -> (success: felt) {
    }

    func withdrawTo(value: Uint256) -> (success: felt) {
    }

    func withdrawToToken(token_id: Uint256, value: Uint256) -> (success: felt) {
    }

    func claim() {
    }

    func addPrice(time: felt, price: felt) {
    }

    func updateLastPrice(time: felt, price: felt) {
    }
}
