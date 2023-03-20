// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.libs.project import instance as carbonable_project_instance

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.certifier_account_contract %}
        return (address,);
    }

    func set_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt,
        times_len: felt,
        times: felt*,
        absorptions_len: felt,
        absorptions: felt*,
        ton_equivalent: felt,
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.set_absorptions(
                slot=slot,
                times_len=times_len,
                times=times,
                absorptions_len=absorptions_len,
                absorptions=absorptions,
                ton_equivalent=ton_equivalent,
            );
        }
        return ();
    }
}
