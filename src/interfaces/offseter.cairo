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

    func getMinClaimable() -> (min_claimable: felt) {
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

    func getRegisteredTokensOf(address: felt) -> (tokens_len: felt, tokens: Uint256*) {
    }

    func setMinClaimable(min_claimable: felt) -> () {
    }

    //
    // Externals
    //

    func claim(quantity: felt) -> (success: felt) {
    }

    func claimAll() -> (success: felt) {
    }

    func deposit(token_id: Uint256) -> (success: felt) {
    }

    func withdraw(token_id: Uint256) -> (success: felt) {
    }
}
