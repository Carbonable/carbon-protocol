// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

// Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.string import String
from cairopen.string.utils import StringUtil

@storage_var
func CarbonableMetadata_implementation() -> (implementation: felt) {
}

namespace CarbonableMetadata {
    //
    // Getters
    //

    func get_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        implementation: felt
    ) {
        return CarbonableMetadata_implementation.read();
    }

    func token_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(slot: felt, value: felt, decimals: felt) -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        // [Effect] Compute and return corresponding token URI
        let (local slot_str) = StringCodec.felt_to_string(slot);
        let (local value_str) = StringCodec.felt_to_string(value);
        let (local decimals_str) = StringCodec.felt_to_string(decimals);

        let (str) = StringCodec.ss_to_string('https://dev-carbonable-metadata');
        let (str) = append_ss(str, '.fly.dev/collection');
        let (str) = StringUtil.path_join(str, slot_str);
        let (str) = append_ss(str, '/token?value=');
        let (str) = StringUtil.concat(str, value_str);
        let (str) = append_ss(str, '&decimals=');
        let (str) = StringUtil.concat(str, decimals_str);

        return (str.len, str.data);
    }

    func slot_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(slot: felt) -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        // [Effect] Compute and return corresponding slot URI
        let (local slot_str) = StringCodec.felt_to_string(slot);

        let (str) = StringCodec.ss_to_string('https://dev-carbonable-metadata');
        let (str) = append_ss(str, '.fly.dev/collection');
        let (str) = StringUtil.path_join(str, slot_str);

        return (str.len, str.data);
    }

    func contract_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }() -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        let (str) = StringCodec.ss_to_string('https://dev-carbonable-metadata');
        let (str) = append_ss(str, '.fly.dev/collection');

        return (str.len, str.data);
    }

    //
    // Externals
    //

    func set_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        implementation: felt
    ) {
        with_attr error_message("Metadata: implementation hash cannot be zero") {
            assert_not_zero(implementation);
        }

        CarbonableMetadata_implementation.write(implementation);
        return ();
    }
}

func append_ss{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(str: String, s: felt) -> (
    str: String
) {
    alloc_locals;
    let (tmp_str) = StringCodec.ss_to_string(s);
    let (res) = StringUtil.concat(str, tmp_str);
    return (str=res);
}
