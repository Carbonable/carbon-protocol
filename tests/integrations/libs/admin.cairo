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
from tests.integrations.libs.project import instance as carbonable_project_instance
from tests.integrations.libs.token import instance as payment_token_instance
from tests.integrations.libs.minter import instance as carbonable_minter_instance
// from tests.integrations.libs.vester import instance as carbonable_vester_instance
// from tests.integrations.libs.offseter import instance as carbonable_offseter_instance
// from tests.integrations.libs.yielder import instance as carbonable_yielder_instance

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.admin_account_contract %}
        return (address,);
    }

    // Token

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: felt
    ) {
        let (caller) = get_address();
        let (success) = payment_token_instance.transfer(
            recipient=recipient, amount=amount, caller=caller
        );
        assert success = TRUE;
        return ();
    }

    // Project

    func project_approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (caller) = get_address();
        carbonable_project_instance.approve(approved=approved, token_id=token_id, caller=caller);
        return ();
    }

    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, token_id: felt, slot: felt, value: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.mint(to=to, token_id=token_id, slot=slot, value=value);
        }
        return ();
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
        carbonable_project_instance.set_absorptions(
            slot=slot,
            times_len=times_len,
            times=times,
            absorptions_len=absorptions_len,
            absorptions=absorptions,
            ton_equivalent=ton_equivalent,
            caller=caller,
        );
        return ();
    }

    func add_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt, minter: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.add_minter(slot=slot, minter=minter);
        }
        return ();
    }

    func revoke_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt, minter: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.revoke_minter(slot=slot, minter=minter);
        }
        return ();
    }

    func set_certifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt, certifier: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.set_certifier(slot=slot, certifier=certifier);
        }
        return ();
    }

    // Minter

    func set_withdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        withdrawer: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_minter_instance.set_withdrawer(withdrawer=withdrawer);
        }
        return ();
    }

    func set_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        whitelist_merkle_root: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_minter_instance.set_whitelist_merkle_root(
                whitelist_merkle_root=whitelist_merkle_root
            );
            let (
                returned_whitelist_merkle_root
            ) = carbonable_minter_instance.get_whitelist_merkle_root();
            assert returned_whitelist_merkle_root = whitelist_merkle_root;
        }
        return ();
    }

    func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        public_sale_open: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_minter_instance.set_public_sale_open(public_sale_open=public_sale_open);
            let (returned_public_sale_open) = carbonable_minter_instance.is_public_sale_open();
            assert returned_public_sale_open = public_sale_open;
        }
        return ();
    }

    func set_max_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        max_value_per_tx: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_minter_instance.set_max_value_per_tx(max_value_per_tx=max_value_per_tx);
            let (returned_max_value_per_tx) = carbonable_minter_instance.get_max_value_per_tx();
            assert returned_max_value_per_tx = max_value_per_tx;
        }
        return ();
    }

    func set_min_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        min_value_per_tx: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_minter_instance.set_min_value_per_tx(min_value_per_tx=min_value_per_tx);
            let (returned_min_value_per_tx) = carbonable_minter_instance.get_min_value_per_tx();
            assert returned_min_value_per_tx = min_value_per_tx;
        }
        return ();
    }

    func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unit_price: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_minter_instance.set_unit_price(unit_price=unit_price);
            let (returned_unit_price) = carbonable_minter_instance.get_unit_price();
            assert returned_unit_price = unit_price;
        }
        return ();
    }

    func decrease_reserved_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (initial_value) = carbonable_minter_instance.get_reserved_value();
            carbonable_minter_instance.decrease_reserved_value(value=value);
            let (returned_value) = carbonable_minter_instance.get_reserved_value();
            assert returned_value = initial_value - value;
        }
        return ();
    }

    func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, value: felt
    ) {
        let (caller) = get_address();
        let (slot) = carbonable_minter_instance.carbonable_project_slot();
        with caller {
            let (initial_value) = carbonable_project_instance.total_value(slot=slot);
            carbonable_minter_instance.airdrop(to=to, value=value);
            let (returned_value) = carbonable_project_instance.total_value(slot=slot);
            assert returned_value = initial_value + value;
        }
        return ();
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_address();
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (initial_balance) = payment_token_instance.balance_of(account=caller);
        let (contract_balance) = payment_token_instance.balance_of(account=carbonable_minter);
        with caller {
            let (success) = carbonable_minter_instance.withdraw();
            assert success = TRUE;
        }
        let (returned_balance) = payment_token_instance.balance_of(account=caller);
        assert returned_balance = initial_balance + contract_balance;
        return ();
    }
}
