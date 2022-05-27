# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (CarbonableMinter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_le
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.bool import TRUE, FALSE

from openzeppelin.security.safemath import uint256_checked_add, uint256_checked_mul
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.token.erc721.interfaces.IERC721 import IERC721
from openzeppelin.token.erc721_enumerable.interfaces.IERC721_Enumerable import IERC721_Enumerable

from openzeppelin.access.ownable import Ownable_initializer, Ownable_only_owner

from src.mint.library import CarbonableMinter

# -----
# VIEWS
# -----

@view
func project_nft_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    project_nft_address : felt
):
    return CarbonableMinter.project_nft_address()
end

@view
func payment_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    payment_token_address : felt
):
    return CarbonableMinter.payment_token_address()
end

@view
func whitelisted_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    whitelisted_sale_open : felt
):
    return CarbonableMinter.whitelisted_sale_open()
end

@view
func public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    public_sale_open : felt
):
    return CarbonableMinter.public_sale_open()
end

@view
func max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    max_buy_per_tx : felt
):
    return CarbonableMinter.max_buy_per_tx()
end

@view
func unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    unit_price : Uint256
):
    return CarbonableMinter.unit_price()
end

@view
func max_supply_for_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    max_supply_for_mint : Uint256
):
    return CarbonableMinter.max_supply_for_mint()
end

@view
func whitelist{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account : felt
) -> (slots : Uint256):
    return CarbonableMinter.whitelist(account)
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
    return CarbonableMinter.constructor(
        owner,
        project_nft_address,
        payment_token_address,
        whitelisted_sale_open,
        public_sale_open,
        max_buy_per_tx,
        unit_price,
        max_supply_for_mint,
    )
end

# ------------------
# EXTERNAL FUNCTIONS
# ------------------

@external
func set_whitelisted_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    whitelisted_sale_open : felt
):
    return CarbonableMinter.set_whitelisted_sale_open(whitelisted_sale_open)
end

@external
func set_public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    public_sale_open : felt
):
    return CarbonableMinter.set_public_sale_open(public_sale_open)
end

@external
func set_max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    max_buy_per_tx : felt
):
    return CarbonableMinter.set_max_buy_per_tx(max_buy_per_tx)
end

@external
func set_unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    unit_price : Uint256
):
    return CarbonableMinter.set_unit_price(unit_price)
end

@external
func add_to_whitelist{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account : felt, slots : Uint256
):
    return CarbonableMinter.add_to_whitelist(account, slots)
end

@external
func buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(quantity : Uint256) -> (
    success : felt
):
    return CarbonableMinter.buy(quantity)
end
