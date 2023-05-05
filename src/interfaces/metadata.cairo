// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableMetadata {
    //
    // Views
    //

    func contractURI() -> (uri_len: felt, uri: felt*) {
    }

    func slotURI(slot: Uint256) -> (uri_len: felt, uri: felt*) {
    }

    func tokenURI(tokenId: Uint256) -> (uri_len: felt, uri: felt*) {
    }

    func getMetadataImplementation() -> (implementation: felt) {
    }

    func getSlotMetadataImplementation(slot: Uint256) -> (implementation: felt) {
    }

    //
    // Externals
    //

    func setMetadataImplementation(implementation: felt) {
    }

    func setSlotMetadataImplementation(slot: Uint256, implementation: felt) {
    }
}
