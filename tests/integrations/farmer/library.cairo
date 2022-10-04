// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/farmer/config.yml", context)

        # Admin account deployment
        context.admin_account_contract = deploy_contract(
            context.sources.account,
            {
                "public_key": context.signers.admin,
            },
        ).contract_address

        # Anyone account deployment
        context.anyone_account_contract = deploy_contract(
            context.sources.account,
            {
                "public_key": context.signers.anyone,
            },
        ).contract_address

        # Carbonable project deployment
        context.carbonable_project_contract = deploy_contract(
            context.sources.project,
            {
                "name": context.project.name,
                "symbol": context.project.symbol,
                "owner": context.admin_account_contract,
            },
        ).contract_address

        # Reward token ERC-20 deployment
        context.reward_token_contract = deploy_contract(
            context.sources.token,
            {
                "name": context.token.name,
                "symbol": context.token.symbol,
                "decimals": context.token.decimals,
                "initial_supply": context.token.initial_supply,
                "recipient": context.anyone_account_contract
            },
        ).contract_address

        # Carbonable token ERC-20 deployment
        context.carbonable_token_contract = deploy_contract(
            context.sources.token,
            {
                "name": context.carbonable_token.name,
                "symbol": context.carbonable_token.symbol,
                "decimals": context.carbonable_token.decimals,
                "initial_supply": context.carbonable_token.initial_supply,
                "recipient": context.anyone_account_contract
            },
        ).contract_address

        # Carbonable farmer deployment
        context.carbonable_farmer_contract = deploy_contract(
            context.sources.farmer,
            {
                "owner": context.admin_account_contract,
                "carbonable_project_address": context.carbonable_project_contract,
                "carbonable_token_address": context.carbonable_token_contract,
                "reward_token_address": context.reward_token_contract,
            },
        ).contract_address
    %}

    return ();
}
