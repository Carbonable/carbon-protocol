# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

# Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil

# Local dependencies
from tests.units.badge.library import setup, prepare, CarbonableBadge
from tests.library import assert_string

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_set_locked{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare minter instance
    let (str) = StringCodec.ss_to_string('ipfs://carbonable/')
    let name = 'Badge'
    let (local context) = prepare(uri_len=str.len, uri=str.data, name=name)

    let zero = Uint256(0, 0)
    let one = Uint256(1, 0)

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = FALSE

    CarbonableBadge.set_locked(zero)

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = TRUE

    CarbonableBadge.set_locked(zero)

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = TRUE

    let (locked_status) = CarbonableBadge.locked(one)
    assert locked_status = FALSE

    %{ stop() %}

    return ()
end

@external
func test_set_unlocked{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare minter instance
    let (str) = StringCodec.ss_to_string('ipfs://carbonalbe/{id}.json')
    let name = 'Badge'
    let (local context) = prepare(uri_len=str.len, uri=str.data, name=name)

    let zero = Uint256(0, 0)
    let one = Uint256(1, 0)

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = FALSE

    CarbonableBadge.set_unlocked(zero)

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = FALSE

    CarbonableBadge.set_locked(zero)

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = TRUE

    CarbonableBadge.set_locked(one)

    let (locked_status) = CarbonableBadge.locked(one)
    assert locked_status = TRUE

    CarbonableBadge.set_unlocked(zero)

    let (locked_status) = CarbonableBadge.locked(zero)
    assert locked_status = FALSE

    let (locked_status) = CarbonableBadge.locked(one)
    assert locked_status = TRUE

    %{ stop() %}

    return ()
end
