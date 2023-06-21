// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.utils.array.library import Array


@external
func test_store_read{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let input_len = 3;
    let (local input : felt*) = alloc();
    assert input[0] = 10;
    assert input[1] = 20;
    assert input[2] = 30;

    Array.store(key='test', len=input_len, values=input);
    let (len, output) = Array.load(key='test');
    assert len = input_len;
    let value = output[0];
    assert value = input[0];
    let value = output[1];
    assert value = input[1];
    let value = output[2];
    assert value = input[2];

    let (len) = Array.read_len(key='test');
    assert len = input_len;

    let (value) = Array.read(key='test', index=len - 1);
    assert value = input[2];

    return ();
}

@external
func test_add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let input_len = 3;
    let (local input : felt*) = alloc();
    assert input[0] = 10;
    assert input[1] = 20;
    assert input[2] = 30;

    Array.store(key='test', len=input_len, values=input);
    Array.add(key='test', value=40);

    let (len, output) = Array.load(key='test');
    assert len = 4;
    let value = output[0];
    assert value = input[0];
    let value = output[1];
    assert value = input[1];
    let value = output[2];
    assert value = input[2];
    let value = output[3];
    assert value = 40;

    return ();
}

@external
func test_add_from_scratch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    Array.add(key='test', value=40);

    let (len, output) = Array.load(key='test');
    assert len = 1;
    let value = output[0];
    assert value = 40;

    return ();
}

@external
func test_replace{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let input_len = 3;
    let (local input : felt*) = alloc();
    assert input[0] = 10;
    assert input[1] = 20;
    assert input[2] = 30;

    Array.store(key='test', len=input_len, values=input);
    Array.replace(key='test', index=1, value=25);

    let (len, output) = Array.load(key='test');
    assert len = 3;
    let value = output[0];
    assert value = input[0];
    let value = output[1];
    assert value = 25;
    let value = output[2];
    assert value = input[2];

    return ();
}

@external
func test_remove{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let input_len = 3;
    let (local input : felt*) = alloc();
    assert input[0] = 10;
    assert input[1] = 20;
    assert input[2] = 30;

    Array.store(key='test', len=input_len, values=input);
    Array.remove(key='test', index=1);

    let (len, output) = Array.load(key='test');
    assert len = 2;
    let value = output[0];
    assert value = input[0];
    let value = output[1];
    assert value = input[2];

    return ();
}