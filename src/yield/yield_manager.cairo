# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (yield_manager.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Local dependencies
from src.yield.library import YieldManager

#
# Constructor
#

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

#
# Getters
#

@view
func carbonable_project_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address : felt):
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
