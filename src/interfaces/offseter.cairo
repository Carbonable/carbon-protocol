// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableOffseter {
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

    //
    // Views
    //

    func getCarbonableProjectAddress() -> (carbonable_project_address: felt) {
    }

    func getCarbonableProjectSlot() -> (carbonable_project_slot: Uint256) {
    }

    func getMinClaimable() -> (min_claimable: felt) {
    }

    func getTotalDeposited() -> (value: Uint256) {
    }

    func getTotalAbsorption() -> (total_absorption: felt) {
    }

    func getTotalClaimed() -> (total_claimed: felt) {
    }

    func getTotalClaimable() -> (total_claimable: felt) {
    }

    func getDepositedOf(address: felt) -> (value: Uint256) {
    }

    func getAbsorptionOf(address: felt) -> (absorption: felt) {
    }

    func getClaimableOf(address: felt) -> (claimable: felt) {
    }

    func getClaimedOf(address: felt) -> (claimed: felt) {
    }

    //
    // Externals
    //

    func setMinClaimable(min_claimable: felt) -> () {
    }

    func claim(quantity: felt) {
    }

    func claimAll() {
    }

    func deposit(token_id: Uint256, value: Uint256) -> (success: felt) {
    }

    func withdrawTo(value: Uint256) -> (success: felt) {
    }

    func withdrawToToken(token_id: Uint256, value: Uint256) -> (success: felt) {
    }
}
