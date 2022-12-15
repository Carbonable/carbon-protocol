%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IBadgeContract {
    func transferOwnership(newOwner: felt) {
    }

    func mint(to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*) {
    }
}