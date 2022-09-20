// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check

// Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil
from openzeppelin.introspection.erc165.library import ERC165

const IERC5192_ID = 0xb45a3c0e;

//
// Events
//

@event
func Locked(token_id: Uint256) {
}

@event
func Unlocked(token_id: Uint256) {
}

//
// Storage
//

@storage_var
func CarbonableBadge_unlocked(id: Uint256) -> (unlocked: felt) {
}

@storage_var
func CarbonableBadge_name() -> (name: felt) {
}

namespace CarbonableBadge {
    //
    // Initializer
    //

    func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len: felt, uri: felt*, name: felt) {
        set_uri(uri_len, uri);
        ERC165.register_interface(IERC5192_ID);
        CarbonableBadge_name.write(name);
        return ();
    }

    //
    // Getters
    //

    func uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(id: Uint256) -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        uint256_check(id);

        let (uri_str) = StringCodec.read('uri');
        let (id_str) = StringCodec.felt_to_string(id.low);
        let (ext_str) = StringCodec.ss_to_string('.json');

        let (pre_str) = StringUtil.concat(uri_str, id_str);
        let (str) = StringUtil.concat(pre_str, ext_str);

        return (str.len, str.data);
    }

    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
        let (name) = CarbonableBadge_name.read();
        return (name,);
    }

    func locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) -> (
        is_locked: felt
    ) {
        uint256_check(id);

        let (is_unlocked) = CarbonableBadge_unlocked.read(id);
        return (1 - is_unlocked,);
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

    func set_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        id: Uint256
    ) -> () {
        uint256_check(id);

        CarbonableBadge_unlocked.write(id, FALSE);
        Locked.emit(id);

        return ();
    }

    func set_unlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        id: Uint256
    ) -> () {
        uint256_check(id);

        CarbonableBadge_unlocked.write(id, TRUE);
        Unlocked.emit(id);

        return ();
    }

    //
    // Internals
    //

    func assert_unlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        id: Uint256
    ) -> () {
        uint256_check(id);

        let (is_locked) = locked(id);
        with_attr error_message("CarbonableBadge: transfer is locked") {
            assert is_locked = FALSE;
        }
        return ();
    }

    func assert_unlocked_batch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ids_len: felt, ids: Uint256*
    ) -> () {
        _assert_unlocked_iter(ids_len=ids_len, ids=ids);
        return ();
    }

    func _assert_unlocked_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ids_len: felt, ids: Uint256*
    ) -> () {
        if (ids_len == 0) {
            return ();
        }

        assert_unlocked([ids]);
        _assert_unlocked_iter(ids_len=ids_len - 1, ids=ids + 1);

        return ();
    }
}
