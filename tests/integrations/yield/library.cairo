# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import yaml
        with open("./tests/integrations/yield/config.yml", 'r') as file_instance:
            config = yaml.safe_load(file_instance)
        for section, subconfig in config.items():
            for key, value in subconfig.items():
                name = f"{section.lower()}_{key.lower()}"
                setattr(context, name, value)

        # ERC-721 deployment
        context.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": context.nft_name,
                "symbol": context.nft_symbol,
                "owner": context.user_admin,
            },
        ).contract_address

        # Reward token ERC-20 deployment
        context.reward_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.token_name,
                "symbol": context.token_symbol,
                "decimals": context.token_decimals,
                "initial_supply": context.token_initial_supply,
                "recipient": context.user_anyone
            },
        ).contract_address

        # Carbonable token ERC-20 deployment
        context.carbonable_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": context.carbonable_token_name,
                "symbol": context.carbonable_token_symbol,
                "decimals": context.carbonable_token_decimals,
                "initial_supply": context.carbonable_token_initial_supply,
                "recipient": context.user_anyone
            },
        ).contract_address

        # Yield Manager deployment
        context.yield_manager_contract = deploy_contract(
            "./src/yield/yield_manager.cairo",
            {
                "owner": context.user_admin,
                "project_nft_address": context.project_nft_contract,
                "carbonable_token_address": context.carbonable_token_contract,
                "reward_token_address": context.reward_token_contract,
            },
        ).contract_address
    %}

    return ()
end
