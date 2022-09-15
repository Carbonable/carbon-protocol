// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (project.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableBadge {
    func uri(id: Uint256) -> (uri_len: felt, uri: felt*) {
    }

    func name() -> (name: felt) {
    }

    func locked(id: Uint256) -> (is_locked: felt) {
    }

    func owner() -> (owner: felt) {
    }

    func setURI(uri_len: felt, uri: felt*) {
    }

    func setLocked(id: Uint256) {
    }

    func setUnlocked(id: Uint256) {
    }

    func mint(to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*) {
    }

    func mintBatch(
        to: felt,
        ids_len: felt,
        ids: Uint256*,
        amounts_len: felt,
        amounts: Uint256*,
        data_len: felt,
        data: felt*,
    ) {
    }
}
