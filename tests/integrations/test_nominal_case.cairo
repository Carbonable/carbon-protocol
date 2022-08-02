# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256

# OpenZeppelin dependencies
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.security.safemath import SafeUint256

# Project dependencies
from tests.integrations.library import (
    carbonable_minter_instance,
    project_nft_instance,
    payment_token_instance,
    admin_instance,
    anyone_instance
)

# --- INITIAL STATE ---

# User addresses
const ADMIN = 1000
const ANYONE = 1001

# CarbonableProjectNFT
const NFT_NAME = 'Carbonable ERC-721 Test'
const NFT_SYMBOL = 'CET'

# Payment token
const TOKEN_NAME = 'StableCoinToken'
const TOKEN_SYMBOL = 'SCT'
const TOKEN_DECIMALS = 6
const TOKEN_INITIAL_SUPPLY = 1000000

# CarbonableMint
const WHITELISTED_SALE_OPEN = TRUE
const PUBLIC_SALE_OPEN = FALSE
const MAX_BUY_PER_TX = 5
const UNIT_PRICE = 10
const MAX_SUPPLY_FOR_MINT = 10

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_contract
    tempvar payment_token_contract
    tempvar carbonable_minter_contract
    %{
        # ERC-721 deployment
        ids.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": ids.NFT_NAME,
                "symbol": ids.NFT_SYMBOL,
                "owner": ids.ADMIN,
            },
        ).contract_address 
        context.project_nft_contract = ids.project_nft_contract

        # ERC-20 deployment
        ids.payment_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": ids.TOKEN_NAME,
                "symbol": ids.TOKEN_SYMBOL,
                "decimals": ids.TOKEN_DECIMALS,
                "initial_supply": ids.TOKEN_INITIAL_SUPPLY,
                "recipient": ids.ANYONE
            },
        ).contract_address 
        context.payment_token_contract = ids.payment_token_contract

        # Minter deployment
        ids.carbonable_minter_contract = deploy_contract(
            "./src/mint/minter.cairo",
            {
                "owner": ids.ADMIN,
                "project_nft_address": ids.project_nft_contract,
                "payment_token_address": ids.payment_token_contract,
                "whitelisted_sale_open": ids.WHITELISTED_SALE_OPEN,
                "public_sale_open": ids.PUBLIC_SALE_OPEN,
                "max_buy_per_tx": ids.MAX_BUY_PER_TX,
                "unit_price": ids.UNIT_PRICE,
                "max_supply_for_mint": ids.MAX_SUPPLY_FOR_MINT,
            },
        ).contract_address 
        context.carbonable_minter_contract = ids.carbonable_minter_contract

        context.admin = ids.ADMIN
        context.anyone = ids.ANYONE
    %}

    let (project_nft) = project_nft_instance.deployed()
    let (carbonable_minter) = carbonable_minter_instance.deployed()
    let (admin) = admin_instance.get_caller_address()

    with project_nft:
        project_nft_instance.transferOwnership(carbonable_minter, caller=admin)
        let (owner) = project_nft_instance.owner()
        assert owner = carbonable_minter
    end

    return ()
end

@view
func test_e2e_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    # User: ANYONE
    # - wants to buy 6 NFTs (5 whitelist, 1 public)
    # - whitelisted: TRUE
    # - has enough funds: YES
    alloc_locals
    let (admin) = admin_instance.get_caller_address()
    let (anyone) = anyone_instance.get_caller_address()

    admin_instance.add_to_whitelist(account=anyone, slots=5)
    anyone_instance.approve(quantity=5)
    anyone_instance.buy(quantity=5)
    admin_instance.set_whitelisted_sale_open(FALSE)
    admin_instance.set_public_sale_open(TRUE)
    anyone_instance.approve(quantity=1)
    anyone_instance.buy(quantity=1)

    return ()
end

@view
func test_e2e_not_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    # User: ANYONE
    # - wants to buy 6 NFTs (1 whitelist, 5 public)
    # - whitelisted: FALSE
    # - has enough funds: YES
    #
    # INITIAL STATE
    # ---
    # WHITELISTED_SALE_OPEN = TRUE
    # PUBLIC_SALE_OPEN = FALSE
    # MAX_BUY_PER_TX = 5
    # UNIT_PRICE = 10
    # MAX_SUPPLY_FOR_MINT = 10
    alloc_locals
    let (admin) = admin_instance.get_caller_address()
    let (anyone) = anyone_instance.get_caller_address()

    anyone_instance.approve(quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: no whitelisted slot available") %}
    anyone_instance.buy(quantity=1)
    admin_instance.set_whitelisted_sale_open(FALSE)
    admin_instance.set_public_sale_open(TRUE)
    anyone_instance.approve(quantity=5)
    anyone_instance.buy(quantity=5)

    return ()
end
