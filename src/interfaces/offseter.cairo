// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableOffseter {
    func carbonable_project_address() -> (carbonable_project_address: felt) {
    }

    func is_locked() -> (status: felt) {
    }

    func total_offsetable(address: felt) -> (total_offsetable: Uint256) {
    }

    func total_offseted(address: felt) -> (total_offseted: Uint256) {
    }

    func total_locked() -> (balance: Uint256) {
    }

    func balance_of(address: felt) -> (balance: felt) {
    }

    func registred_owner_of(token_id: Uint256) -> (address: felt) {
    }

    func offset() -> (success: felt) {
    }

    func snapshot() -> (success: felt) {
    }

    func start_period(unlocked_duration: felt, period_duration: felt, absorption: felt) -> (
        success: felt
    ) {
    }

    func stop_period() -> (success: felt) {
    }

    func deposit(token_id: Uint256) -> (success: felt) {
    }

    func withdraw(token_id: Uint256) -> (success: felt) {
    }
}
