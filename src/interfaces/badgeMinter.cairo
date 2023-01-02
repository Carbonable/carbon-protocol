%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableBadgeMinter {
    func claim(signature : (felt, felt), badge_type : felt) {
    }
    func setBadgeContractAddress(new_badge_contract_address : felt) {
    }
    func owner() -> (owner : felt) {
    }
    func transferOwnership(newOwner : felt) {
    }
    func transferBadgeContractOwnership(newOwner : felt) {
    }
}