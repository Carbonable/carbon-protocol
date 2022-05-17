# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (CarbonableMinter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_le
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.bool import TRUE, FALSE

from openzeppelin.security.safemath import uint256_checked_add, uint256_checked_mul
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.token.erc721.interfaces.IERC721 import IERC721
from openzeppelin.token.erc721_enumerable.interfaces.IERC721_Enumerable import IERC721_Enumerable

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

# Address of the project NFT contract
@storage_var
func payment_token_address_() -> (res : felt):
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

# NFT unit price (expressed in payment token address)
@storage_var
func unit_price_() -> (res : Uint256):
end

# Total supply
@storage_var
func max_supply_for_mint_() -> (res : Uint256):
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
func payment_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    payment_token_address : felt
):
    return payment_token_address_.read()
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

@view
func unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    unit_price : Uint256
):
    return unit_price_.read()
end

@view
func max_supply_for_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    max_supply_for_mint : Uint256
):
    return max_supply_for_mint_.read()
end

# ------
# CONSTRUCTOR
# ------

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt,
    project_nft_address : felt,
    payment_token_address : felt,
    whitelisted_sale_open : felt,
    public_sale_open : felt,
    max_buy_per_tx : felt,
    unit_price : Uint256,
    max_supply_for_mint : Uint256,
):
    Ownable_initializer(owner)
    project_nft_address_.write(project_nft_address)
    payment_token_address_.write(payment_token_address)
    whitelisted_sale_open_.write(whitelisted_sale_open)
    public_sale_open_.write(public_sale_open)
    max_buy_per_tx_.write(max_buy_per_tx)
    unit_price_.write(unit_price)
    max_supply_for_mint_.write(max_supply_for_mint)
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

@external
func set_unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    unit_price : Uint256
):
    Ownable_only_owner()
    unit_price_.write(unit_price)
    return ()
end

@external
func buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(quantity : Uint256) -> (
    success : felt
):
    alloc_locals
    # Get variables through system calls
    let (caller) = get_caller_address()
    let (contract_address) = get_contract_address()

    # Check preconditions
    with_attr error_message("CarbonableMinter: caller is the zero address"):
        assert_not_zero(caller)
    end

    # Get storage variables
    let (project_nft_address) = project_nft_address_.read()
    let (unit_price) = unit_price_.read()
    let (payment_token_address) = payment_token_address_.read()

    # Check if enough NFTs available
    let (total_supply) = IERC721_Enumerable.totalSupply(project_nft_address)
    let (supply_after_buy) = uint256_checked_add(total_supply, quantity)
    let (max_supply_for_mint) = max_supply_for_mint_.read()
    let (enough_left) = uint256_le(supply_after_buy, max_supply_for_mint)
    with_attr error_message("CarbonableMinter: not enough available NFTs"):
        assert enough_left = TRUE
    end

    # Compute mint price
    let (amount) = uint256_checked_mul(quantity, unit_price)

    # Do ERC20 transfer
    let (transfer_success) = IERC20.transferFrom(
        payment_token_address, caller, contract_address, amount
    )
    with_attr error_message("CarbonableMinter: transfer failed"):
        assert transfer_success = TRUE
    end

    # Success
    return (TRUE)
end

# ------
# INTERNAL FUNCTIONS
# ------
