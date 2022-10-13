// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableProject {
    func owner() -> (owner: felt) {
    }

    func transferOwnership(newOwner: felt) {
    }

    func mint(to: felt, token_id: Uint256) {
    }
}
