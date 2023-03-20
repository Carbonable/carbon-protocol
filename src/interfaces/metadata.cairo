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

    func slotURI(slot: felt) -> (uri_len: felt, uri: felt*) {
    }

    func tokenURI(slot: felt, value: felt, decimals: felt) -> (uri_len: felt, uri: felt*) {
    }

    func getMetadataImplementation() -> (implementation: felt) {
    }

    //
    // Externals
    //

    func setMetadataImplementation(implementation: felt) {
    }
}
