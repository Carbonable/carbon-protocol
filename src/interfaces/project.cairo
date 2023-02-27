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

    func revokeMinter(minter: felt) {
    }

    func getMinters() -> (minters_len: felt, minters: felt*) {
    }

    func setCertifier(certifier: felt) {
    }

    func getCertifier() -> (certifier: felt) {
    }

    //
    // Views
    //

    func getStartTime(slot: Uint256) -> (start_time: felt) {
    }

    func getFinalTime(slot: Uint256) -> (final_time: felt) {
    }

    func getTimes(slot: Uint256) -> (times_len: felt, times: felt*) {
    }

    func getAbsorptions(slot: Uint256) -> (absorptions_len: felt, absorptions: felt*) {
    }

    func getAbsorption(slot: Uint256, time: felt) -> (absorption: felt) {
    }

    func getCurrentAbsorption(slot: Uint256) -> (absorption: felt) {
    }

    func getFinalAbsorption(slot: Uint256) -> (absorption: felt) {
    }

    func getTonEquivalent(slot: Uint256) -> (ton_equivalent: felt) {
    }

    func isSetup(slot: Uint256) -> (status: felt) {
    }

    //
    // Externals
    //

    func setAbsorptions(
        slot: Uint256,
        times_len: felt,
        times: felt*,
        absorptions_len: felt,
        absorptions: felt*,
        ton_equivalent: felt,
    ) {
    }
}
