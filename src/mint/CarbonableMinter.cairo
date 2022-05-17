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

# Whether or not the whitelisted sale is open
@storage_var
func whitelisted_sale_open_() -> (res : felt):
end

# Whether or not the public sale is open
@storage_var
func public_sale_open_() -> (res : felt):
end

# Maximum number of NFTs possible to buy per transaction
@storage_var
func max_buy_per_tx_() -> (res : felt):
end

# -----
# VIEWS
# -----

@view
func project_nft_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    project_nft_address : felt
):
    return project_nft_address_.read()
end

@view
func whitelisted_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    whitelisted_sale_open : felt
):
    return whitelisted_sale_open_.read()
end

@view
func public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    public_sale_open : felt
):
    return public_sale_open_.read()
end

@view
func max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    max_buy_per_tx : felt
):
    return max_buy_per_tx_.read()
end

# ------
# CONSTRUCTOR
# ------

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt,
    project_nft_address : felt,
    whitelisted_sale_open : felt,
    public_sale_open : felt,
    max_buy_per_tx : felt,
):
    Ownable_initializer(owner)
    project_nft_address_.write(project_nft_address)
    whitelisted_sale_open_.write(whitelisted_sale_open)
    public_sale_open_.write(public_sale_open)
    max_buy_per_tx_.write(max_buy_per_tx)
    return ()
end

# ------------------
# EXTERNAL FUNCTIONS
# ------------------

@external
func set_whitelisted_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    whitelisted_sale_open : felt
):
    Ownable_only_owner()
    whitelisted_sale_open_.write(whitelisted_sale_open)
    return ()
end

@external
func set_public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    public_sale_open : felt
):
    Ownable_only_owner()
    public_sale_open_.write(public_sale_open)
    return ()
end

@external
func set_max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    max_buy_per_tx : felt
):
    Ownable_only_owner()
    max_buy_per_tx_.write(max_buy_per_tx)
    return ()
end

# ------
# INTERNAL FUNCTIONS
# ------
