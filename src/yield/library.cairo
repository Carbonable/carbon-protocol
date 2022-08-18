# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (mint/library.cairo)

%lang starknet
# Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from openzeppelin.security.safemath import SafeUint256
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.access.ownable import Ownable

# Address of the project NFT contract
@storage_var
func project_nft_address_() -> (res : felt):
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
    # -----
    # VIEWS
    # -----

    func project_nft_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (project_nft_address : felt):
        let (project_nft_address) = project_nft_address_.read()
        return (project_nft_address)
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

    # ------
    # CONSTRUCTOR
    # ------
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt,
        project_nft_address : felt,
        carbonable_token_address : felt,
        reward_token_address : felt,
    ):
        Ownable.initializer(owner)
        project_nft_address_.write(project_nft_address)
        carbonable_token_address_.write(carbonable_token_address)
        reward_token_address_.write(reward_token_address)
        return ()
    end
end
