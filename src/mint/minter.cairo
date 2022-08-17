# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (minter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
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
func reserved_supply_for_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (reserved_supply_for_mint : Uint256):
    return CarbonableMinter.reserved_supply_for_mint()
end

@view
func max_supply_for_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    max_supply_for_mint : Uint256
):
    return CarbonableMinter.max_supply_for_mint()
end

@view
func whitelist_merkle_root{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    whitelist_merkle_root : felt
):
    return CarbonableMinter.whitelist_merkle_root()
end

@view
func whitelisted_slots{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account : felt, slots : felt, proof_len : felt, proof : felt*
) -> (slots : felt):
    return CarbonableMinter.whitelisted_slots(account, slots, proof_len, proof)
end

@view
func claimed_slots{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    account : felt
) -> (slots : felt):
    return CarbonableMinter.claimed_slots(account)
end
# ------
# CONSTRUCTOR
# ------

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt,
    project_nft_address : felt,
    payment_token_address : felt,
    public_sale_open : felt,
    max_buy_per_tx : felt,
    unit_price : Uint256,
    max_supply_for_mint : Uint256,
    reserved_supply_for_mint : Uint256,
):
    return CarbonableMinter.constructor(
        owner,
        project_nft_address,
        payment_token_address,
        public_sale_open,
        max_buy_per_tx,
        unit_price,
        max_supply_for_mint,
        reserved_supply_for_mint,
    )
end

# ------------------
# EXTERNAL FUNCTIONS
# ------------------

@external
func set_whitelist_merkle_root{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    whitelist_merkle_root : felt
):
    return CarbonableMinter.set_whitelist_merkle_root(whitelist_merkle_root)
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
func airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    to : felt, quantity : felt
) -> (success : felt):
    return CarbonableMinter.airdrop(to, quantity)
end

@external
func withdraw{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    success : felt
):
    return CarbonableMinter.withdraw()
end

@external
func transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token_address : felt, recipient : felt, amount : Uint256
) -> (success : felt):
    return CarbonableMinter.transfer(token_address, recipient, amount)
end

@external
func whitelist_buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    slots : felt, proof_len : felt, proof : felt*, quantity : felt
) -> (success : felt):
    return CarbonableMinter.whitelist_buy(slots, proof_len, proof, quantity)
end

@external
func public_buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    quantity : felt
) -> (success : felt):
    return CarbonableMinter.public_buy(quantity)
end
