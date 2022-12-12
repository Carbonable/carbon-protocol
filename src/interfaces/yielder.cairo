// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableYielder {
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

    func getCarbonableProjectAddress() -> (carbonable_project_address: felt) {
    }

    func getCarbonableOffseterAddress() -> (carbonable_offseter_address: felt) {
    }

    func getCarbonableVesterAddress() -> (carbonable_vester_address: felt) {
    }

    func isOpen() -> (status: felt) {
    }

    func getTotalDeposited() -> (balance: Uint256) {
    }

    func getTotalClaimed() -> (total_claimed: felt) {
    }

    func getTotalClaimable() -> (total_claimable: felt) {
    }

    func getClaimableOf(address: felt) -> (claimable: felt) {
    }

    func getClaimedOf(address: felt) -> (claimed: felt) {
    }

    func getRegisteredOwnerOf(token_id: Uint256) -> (address: felt) {
    }

    func getRegisteredTimeOf(token_id: Uint256) -> (time: felt) {
    }

    func getSnapshotedTime() -> (time: felt) {
    }

    func deposit(token_id: Uint256) -> (success: felt) {
    }

    func withdraw(token_id: Uint256) -> (success: felt) {
    }

    func snapshot() -> (success: felt) {
    }

    func createVestings(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) -> (success: felt) {
    }
}
