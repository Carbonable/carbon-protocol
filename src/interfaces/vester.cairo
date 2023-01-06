// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableVester {
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

    func vestings_total_amount() -> (vestings_total_amount: Uint256) {
    }

    func vesting_count(account: felt) -> (vesting_count: felt) {
    }

    func get_vesting_id(account: felt, vesting_index: felt) -> (vesting_id: felt) {
    }

    func withdrawable_amount() -> (releasable_amount: Uint256) {
    }

    func releasable_amount(vesting_id: felt) -> (releasable_amount: Uint256) {
    }

    func releasableOf(account: felt) -> (amount: Uint256) {
    }

    //
    // Externals
    //

    func create_vesting(
        beneficiary: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        amount_total: Uint256,
    ) -> (vesting_id: felt) {
    }

    func revoke(vesting_id: felt) {
    }

    func release(vesting_id: felt, amount: Uint256) {
    }

    func withdraw(amount: Uint256) {
    }

    func releaseAll() {
    }
}
