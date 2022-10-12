// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

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
func test_contract_uri{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare minter instance
    let (str) = StringCodec.ss_to_string('ipfs://carbonalbe/');
    let name = 'Badge';
    let (local context) = prepare(uri_len=str.len, uri=str.data, name=name);

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let (new_str) = StringCodec.ss_to_string('ipfs://carbonable/');
    CarbonableBadge.set_uri(uri_len=new_str.len, uri=new_str.data);

    let (len, array) = CarbonableBadge.contract_uri();
    let (returned_str) = StringCodec.ss_arr_to_string(len, array);

    let (metadata_str) = StringCodec.ss_to_string('metadata');
    let (ext_str) = StringCodec.ss_to_string('.json');
    let (pre_str) = StringUtil.concat(new_str, metadata_str);
    let (expected_str) = StringUtil.concat(pre_str, ext_str);

    assert_string(returned_str, expected_str);

    %{ stop() %}

    return ();
}
