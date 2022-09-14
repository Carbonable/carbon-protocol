# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

# Starkware dependencies
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
func test_set_uri{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare minter instance
    let (str) = StringCodec.ss_to_string('ipfs://carbonalbe/')
    let name = 'Badge'
    let (local context) = prepare(uri_len=str.len, uri=str.data, name=name)

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let (new_str) = StringCodec.ss_to_string('ipfs://carbonable/')
    CarbonableBadge.set_uri(uri_len=new_str.len, uri=new_str.data)

    let id = 0
    let (len, array) = CarbonableBadge.uri(Uint256(id, 0))
    let (returned_str) = StringCodec.ss_arr_to_string(len, array)

    let (id_str) = StringCodec.felt_to_string(id)
    let (ext_str) = StringCodec.ss_to_string('.json')
    let (pre_str) = StringUtil.concat(new_str, id_str)
    let (expected_str) = StringUtil.concat(pre_str, ext_str)

    assert_string(returned_str, expected_str)

    %{ stop() %}

    return ()
end
