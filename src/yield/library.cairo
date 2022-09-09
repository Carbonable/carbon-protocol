# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.access.ownable.library import Ownable

# Address of the project NFT contract
@storage_var
func carbonable_project_address_() -> (res : felt):
end

# Address of the reward token contract
@storage_var
func reward_token_address_() -> (res : felt):
end

# Address of the Carbonable token contract
@storage_var
func carbonable_token_address_() -> (res : felt):
end

namespace YieldManager:
    #
    # Constructor
    #

    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt,
        carbonable_project_address : felt,
        carbonable_token_address : felt,
        reward_token_address : felt,
    ):
        Ownable.initializer(owner)
        carbonable_project_address_.write(carbonable_project_address)
        carbonable_token_address_.write(carbonable_token_address)
        reward_token_address_.write(reward_token_address)
        return ()
    end

    #
    # Getters
    #

    func carbonable_project_address{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address : felt):
        let (carbonable_project_address) = carbonable_project_address_.read()
        return (carbonable_project_address)
    end

    func reward_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (reward_token_address : felt):
        let (reward_token_address) = reward_token_address_.read()
        return (reward_token_address)
    end

    func carbonable_token_address{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }() -> (carbonable_token_address : felt):
        let (carbonable_token_address) = carbonable_token_address_.read()
        return (carbonable_token_address)
    end
end
