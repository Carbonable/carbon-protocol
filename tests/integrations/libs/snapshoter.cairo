// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.libs.yielder import instance as carbonable_yielder_instance

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.snapshoter_account_contract %}
        return (address,);
    }

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (caller) = get_address();

        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.snapshot(caller=caller);
            assert success = TRUE;
        }
        return ();
    }
}
