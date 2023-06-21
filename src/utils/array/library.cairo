// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func Array_len_(key: felt) -> (len: felt) {
}

@storage_var
func Array_(key: felt, index: felt) -> (value: felt) {
}

namespace Array {
    func read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        key: felt, index: felt
    ) -> (value: felt) {
        let (value) = Array_.read(key, index);
        return (value=value);
    }
    func read_len{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(key: felt) -> (
        len: felt
    ) {
        let (len) = Array_len_.read(key);
        return (len=len);
    }

    func load{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(key: felt) -> (
        len: felt, values: felt*
    ) {
        alloc_locals;

        let (len) = Array_len_.read(key);
        let (local values: felt*) = alloc();

        // [Check] len is > 0
        if (len == 0) {
            return (len=len, values=values);
        }

        return _read_iter(key=key, index=len - 1, len=len, values=values);
    }

    func store{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        key: felt, len: felt, values: felt*
    ) {
        alloc_locals;

        Array_len_.write(key, len);
        _store_iter(key=key, index=len - 1, values=values);
        return ();
    }

    func add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        key: felt, value: felt
    ) {
        alloc_locals;

        let (index) = Array_len_.read(key);
        Array_.write(key, index, value);
        Array_len_.write(key, index + 1);
        return ();
    }

    func replace{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        key: felt, index: felt, value: felt
    ) {
        alloc_locals;
        Array_.write(key, index, value);
        return ();
    }

    func remove{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        key: felt, index: felt
    ) {
        alloc_locals;

        let (len, values) = Array.load(key=key);
        return _remove_iter(key=key, index=index, len=len, values=values);
    }
}

func _read_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    key: felt, index: felt, len: felt, values: felt*
) -> (len: felt, values: felt*) {
    alloc_locals;

    let (value) = Array_.read(key, index);
    assert values[index] = value;
    if (index == 0) {
        return (len=len, values=values);
    }
    return _read_iter(key=key, index=index - 1, len=len, values=values);
}

func _store_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    key: felt, index: felt, values: felt*
) {
    alloc_locals;

    Array_.write(key, index, values[index]);
    if (index == 0) {
        return ();
    }
    return _store_iter(key=key, index=index - 1, values=values);
}

func _remove_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    key: felt, index: felt, len: felt, values: felt*
) {
    alloc_locals;

    if (index == len - 1) {
        Array_len_.write(key, len - 1);
        return ();
    }

    Array_.write(key, index, values[index + 1]);
    return _remove_iter(key=key, index=index + 1, len=len, values=values);
}
