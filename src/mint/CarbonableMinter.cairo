# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (CarbonableMinter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from openzeppelin.token.erc721.interfaces.IERC721 import IERC721
from openzeppelin.access.ownable import Ownable_initializer, Ownable_only_owner

# ------
# EVENTS
# ------

# ------
# STORAGE
# ------

# Address of the project NFT contract
@storage_var
func project_nft_address_() -> (res : felt):
end

# ------
# CONSTRUCTOR
# ------

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, project_nft_address : felt
):
    Ownable_initializer(owner)
    project_nft_address_.write(project_nft_address)
    return ()
end

# ------------------
# EXTERNAL FUNCTIONS
# ------------------

# ------
# INTERNAL FUNCTIONS
# ------
