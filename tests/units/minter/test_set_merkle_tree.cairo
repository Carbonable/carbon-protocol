// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_set_whitelist_merkle_root_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // admin sets whitelist merkle root
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    %{ stop() %}

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    let (returned_slots) = CarbonableMinter.whitelisted_slots(
        account=context.signers.anyone,
        slots=context.whitelist.slots,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
    );
    assert returned_slots = context.whitelist.slots;
    %{ stop() %}
    return ();
}

@external
func test_set_merkle_tree_revert_if_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.set_whitelist_merkle_root(123);
    %{ stop() %}
    return ();
}
