// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableProject {
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

    func addMinter(minter: felt) {
    }

    func mint(to: felt, token_id: Uint256) {
    }

    //
    // Views
    //

    func getStartTime() -> (start_time: felt) {
    }

    func getFinalTime() -> (final_time: felt) {
    }

    func getTimes() -> (times_len: felt, times: felt*) {
    }

    func getAbsorptions() -> (absorptions_len: felt, absorptions: felt*) {
    }

    func getAbsorption(time: felt) -> (absorption: felt) {
    }

    func getCurrentAbsorption() -> (absorption: felt) {
    }

    func getFinalAbsorption() -> (absorption: felt) {
    }

    func getTonEquivalent() -> (ton_equivalent: felt) {
    }

    func isSetup() -> (status: felt) {
    }

    //
    // Externals
    //

    func setTimes(times_len: felt, times: felt*) {
    }

    func setAbsorptions(absorptions_len: felt, absorptions: felt*, ton_equivalent: felt) {
    }
}
