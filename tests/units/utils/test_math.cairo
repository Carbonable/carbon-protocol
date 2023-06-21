// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.utils.math.library import Math, CONSTANT, NULL, CONST_LEFT, CONST_RIGHT, LINEAR

@external
func test_max{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    assert Math.max(1, 2) = 2;
    assert Math.max(1, 2) = Math.max(2, 1);
    return ();
}

@external
func test_min{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    assert Math.min(1, 2) = 1;
    assert Math.min(1, 2) = Math.min(2, 1);
    return ();
}

@external
func test_linear_interpolate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (local ys: felt*) = alloc();
    assert ys[0] = 100;
    assert ys[1] = 200;
    assert ys[2] = 300;

    let y = Math.interpolate(
        x=15, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=CONSTANT
    );
    assert y = 150;

    let y = Math.interpolate(
        x=0, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=CONSTANT
    );
    assert y = 100;

    let y = Math.interpolate(
        x=40, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=CONSTANT
    );
    assert y = 300;

    let y = Math.interpolate(x=0, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=NULL);
    assert y = 0;

    let y = Math.interpolate(x=40, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=NULL);
    assert y = 0;

    return ();
}

@external
func test_const_left_interpolate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (local ys: felt*) = alloc();
    assert ys[0] = 100;
    assert ys[1] = 200;
    assert ys[2] = 300;

    let y = Math.interpolate(
        x=15, len=3, xs=xs, ys=ys, interpolation=CONST_LEFT, extrapolation=CONSTANT
    );
    assert y = 200;

    let y = Math.interpolate(
        x=0, len=3, xs=xs, ys=ys, interpolation=CONST_LEFT, extrapolation=CONSTANT
    );
    assert y = 100;

    let y = Math.interpolate(
        x=40, len=3, xs=xs, ys=ys, interpolation=CONST_LEFT, extrapolation=CONSTANT
    );
    assert y = 300;

    return ();
}

@external
func test_const_right_interpolate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (local ys: felt*) = alloc();
    assert ys[0] = 100;
    assert ys[1] = 200;
    assert ys[2] = 300;

    let y = Math.interpolate(
        x=15, len=3, xs=xs, ys=ys, interpolation=CONST_RIGHT, extrapolation=CONSTANT
    );
    assert y = 100;

    let y = Math.interpolate(
        x=0, len=3, xs=xs, ys=ys, interpolation=CONST_RIGHT, extrapolation=CONSTANT
    );
    assert y = 100;

    let y = Math.interpolate(
        x=40, len=3, xs=xs, ys=ys, interpolation=CONST_RIGHT, extrapolation=CONSTANT
    );
    assert y = 300;

    return ();
}

@external
func test_extrapolate_before_revert_not_allowed{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (local ys: felt*) = alloc();
    assert ys[0] = 100;
    assert ys[1] = 200;
    assert ys[2] = 300;

    %{ expect_revert("TRANSACTION_FAILED", "Math: extrapolation not allowed") %}
    let y = Math.interpolate(x=0, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=0);
    assert y = 150;

    return ();
}

@external
func test_extrapolate_after_revert_not_allowed{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (local ys: felt*) = alloc();
    assert ys[0] = 100;
    assert ys[1] = 200;
    assert ys[2] = 300;

    %{ expect_revert("TRANSACTION_FAILED", "Math: extrapolation not allowed") %}
    let y = Math.interpolate(x=40, len=3, xs=xs, ys=ys, interpolation=LINEAR, extrapolation=0);
    assert y = 300;

    return ();
}

@external
func test_cumsum{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (len, ys) = Math.cumsum(len=3, xs=xs);

    assert 10 = ys[0];
    assert 30 = ys[1];
    assert 60 = ys[2];

    return ();
}

@external
func test_diff{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (len, ys) = Math.diff(len=3, xs=xs);

    assert len = 3;
    assert 0 = ys[0];
    assert 10 = ys[1];
    assert 10 = ys[2];

    return ();
}

@external
func test_mul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    let (local xs: felt*) = alloc();
    assert xs[0] = 10;
    assert xs[1] = 20;
    assert xs[2] = 30;

    let (local ys: felt*) = alloc();
    assert ys[0] = 1;
    assert ys[1] = 2;
    assert ys[2] = 3;

    let (len, zs) = Math.mul(len=3, xs=xs, ys=ys);

    assert len = 3;
    assert 10 = zs[0];
    assert 40 = zs[1];
    assert 90 = zs[2];

    return ();
}
