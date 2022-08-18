# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (yield_manager.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.yield.library import YieldManager

# -----
# VIEWS
# -----

@view
func project_nft_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    project_nft_address : felt
):
    return YieldManager.project_nft_address()
end

@view
func reward_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    reward_token_address : felt
):
    return YieldManager.reward_token_address()
end

@view
func carbonable_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_token_address : felt):
    return YieldManager.carbonable_token_address()
end

# ------
# CONSTRUCTOR
# ------

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt,
    project_nft_address : felt,
    carbonable_token_address : felt,
    reward_token_address : felt,
):
    return YieldManager.constructor(
        owner, project_nft_address, carbonable_token_address, reward_token_address
    )
end
