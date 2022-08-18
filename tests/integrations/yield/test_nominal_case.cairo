# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Project dependencies

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    tempvar yield_manager
    %{
        # --- INITIAL SETTINGS ---
        # User addresses
        context.ADMIN = 1000
        context.ANYONE = 1001

        # CarbonableProjectNFT
        context.NFT_NAME = 'Carbonable ERC-721 Test'
        context.NFT_SYMBOL = 'CET'

        # Reward token
        context.TOKEN_NAME = 'StableCoinToken'
        context.TOKEN_SYMBOL = 'SCT'
        context.TOKEN_DECIMALS = 6
        context.TOKEN_INITIAL_SUPPLY = 1000000

        # Carbonable token
        context.CARBONABLE_TOKEN_NAME = 'Carbonable'
        context.CARBONABLE_TOKEN_SYMBOL = 'CARBZ'
        context.CARBONABLE_TOKEN_DECIMALS = 6
        context.CARBONABLE_TOKEN_INITIAL_SUPPLY = 1000000

        # ERC-721 deployment
        context.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": context.NFT_NAME,
                "symbol": context.NFT_SYMBOL,
                "owner": context.ADMIN,
            },
        ).contract_address

        # Reward token ERC-20 deployment
        context.reward_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.TOKEN_NAME,
                "symbol": context.TOKEN_SYMBOL,
                "decimals": context.TOKEN_DECIMALS,
                "initial_supply": context.TOKEN_INITIAL_SUPPLY,
                "recipient": context.ANYONE
            },
        ).contract_address

                # Carbonable token ERC-20 deployment
        context.carbonable_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.CARBONABLE_TOKEN_NAME,
                "symbol": context.CARBONABLE_TOKEN_SYMBOL,
                "decimals": context.CARBONABLE_TOKEN_DECIMALS,
                "initial_supply": context.CARBONABLE_TOKEN_INITIAL_SUPPLY,
                "recipient": context.ANYONE
            },
        ).contract_address

        # Yield Manager deployment
        context.yield_manager_contract = deploy_contract(
            "./src/yield/yield_manager.cairo",
            {
                "owner": context.ADMIN,
                "project_nft_address": context.project_nft_contract,
                "carbonable_token_address": context.carbonable_token_contract,
                "reward_token_address": context.reward_token_contract,
            },
        ).contract_address
        ids.yield_manager = context.yield_manager_contract
    %}

    return ()
end

@view
func test_e2e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    #

    return ()
end
