// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil

// Local dependencies
from tests.units.project.library import setup, prepare, CarbonableProject
from tests.library import assert_string

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_token_uri{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() {
    alloc_locals;

    // prepare project instance
    let (local context) = prepare();

    // run scenario
    let (str) = StringCodec.ss_to_string('ipfs://carbonable/');
    CarbonableProject.set_uri(uri_len=str.len, uri=str.data);

    let id = 0;
    let (len, array) = CarbonableProject.token_uri(Uint256(id, 0));
    let (returned_str) = StringCodec.ss_arr_to_string(len, array);

    let (json_str) = StringCodec.ss_to_string('token.json');
    let (expected_str) = StringUtil.path_join(str, json_str);

    assert_string(returned_str, expected_str);

    return ();
}
