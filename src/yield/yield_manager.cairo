# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (yield_manager.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.yield.library import YieldManager

# -----
# VIEWS
# -----

@view
func carbonable_project_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    carbonable_project_address : felt
):
    return YieldManager.carbonable_project_address()
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
    carbonable_project_address : felt,
    carbonable_token_address : felt,
    reward_token_address : felt,
):
    return YieldManager.constructor(
        owner, carbonable_project_address, carbonable_token_address, reward_token_address
    )
end
