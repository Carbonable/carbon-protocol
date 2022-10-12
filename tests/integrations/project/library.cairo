// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Project dependencies
from cairopen.string.ASCII import StringCodec

// Local dependencies
from interfaces.project import ICarbonableProject
from tests.library import assert_string

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/project/config.yml", context)

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
    %}

    return ();
}

namespace carbonable_project_instance {
    // Internals

    func deployed() -> (carbonable_project_contract: felt) {
        tempvar carbonable_project_contract;
        %{ ids.carbonable_project_contract = context.carbonable_project_contract %}
        return (carbonable_project_contract,);
    }
}

namespace admin_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar admin;
        %{ ids.admin = context.admin_account_contract %}
        return (admin,);
    }
}
