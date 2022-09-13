# SPDX-License-Identifier: MIT
# OpenZeppelin Contracts for Cairo v0.2.1 (token/erc1155/library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check

# Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil
from openzeppelin.introspection.erc165.library import ERC165

const IERC5192_ID = 0xb45a3c0e

#
# Events
#

@event
func Locked(token_id : Uint256):
end

@event
func Unlocked(token_id : Uint256):
end

#
# Storage
#

@storage_var
func ERC5192_locked(id : Uint256) -> (locked : felt):
end

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
        set_uri(uri_len, uri)
        ERC165.register_interface(IERC5192_ID)
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

        uint256_check(id)

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

    func locked{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        id : Uint256
    ) -> (locked : felt):
        uint256_check(id)

        let (locked_status) = ERC5192_locked.read(id)
        return (locked_status)
    end

    #
    # Externals
    #

    func set_uri{
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

    func set_locked{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        id : Uint256
    ) -> ():
        uint256_check(id)

        ERC5192_locked.write(id, TRUE)
        Locked.emit(id)
        
        return ()
    end

    func set_unlocked{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        id : Uint256
    ) -> ():
        uint256_check(id)

        ERC5192_locked.write(id, FALSE)
        Unlocked.emit(id)
        
        return ()
    end

    #
    # Internals
    #

    func assert_unlocked{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        id : Uint256
    ) -> ():
        uint256_check(id)

        let (locked_status) = locked(id)
        with_attr error_message("CarbonableBadge: transfer is locked"):
            assert locked_status = FALSE
        end
        return ()
    end

    func assert_unlocked_batch{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ids_len : felt, ids : Uint256*
    ) -> ():
        _assert_unlocked_iter(ids_len=ids_len, ids=ids)
        return ()
    end

    func _assert_unlocked_iter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ids_len : felt, ids : Uint256*
    ) -> ():
        if ids_len == 0:
            return ()
        end

        assert_unlocked([ids])
        _assert_unlocked_iter(ids_len=ids_len - 1, ids=ids + 1)

        return ()
    end
end
