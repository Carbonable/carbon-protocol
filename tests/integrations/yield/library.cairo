# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/yield/config.yml", context)

        # ERC-721 deployment
        context.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": context.project.name,
                "symbol": context.project.symbol,
                "owner": context.signers.admin,
            },
        ).contract_address

        # Reward token ERC-20 deployment
        context.reward_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.token.name,
                "symbol": context.token.symbol,
                "decimals": context.token.decimals,
                "initial_supply": context.token.initial_supply,
                "recipient": context.signers.anyone
            },
        ).contract_address

        # Carbonable token ERC-20 deployment
        context.carbonable_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.carbonable_token.name,
                "symbol": context.carbonable_token.symbol,
                "decimals": context.carbonable_token.decimals,
                "initial_supply": context.carbonable_token.initial_supply,
                "recipient": context.signers.anyone
            },
        ).contract_address

        # Yield Manager deployment
        context.yield_manager_contract = deploy_contract(
            "./src/yield/yield_manager.cairo",
            {
                "owner": context.signers.admin,
                "project_nft_address": context.project_nft_contract,
                "carbonable_token_address": context.carbonable_token_contract,
                "reward_token_address": context.reward_token_contract,
            },
        ).contract_address
    %}

    return ()
end
