// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check

// Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil

namespace Metadata {
    //
    // Getters
    //

    func token_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(token_id: Uint256) -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        with_attr error_message("Metadata: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        let (uri_str) = StringCodec.read('uri');
        let (token_id_str) = StringCodec.felt_to_string(token_id.low);
        let (ext_str) = StringCodec.ss_to_string('.json');

        let (json_str) = StringUtil.concat(token_id_str, ext_str);
        let (str) = StringUtil.path_join(uri_str, json_str);

        return (str.len, str.data);
    }

    func contract_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }() -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        let (uri_str) = StringCodec.read('uri');
        let (json_str) = StringCodec.ss_to_string('metadata.json');
        let (str) = StringUtil.path_join(uri_str, json_str);

        return (str.len, str.data);
    }

    //
    // Externals
    //

    func set_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len: felt, uri: felt*) {
        alloc_locals;

        let (str) = StringCodec.ss_arr_to_string(uri_len, uri);
        StringCodec.write('uri', str);
        return ();
    }
}
