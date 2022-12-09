// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableProject {
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

    func addMinter(minter: felt) {
    }

    func mint(to: felt, token_id: Uint256) {
    }

    func getStartTime() -> (start_time: felt) {
    }

    func getFinalTime() -> (final_time: felt) {
    }

    func getTimeStep() -> (time_step: felt) {
    }

    func getAbsorptions() -> (absorptions_len: felt, absorptions: felt*) {
    }

    func getAbsorption(time: felt) -> (absorption: felt) {
    }

    func getCurrentAbsorption() -> (absorption: felt) {
    }

    func getFinalAbsorption() -> (absorption: felt) {
    }

    func isSetup() -> (status: felt) {
    }

    func setTime(start_time: felt, time_step: felt) {
    }

    func setAbsorptions(absorptions_len: felt, absorptions: felt*) {
    }
}
