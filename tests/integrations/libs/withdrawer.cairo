// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.libs.token import instance as payment_token_instance
from tests.integrations.libs.minter import instance as carbonable_minter_instance

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.withdrawer_account_contract %}
        return (address,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_address();
        with caller {
            let (carbonable_minter) = carbonable_minter_instance.get_address();
            let (initial_balance) = payment_token_instance.balance_of(account=caller);
            let (contract_balance) = payment_token_instance.balance_of(account=carbonable_minter);
            let (success) = carbonable_minter_instance.withdraw();
            assert success = TRUE;
            let (returned_balance) = payment_token_instance.balance_of(account=caller);
            assert returned_balance = initial_balance + contract_balance;
        }
        return ();
    }
}
