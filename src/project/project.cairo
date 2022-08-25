# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (project.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from openzeppelin.token.erc721_enumerable.ERC721_Enumerable_Mintable_Burnable import constructor

# Local dependencies
from src.project.library import CarbonableProject

#
# Getters
#

@view
func image_url{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    image_url_len : felt, image_url : felt*
):
    return CarbonableProject.image_url()
end

#
# Externals
#

@external
func set_image_url{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    image_url_len : felt, image_url : felt*
) -> ():
    return CarbonableProject.set_image_url(image_url_len, image_url)
end
