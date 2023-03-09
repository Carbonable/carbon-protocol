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
        %{ ids.address = context.anyone_account_contract %}
        return (address,);
    }

    func get_slots() -> (slots: felt) {
        let (address) = get_address();
        tempvar slots;
        %{
            index = context.whitelist["recipients"].index(ids.address)
            ids.slots = context.whitelist["slots"][index]
        %}
        return (slots,);
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

    // Project

    func project_approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.approve(
                approved=approved, token_id=token_id_uint256, caller=caller
            );
        }
        return ();
    }

    // Token

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            let (unit_price) = carbonable_minter_instance.unit_price();
            let (allowance) = SafeUint256.mul(Uint256(quantity, 0), unit_price);
        }
        with payment_token {
            let (success) = payment_token_instance.approve(
                spender=carbonable_minter, amount=allowance, caller=caller
            );
            assert success = TRUE;
            let (returned_allowance) = payment_token_instance.allowance(
                owner=caller, spender=carbonable_minter
            );
            assert returned_allowance = allowance;
        }
        return ();
    }

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: felt
    ) {
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        let amount_uint256 = Uint256(low=amount, high=0);
        with payment_token {
            let (success) = payment_token_instance.transfer(
                recipient=recipient, amount=amount_uint256, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    // Minter

    func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        public_sale_open: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_public_sale_open(
                public_sale_open=public_sale_open, caller=caller
            );
            let (returned_public_sale_open) = carbonable_minter_instance.public_sale_open();
            assert returned_public_sale_open = public_sale_open;
        }
        return ();
    }

    func set_max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        max_buy_per_tx: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_max_buy_per_tx(
                max_buy_per_tx=max_buy_per_tx, caller=caller
            );
            let (returned_max_buy_per_tx) = carbonable_minter_instance.max_buy_per_tx();
            assert returned_max_buy_per_tx = max_buy_per_tx;
        }
        return ();
    }

    func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unit_price: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        let unit_price_uint256 = Uint256(unit_price, 0);
        with carbonable_minter {
            carbonable_minter_instance.set_unit_price(unit_price=unit_price_uint256, caller=caller);
            let (returned_unit_price) = carbonable_minter_instance.unit_price();
            assert returned_unit_price = unit_price_uint256;
        }
        return ();
    }

    func whitelist_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        let (slots) = get_slots();
        let (proof_len) = get_proof_len();
        let (proof) = get_proof();

        // get user nft and payment token balances to check after buy
        with carbonable_project {
            let (initial_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (intial_total_supply) = carbonable_project_instance.totalSupply();
        }
        with payment_token {
            let (initial_balance) = payment_token_instance.balanceOf(account=caller);
        }

        // make the user to buy the quantity
        with carbonable_minter {
            let (whitelist_merkle_root) = carbonable_minter_instance.whitelist_merkle_root();
            let (unit_price) = carbonable_minter_instance.unit_price();
            let (success) = carbonable_minter_instance.whitelist_buy(
                slots=slots, proof_len=proof_len, proof=proof, quantity=quantity, caller=caller
            );
            assert success = TRUE;
        }

        // check total supply and user nft quantity after buy
        with carbonable_project {
            let (returned_total_supply) = carbonable_project_instance.totalSupply();
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            );
            assert expected_total_supply = Uint256(quantity, 0);

            let (returned_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity);
            assert expected_quantity = Uint256(quantity, 0);
        }

        // check user payment token balance after buy
        with payment_token {
            let (returned_balance) = payment_token_instance.balanceOf(account=caller);
            let (expected_spend) = SafeUint256.sub_le(initial_balance, returned_balance);
            let (spend) = SafeUint256.mul(Uint256(quantity, 0), unit_price);
            assert expected_spend = spend;
        }
        return ();
    }

    func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();

        // get user nft and payment token balances to check after buy
        with carbonable_project {
            let (initial_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (intial_total_supply) = carbonable_project_instance.totalSupply();
        }
        with payment_token {
            let (initial_balance) = payment_token_instance.balanceOf(account=caller);
        }

        // make the user to buy the quantity
        with carbonable_minter {
            let (unit_price) = carbonable_minter_instance.unit_price();
            let (success) = carbonable_minter_instance.public_buy(quantity=quantity, caller=caller);
            assert success = TRUE;
        }

        // check total supply and user nft quantity after buy
        with carbonable_project {
            let (returned_total_supply) = carbonable_project_instance.totalSupply();
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            );
            assert expected_total_supply = Uint256(quantity, 0);

            let (returned_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity);
            assert expected_quantity = Uint256(quantity, 0);
        }

        // check user payment token balance after buy
        with payment_token {
            let (returned_balance) = payment_token_instance.balanceOf(account=caller);
            let (expected_spend) = SafeUint256.sub_le(initial_balance, returned_balance);
            let (spend) = SafeUint256.mul(Uint256(quantity, 0), unit_price);
            assert expected_spend = spend;
        }
        return ();
    }

    // Offseter

    func offseter_total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (balance: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.total_deposited();
        }
        return (balance=balance.low);
    }

    func offseter_total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (total_claimed: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (total_claimed) = carbonable_offseter_instance.total_claimed();
        }
        return (total_claimed=total_claimed);
    }

    func offseter_total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (total_claimable: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (total_claimable) = carbonable_offseter_instance.total_claimable();
        }
        return (total_claimable=total_claimable);
    }

    func offseter_claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (claimable) = carbonable_offseter_instance.claimable_of(address=address);
        }
        return (claimable=claimable);
    }

    func offseter_claimed_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimed: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (claimed) = carbonable_offseter_instance.claimed_of(address=address);
        }
        return (claimed=claimed);
    }

    func offseter_registered_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_offseter {
            let (address) = carbonable_offseter_instance.registered_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address);
    }

    func offseter_registered_time_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (time: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_offseter {
            let (time) = carbonable_offseter_instance.registered_time_of(token_id=token_id_uint256);
        }
        return (time=time);
    }

    func offseter_claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.claim(quantity=quantity, caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func offseter_claim_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.claim_all(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func offseter_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.deposit(
                token_id=token_id_uint256, caller=caller
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        return ();
    }

    func offseter_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.withdraw(
                token_id=token_id_uint256, caller=caller
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }

    func offseter_transferOwnership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(newOwner: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            carbonable_offseter_instance.renounceOwnership(newOwner=newOwner, caller=caller);
            let (owner) = carbonable_offseter_instance.owner();
            assert owner = newOwner;
        }
        return ();
    }

    func offseter_renounceOwnership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            carbonable_offseter_instance.renounceOwnership(caller=caller);
            let (owner) = carbonable_offseter_instance.owner();
            assert owner = 0;
        }
        return ();
    }

    // Yielder

    func yielder_total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (balance: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (balance) = carbonable_yielder_instance.total_deposited();
        }
        return (balance=balance.low);
    }

    func yielder_total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (total_absorption: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (total_absorption) = carbonable_yielder_instance.total_absorption();
        }
        return (total_absorption=total_absorption);
    }

    func yielder_absorption_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (absorption) = carbonable_yielder_instance.absorption_of(address=address);
        }
        return (absorption=absorption);
    }

    func yielder_registered_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (address: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_yielder {
            let (address) = carbonable_yielder_instance.registered_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address);
    }

    func yielder_registered_time_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (time: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_yielder {
            let (time) = carbonable_yielder_instance.registered_time_of(token_id=token_id_uint256);
        }
        return (time=time);
    }

    func snapshoted_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (time: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (time) = carbonable_yielder_instance.snapshoted_time();
        }
        return (time=time);
    }

    func yielder_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.deposit(
                token_id=token_id_uint256, caller=caller
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_yielder;
        }
        return ();
    }

    func yielder_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_yielder;
        }
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.withdraw(
                token_id=token_id_uint256, caller=caller
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
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

    func create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (caller) = get_address();

        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.create_vestings(
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                caller=caller,
            );
            assert success = TRUE;
        }
        return ();
    }

    // Vester

    func get_vesting_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        vesting_id: felt
    ) {
        alloc_locals;
        let zero = Uint256(low=0, high=0);
        let (carbonable_vester) = carbonable_vester_instance.get_address();
        let (caller) = get_address();

        with carbonable_vester {
            let (vesting_count) = carbonable_vester_instance.vesting_count(caller);
            assert_not_equal(vesting_count, 0);

            let (vesting_id) = carbonable_vester_instance.get_vesting_id(vesting_count - 1, caller);
            assert_not_equal(vesting_id, 0);
        }
        return (vesting_id=vesting_id);
    }

    func releasable_amount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        vesting_id: felt
    ) -> (releasable_amount: Uint256) {
        alloc_locals;
        let zero = Uint256(low=0, high=0);
        let (carbonable_vester) = carbonable_vester_instance.get_address();
        let (caller) = get_address();

        with carbonable_vester {
            let (releasable_amount) = carbonable_vester_instance.releasable_amount(
                vesting_id, caller
            );
        }

        return (releasable_amount=releasable_amount);
    }

    func releasable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (releasable_amount: Uint256) {
        alloc_locals;
        let zero = Uint256(low=0, high=0);
        let (carbonable_vester) = carbonable_vester_instance.get_address();
        let (caller) = get_address();

        with carbonable_vester {
            let (releasable_amount) = carbonable_vester_instance.releasable_of(account, caller);
        }

        return (releasable_amount=releasable_amount);
    }

    func released_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (released_amount: Uint256) {
        alloc_locals;
        let zero = Uint256(low=0, high=0);
        let (carbonable_vester) = carbonable_vester_instance.get_address();
        let (caller) = get_address();

        with carbonable_vester {
            let (released_amount) = carbonable_vester_instance.released_of(account, caller);
        }

        return (released_amount=released_amount);
    }

    func release_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_vester) = carbonable_vester_instance.get_address();
        let (caller) = get_address();

        with carbonable_vester {
            carbonable_vester_instance.release_all(caller=caller);
        }
        return ();
    }

    func initialize_migration{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        source_address: felt, target_address: felt, slot: felt
    ) {
        let slot_u256 = Uint256(low=slot, high=0);
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.initialize_migration(
                source_address=source_address,
                target_address=target_address,
                slot=slot_u256,
                caller=caller,
            );
        }
        return ();
    }

    func migrate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (new_token_id: felt) {
        let token_id_u256 = Uint256(low=token_id, high=0);
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            let (new_token_id) = carbonable_minter_instance.migrate(
                tokenId=token_id_u256, caller=caller
            );
        }
        return (new_token_id=new_token_id.low);
    }
}
