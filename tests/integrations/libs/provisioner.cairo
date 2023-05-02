// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.libs.token import instance as payment_token_instance
from tests.integrations.libs.yielder import instance as carbonable_yielder_instance

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.provisioner_account_contract %}
        return (address,);
    }

    // Token

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: felt) {
        let (caller) = get_address();
        let (contract_address) = carbonable_yielder_instance.get_address();
        with caller {
            let (success) = payment_token_instance.approve(spender=contract_address, amount=amount);
            assert success = TRUE;
            let (allowance) = payment_token_instance.allowance(
                owner=caller, spender=contract_address
            );
            assert allowance = amount;
        }
        return ();
    }

    // Yielder

    func provision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: felt) {
        let (caller) = get_address();
        with caller {
            let (success) = carbonable_yielder_instance.provision(amount);
            assert success = TRUE;
        }
        return ();
    }
}
