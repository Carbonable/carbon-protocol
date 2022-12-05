// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableOffseter {
    func getImplementationHash() -> (implementation: felt) {
    }

    func getAdmin() -> (admin: felt) {
    }

    func upgrade(new_implementation: felt) {
    }

    func setAdmin(new_admin: felt) {
    }

    func carbonable_project_address() -> (carbonable_project_address: felt) {
    }

    func time_step() -> (time_step: felt) {
    }

    func absorptions() -> (absorptions_len: felt, absorptions: felt*) {
    }

    func total_deposited() -> (balance: Uint256) {
    }

    func total_claimed() -> (total_claimed: felt) {
    }

    func total_claimable() -> (total_claimable: felt) {
    }

    func total_absorption() -> (absorption: felt) {
    }

    func claimable_of(address: felt) -> (claimable: felt) {
    }

    func claimed_of(address: felt) -> (claimed: felt) {
    }

    func registered_owner_of(token_id: Uint256) -> (address: felt) {
    }

    func registered_time_of(token_id: Uint256) -> (time: felt) {
    }

    func set_absorptions(absorptions_len: felt, absorptions: felt*) {
    }

    func claim() -> (success: felt) {
    }

    func deposit(token_id: Uint256) -> (success: felt) {
    }

    func withdraw(token_id: Uint256) -> (success: felt) {
    }

    func transferOwnership(newOwner: felt) {
    }

    func renounceOwnership() {
    }
}
