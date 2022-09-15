// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil

// Local dependencies
from tests.units.badge.library import setup, prepare, CarbonableBadge
from tests.library import assert_string

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_assert_unlocked{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let (str) = StringCodec.ss_to_string('ipfs://carbonalbe/{id}.json');
    let name = 'Badge';
    let (local context) = prepare(uri_len=str.len, uri=str.data, name=name);

    let zero = Uint256(0, 0);

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: transfer is locked") %}
    CarbonableBadge.assert_unlocked(zero);

    CarbonableBadge.set_unlocked(zero);
    CarbonableBadge.assert_unlocked(zero);

    %{ stop() %}

    return ();
}

@external
func test_assert_unlocked_batch{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let (str) = StringCodec.ss_to_string('ipfs://carbonable/');
    let name = 'Badge';
    let (local context) = prepare(uri_len=str.len, uri=str.data, name=name);

    let zero = Uint256(0, 0);
    let one = Uint256(1, 0);
    let (local ids: Uint256*) = alloc();
    assert ids[0] = zero;
    assert ids[1] = one;

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: transfer is locked") %}
    CarbonableBadge.assert_unlocked_batch(2, ids);

    CarbonableBadge.set_unlocked(zero);

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: transfer is locked") %}
    CarbonableBadge.assert_unlocked_batch(2, ids);

    CarbonableBadge.set_unlocked(one);
    CarbonableBadge.assert_unlocked_batch(2, ids);

    CarbonableBadge.set_locked(zero);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: transfer is locked") %}
    CarbonableBadge.assert_unlocked_batch(2, ids);

    CarbonableBadge.set_locked(one);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableBadge: transfer is locked") %}
    CarbonableBadge.assert_unlocked_batch(2, ids);

    %{ stop() %}

    return ();
}
