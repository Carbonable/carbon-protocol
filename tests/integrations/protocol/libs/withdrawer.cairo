// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.cairo.common.math import assert_not_zero, assert_not_equal

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from tests.integrations.protocol.libs.project import instance as carbonable_project_instance
from tests.integrations.protocol.libs.token import instance as payment_token_instance
from tests.integrations.protocol.libs.minter import instance as carbonable_minter_instance
from tests.integrations.protocol.libs.vester import instance as carbonable_vester_instance
from tests.integrations.protocol.libs.offseter import instance as carbonable_offseter_instance
from tests.integrations.protocol.libs.yielder import instance as carbonable_yielder_instance

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
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        with payment_token {
            let (initial_balance) = payment_token_instance.balanceOf(account=caller);
            let (contract_balance) = payment_token_instance.balanceOf(account=carbonable_minter);
        }
        with carbonable_minter {
            let (success) = carbonable_minter_instance.withdraw(caller=caller);
            assert success = TRUE;
        }
        with payment_token {
            let (returned_balance) = payment_token_instance.balanceOf(account=caller);
            let (expected_balance) = SafeUint256.add(initial_balance, contract_balance);
            assert returned_balance = expected_balance;
        }
        return ();
    }
}
