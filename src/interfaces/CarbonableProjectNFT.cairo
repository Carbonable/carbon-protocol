# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (CarbonableProjectNFT.cairo)

%lang starknet

from openzeppelin.token.erc721_enumerable.interfaces.IERC721_Enumerable import (
    IERC721,
    IERC721_Enumerable,
)

@contract_interface
namespace ICarbonableProjectNFT:
    func owner() -> (owner : felt):
    end

    func transferOwnership(newOwner : felt):
    end
end
