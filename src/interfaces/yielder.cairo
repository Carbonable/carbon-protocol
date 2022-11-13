// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableYielder {
    func carbonable_project_address() -> (carbonable_project_address: felt) {
    }

    func is_locked() -> (status: felt) {
    }

    func total_locked() -> (balance: Uint256) {
    }

    func share(address: felt, precision: felt) -> (share: Uint256) {
    }

    func registred_owner_of(token_id: Uint256) -> (address: felt) {
    }

    func start_period(unlocked_duration: felt, period_duration: felt) -> (success: felt) {
    }

    func stop_period() -> (success: felt) {
    }

    func deposite(token_id: Uint256) -> (success: felt) {
    }

    func withdraw(token_id: Uint256) -> (success: felt) {
    }
}
