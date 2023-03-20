// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable

namespace CarbonableCertificate {
    func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        to: felt, tokenId: Uint256
    ) {
        ERC721Enumerable._mint(to, tokenId);
        return ();
    }
}
