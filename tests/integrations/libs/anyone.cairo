// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.libs.project import instance as carbonable_project_instance
from tests.integrations.libs.token import instance as payment_token_instance
from tests.integrations.libs.minter import instance as carbonable_minter_instance
from tests.integrations.libs.vester import instance as carbonable_vester_instance
from tests.integrations.libs.offseter import instance as carbonable_offseter_instance
from tests.integrations.libs.yielder import instance as carbonable_yielder_instance

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.anyone_account_contract %}
        return (address,);
    }

    func get_allocation() -> (allocation: felt) {
        let (address) = get_address();
        tempvar allocation;
        %{
            index = context.whitelist["recipients"].index(ids.address)
            ids.allocation = context.whitelist["allocations"][index]
        %}
        return (allocation,);
    }

    func get_proof_len() -> (proof_len: felt) {
        let (address) = get_address();
        tempvar proof_len;
        %{
            index = context.whitelist["recipients"].index(ids.address)
            ids.proof_len = len(context.whitelist["merkle_proofs"][index])
        %}
        return (proof_len,);
    }

    func get_proof() -> (proof: felt*) {
        alloc_locals;
        let (address) = get_address();
        let (local proof: felt*) = alloc();
        %{
            index = context.whitelist["recipients"].index(ids.address)
            merkle_proof = context.whitelist["merkle_proofs"][index]
            for idx, node in enumerate(merkle_proof):
                memory[ids.proof + idx] = node
        %}
        return (proof,);
    }

    // Token

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(value: felt) {
        let (caller) = get_address();
        let (contract_address) = carbonable_minter_instance.get_address();
        let (unit_price) = carbonable_minter_instance.get_unit_price();
        let allowance = unit_price * value;
        with caller {
            let (success) = payment_token_instance.approve(
                spender=contract_address, amount=allowance
            );
            assert success = TRUE;
            let (returned_allowance) = payment_token_instance.allowance(
                owner=caller, spender=contract_address
            );
            assert returned_allowance = allowance;
        }
        return ();
    }

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (success) = payment_token_instance.transfer(recipient=recipient, amount=amount);
            assert success = TRUE;
        }
        return ();
    }

    // Project

    func project_approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.approve(approved=approved, token_id=token_id);
        }
        return ();
    }

    func set_approval_for_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: felt, operator: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_project_instance.set_approval_for_slot(
                owner=caller, slot=slot, operator=operator, approved=TRUE
            );
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

    func whitelist_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt, force: felt
    ) {
        let (caller) = get_address();
        let (allocation) = get_allocation();
        let (proof_len) = get_proof_len();
        let (proof) = get_proof();
        with caller {
            let (success) = carbonable_minter_instance.pre_buy(
                allocation=allocation, proof_len=proof_len, proof=proof, value=value, force=force
            );
            assert success = TRUE;
        }
        return ();
    }

    func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt, force: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (success) = carbonable_minter_instance.public_buy(value=value, force=force);
            assert success = TRUE;
        }
        return ();
    }

    // Offseter

    func set_min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        min_claimable: felt
    ) {
        let (caller) = get_address();
        with caller {
            carbonable_offseter_instance.set_min_claimable(min_claimable=min_claimable);
            let (returned_min_claimable) = carbonable_offseter_instance.get_min_claimable();
            assert returned_min_claimable = min_claimable;
        }
        return ();
    }

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) {
        let (caller) = get_address();
        with caller {
            let (initial_claimable) = carbonable_offseter_instance.get_claimable_of(address=caller);
            let (initial_claimed) = carbonable_offseter_instance.get_claimed_of(address=caller);
            let (success) = carbonable_offseter_instance.claim(quantity=quantity);
            assert success = TRUE;
            let (returned_claimable) = carbonable_offseter_instance.get_claimable_of(
                address=caller
            );
            assert returned_claimable = initial_claimable - quantity;
            let (returned_claimed) = carbonable_offseter_instance.get_claimed_of(address=caller);
            assert returned_claimed = initial_claimed + quantity;
        }
        return ();
    }

    func claim_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_address();
        with caller {
            let (initial_claimable) = carbonable_offseter_instance.get_claimable_of(address=caller);
            let (initial_claimed) = carbonable_offseter_instance.get_claimed_of(address=caller);
            let (success) = carbonable_offseter_instance.claim_all();
            assert success = TRUE;
            let (returned_claimable) = carbonable_offseter_instance.get_claimable_of(
                address=caller
            );
            assert returned_claimable = 0;
            let (returned_claimed) = carbonable_offseter_instance.get_claimed_of(address=caller);
            assert returned_claimed = initial_claimed + initial_claimable;
        }
        return ();
    }

    func offseter_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt, value: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (initial_deposited) = carbonable_offseter_instance.get_deposited_of(address=caller);
            let (success) = carbonable_offseter_instance.deposit(token_id=token_id, value=value);
            assert success = TRUE;
            let (returned_deposited) = carbonable_offseter_instance.get_deposited_of(
                address=caller
            );
            assert returned_deposited = initial_deposited + value;
        }
        return ();
    }

    func offseter_withdraw_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (initial_deposited) = carbonable_offseter_instance.get_deposited_of(address=caller);
            let (success) = carbonable_offseter_instance.withdraw_to(value=value);
            assert success = TRUE;
            let (returned_deposited) = carbonable_offseter_instance.get_deposited_of(
                address=caller
            );
            assert returned_deposited = initial_deposited - value;
        }
        return ();
    }

    func offseter_withdraw_to_token{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt, value: felt) {
        let (caller) = get_address();
        with caller {
            let (initial_deposited) = carbonable_offseter_instance.get_deposited_of(address=caller);
            let (success) = carbonable_offseter_instance.withdraw_to_token(
                token_id=token_id, value=value
            );
            assert success = TRUE;
            let (returned_deposited) = carbonable_offseter_instance.get_deposited_of(
                address=caller
            );
            assert returned_deposited = initial_deposited - value;
        }
        return ();
    }

    // Yielder

    func yielder_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt, value: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (initial_deposited) = carbonable_yielder_instance.get_deposited_of(address=caller);
            let (success) = carbonable_yielder_instance.deposit(token_id=token_id, value=value);
            assert success = TRUE;
            let (returned_deposited) = carbonable_yielder_instance.get_deposited_of(address=caller);
            assert returned_deposited = initial_deposited + value;
        }
        return ();
    }

    func yielder_withdraw_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (initial_deposited) = carbonable_yielder_instance.get_deposited_of(address=caller);
            let (success) = carbonable_yielder_instance.withdraw_to(value=value);
            assert success = TRUE;
            let (returned_deposited) = carbonable_yielder_instance.get_deposited_of(address=caller);
            assert returned_deposited = initial_deposited - value;
        }
        return ();
    }

    func yielder_withdraw_to_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt, value: felt
    ) {
        let (caller) = get_address();
        with caller {
            let (initial_deposited) = carbonable_yielder_instance.get_deposited_of(address=caller);
            let (success) = carbonable_yielder_instance.withdraw_to_token(
                token_id=token_id, value=value
            );
            assert success = TRUE;
            let (returned_deposited) = carbonable_yielder_instance.get_deposited_of(address=caller);
            assert returned_deposited = initial_deposited - value;
        }
        return ();
    }

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_address();
        with caller {
            let (success) = carbonable_yielder_instance.snapshot();
            assert success = TRUE;
        }
        return ();
    }

    func create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) {
        let (caller) = get_address();
        with caller {
            let (success) = carbonable_yielder_instance.create_vestings(
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
            );
            assert success = TRUE;
        }
        return ();
    }

    // Vester

    func release_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_address();
        with caller {
            carbonable_vester_instance.release_all();
        }
        return ();
    }
}
