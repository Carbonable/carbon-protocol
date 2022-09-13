# SPDX-License-Identifier: MIT
# OpenZeppelin Contracts for Cairo v0.2.1 (token/erc1155/library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

# Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil

#
# Storage
#

@storage_var
func CarbonableBadge_name() -> (name : felt):
end

namespace CarbonableBadge:
    #
    # Initializer
    #

    func initializer{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len : felt, uri : felt*, name : felt):
        _set_uri(uri_len, uri)
        CarbonableBadge_name.write(name)
        return ()
    end

    #
    # Getters
    #

    func uri{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(id : Uint256) -> (uri_len : felt, uri : felt*):
        alloc_locals

        let (str_uri) = StringCodec.read('uri')
        let (str_id) = StringCodec.felt_to_string(id.low)
        let (str_ext) = StringCodec.ss_to_string('.json')

        let (prestr) = StringUtil.concat(str_uri, str_id)
        let (str) = StringUtil.concat(prestr, str_ext)
        return (str.len, str.data)
    end

    func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
        let (name) = CarbonableBadge_name.read()
        return (name)
    end

    #
    # Externals
    #

    func _set_uri{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len : felt, uri : felt*):
        alloc_locals

        let (str) = StringCodec.ss_arr_to_string(uri_len, uri)
        StringCodec.write('uri', str)
        return ()
    end
end
