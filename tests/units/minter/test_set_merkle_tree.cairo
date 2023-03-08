// SPDX-License-Identifier: MIT

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
        max_value_per_tx=5,
        min_value_per_tx=1,
        max_value=10,
        unit_price=10 * 10 ** 6,
        reserved_value=0,
    );

    // admin sets whitelist merkle root
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    %{ stop() %}

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    let (returned_allocation) = CarbonableMinter.whitelist_allocation(
        account=context.signers.anyone,
        allocation=context.whitelist.allocations,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
    );
    assert returned_allocation = context.whitelist.allocations;
    %{ stop() %}
    return ();
}
