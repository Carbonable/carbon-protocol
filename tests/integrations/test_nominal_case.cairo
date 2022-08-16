# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Project dependencies
from tests.integrations.library import (
    carbonable_minter_instance,
    project_nft_instance,
    payment_token_instance,
    admin_instance as admin,
    anyone_instance as anyone,
)

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    tempvar carbonable_minter
    %{
        # --- INITIAL SETTINGS ---
        # User addresses
        context.ADMIN = 1000
        context.ANYONE = 1001
        # CarbonableProjectNFT
        context.NFT_NAME = 'Carbonable ERC-721 Test'
        context.NFT_SYMBOL = 'CET'
        # Payment token
        context.TOKEN_NAME = 'StableCoinToken'
        context.TOKEN_SYMBOL = 'SCT'
        context.TOKEN_DECIMALS = 6
        context.TOKEN_INITIAL_SUPPLY = 1000000
        # CarbonableMint
        context.WHITELISTED_SALE_OPEN = ids.TRUE
        context.PUBLIC_SALE_OPEN = ids.FALSE
        context.MAX_BUY_PER_TX = 5
        context.UNIT_PRICE = 10
        context.MAX_SUPPLY_FOR_MINT = 10

        # ERC-721 deployment
        context.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": context.NFT_NAME,
                "symbol": context.NFT_SYMBOL,
                "owner": context.ADMIN,
            },
        ).contract_address

        # ERC-20 deployment
        context.payment_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.TOKEN_NAME,
                "symbol": context.TOKEN_SYMBOL,
                "decimals": context.TOKEN_DECIMALS,
                "initial_supply": context.TOKEN_INITIAL_SUPPLY,
                "recipient": context.ANYONE
            },
        ).contract_address

        # Minter deployment
        context.carbonable_minter_contract = deploy_contract(
            "./src/mint/minter.cairo",
            {
                "owner": context.ADMIN,
                "project_nft_address": context.project_nft_contract,
                "payment_token_address": context.payment_token_contract,
                "whitelisted_sale_open": context.WHITELISTED_SALE_OPEN,
                "public_sale_open": context.PUBLIC_SALE_OPEN,
                "max_buy_per_tx": context.MAX_BUY_PER_TX,
                "unit_price": context.UNIT_PRICE,
                "max_supply_for_mint": context.MAX_SUPPLY_FOR_MINT,
            },
        ).contract_address
        ids.carbonable_minter = context.carbonable_minter_contract
    %}

    # Transfer project nft ownershop from admin to minter
    admin.transferOwnership(carbonable_minter)

    return ()
end

@view
func test_e2e_not_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: ANYONE
    # - wants to buy 6 NFTs (1 whitelist, 5 public)
    # - whitelisted: FALSE
    # - has enough funds: YES

    anyone.approve(quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: no whitelisted slot available") %}
    anyone.buy(quantity=1)
    admin.set_whitelisted_sale_open(FALSE)
    admin.set_public_sale_open(TRUE)
    anyone.approve(quantity=5)
    anyone.buy(quantity=5)

    return ()
end

@view
func test_e2e_airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: ADMIN
    # - set reserved supply to 4
    # User: ANYONE
    # - wants to buy 6 NFTs (5 whitelist, 2 public)
    # - whitelisted: TRUE
    # - has enough funds: YES
    # User: ADMIN
    # - aidrop 5 nft to ANYONE
    # - aidrop 4 nft to ANYONE
    alloc_locals
    let (anyone_address) = anyone.get_address()

    admin.set_reserved_supply_for_mint(4)
    admin.add_to_whitelist(account=anyone_address, slots=5)
    anyone.approve(quantity=5)
    anyone.buy(quantity=5)
    admin.set_whitelisted_sale_open(FALSE)
    admin.set_public_sale_open(TRUE)
    anyone.approve(quantity=2)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    anyone.buy(quantity=2)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved NFTs") %}
    admin.airdrop(to=anyone_address, quantity=5)
    admin.airdrop(to=anyone_address, quantity=4)

    return ()
end

@view
func test_e2e_over_airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: ADMIN
    # - set reserved supply to 10
    # User: ANYONE
    # - wants to buy 1 NFT1 (1 whitelist)
    # - whitelisted: TRUE
    # - has enough funds: YES
    # User: ADMIN
    # - aidrop 11 nft to ANYONE
    alloc_locals
    let (anyone_address) = anyone.get_address()

    admin.set_reserved_supply_for_mint(10)
    admin.add_to_whitelist(account=anyone_address, slots=1)
    anyone.approve(quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    anyone.buy(quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    admin.airdrop(to=anyone_address, quantity=11)

    return ()
end
