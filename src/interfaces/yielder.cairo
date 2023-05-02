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

    func getPaymentTokenAddress() -> (payment_token_address: felt) {
    }

    func getCarbonableVesterAddress() -> (carbonable_vester_address: felt) {
    }

    func getTotalDeposited() -> (value: Uint256) {
    }

    func getTotalAbsorption() -> (total_absorption: felt) {
    }

    func getDepositedOf(address: felt) -> (value: Uint256) {
    }

    func getAbsorptionOf(address: felt) -> (absorption: felt) {
    }

    func getClaimableOf(address: felt) -> (claimable: felt) {
    }

    func getClaimedOf(address: felt) -> (claimed: felt) {
    }

    func getSnapshotedTime() -> (time: felt) {
    }

    func getSnapshotedOf(address: felt) -> (absorption: felt) {
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

    func claim() -> (success: felt) {
    }

    func snapshot() -> (success: felt) {
    }

    func provision(amount: felt) -> (success: felt) {
    }
}
