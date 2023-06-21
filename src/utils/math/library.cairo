// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le

const CONSTANT = 'CONSTANT';
const NULL = 'NULL';
const LINEAR = 'LINEAR';
const CONST_LEFT = 'CONSTANT_LEFT';
const CONST_RIGHT = 'CONSTANT_RIGHT';

namespace Math {
    func max{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value_1: felt, value_2: felt
    ) -> felt {
        let is_lower = is_le(value_1, value_2);
        if (is_lower == TRUE) {
            return value_2;
        }
        return value_1;
    }

    func min{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value_1: felt, value_2: felt
    ) -> felt {
        let is_lower = is_le(value_1, value_2);
        if (is_lower == TRUE) {
            return value_1;
        }
        return value_2;
    }

    // @notice: This function compute an interpolate y value at x on the curve defined by xs and ys
    // @dev: The extrapolation method is defined constant over the data points
    // @param x: The absissa for which to interpolate
    // @param len: The length of xs and ys
    // @param xs: The x values of the curve
    // @param ys: The y values of the curve
    // @param interpolation: The interpolation method to use
    // @param extrapolation: The extrapolation method to use
    // @return y: The interpolated y value
    func interpolate{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        x: felt, len: felt, xs: felt*, ys: felt*, interpolation: felt, extrapolation: felt
    ) -> felt {
        alloc_locals;

        // [Check] len is > 0
        with_attr error_message("Math: xs and ys must be defined") {
            assert_not_zero(len);
        }

        // [Check] interpolation method is valid
        let validity = (interpolation - LINEAR) * (interpolation - CONST_LEFT) * (
            interpolation - CONST_RIGHT
        );
        with_attr error_message("Math: interpolation method is not valid") {
            assert validity = 0;
        }

        // [Check] extrapolation method is valid
        let validity = (extrapolation - CONSTANT) * (extrapolation - NULL) * extrapolation;
        with_attr error_message("Math: extrapolation method is not valid") {
            assert validity = 0;
        }

        // [Check] x is before the first xs, then y is first_y
        let first_x = xs[0];
        let first_y = ys[0];
        let is_before = is_le(x + 1, first_x);  // is_lt
        if (is_before == TRUE) {
            if (extrapolation == CONSTANT) {
                return first_y;
            }
            if (extrapolation == NULL) {
                return 0;
            }
            with_attr error_message("Math: extrapolation not allowed") {
                assert 0 = 1;
            }
        }

        // [Check] x is after the last_x, then y is last_y
        let index = len - 1;
        let last_x = xs[index];
        let last_y = ys[index];
        let is_after = is_le(last_x + 1, x);  // is_lt
        if (is_after == TRUE) {
            if (extrapolation == CONSTANT) {
                return last_y;
            }
            if (extrapolation == NULL) {
                return 0;
            }
            with_attr error_message("Math: extrapolation not allowed") {
                assert 0 = 1;
            }
        }

        // [Compute] Else iter over xs to get the interpolated y
        return _interpolate_iter(
            x=x,
            index=index - 1,
            xs=xs,
            ys=ys,
            next_x=last_x,
            next_y=last_y,
            interpolation=interpolation,
        );
    }

    func cumsum{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        len: felt, xs: felt*
    ) -> (len: felt, ys: felt*) {
        alloc_locals;

        // [Check] len is > 0
        with_attr error_message("Math: xs must be defined") {
            assert_not_zero(len);
        }

        // [Compute] Else iter over xs to get the cumsum ys
        let (local ys: felt*) = alloc();
        return _cumsum_iter(index=0, len=len, xs=xs, ys=ys);
    }

    func diff{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        len: felt, xs: felt*
    ) -> (len: felt, ys: felt*) {
        alloc_locals;

        // [Check] len is > 0
        with_attr error_message("Math: xs must be defined") {
            assert_not_zero(len);
        }

        // [Compute] Else iter over xs to get the diff ys
        let (local ys: felt*) = alloc();
        return _diff_iter(index=len - 1, len=len, xs=xs, ys=ys);
    }

    func mul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        len: felt, xs: felt*, ys: felt*
    ) -> (len: felt, zs: felt*) {
        alloc_locals;

        // [Check] len is > 0
        with_attr error_message("Math: xs and ys must be defined") {
            assert_not_zero(len);
        }

        // [Compute] Else iter over xs to get the diff ys
        let (local zs: felt*) = alloc();
        return _mul_iter(index=len - 1, len=len, xs=xs, ys=ys, zs=zs);
    }
}

func _interpolate_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    x: felt, index: felt, xs: felt*, ys: felt*, next_x: felt, next_y: felt, interpolation: felt
) -> felt {
    let read_x = xs[index];
    let read_y = ys[index];
    let is_after = is_le(read_x, x);
    if (is_after == TRUE) {
        // [Check] x = read_x or interpolation is constant right
        let condition = (x - read_x) * (interpolation - CONST_RIGHT);
        if (condition == 0) {
            return read_y;
        }

        // [Check] x = next_x or interpolation is constant left
        let condition = (next_x - x) * (interpolation - CONST_LEFT);
        if (condition == 0) {
            return next_y;
        }

        // [Compute] linear interpolation
        // TODO: Check overflow
        // y = [(xb - x) * ya + (x - xa) * yb] / (xb - xa)
        let den = next_x - read_x;
        let alpha = next_x - x;
        let beta = x - read_x;
        let num = alpha * read_y + beta * next_y;

        // [Check] Zero division
        with_attr error_message("Math: division by zero") {
            assert_not_zero(den);
        }
        let (y, _) = unsigned_div_rem(num, den);
        return y;
    }

    // [Check] index is null
    if (index == 0) {
        return 0;
    }

    return _interpolate_iter(
        x=x,
        index=index - 1,
        xs=xs,
        ys=ys,
        next_x=read_x,
        next_y=read_y,
        interpolation=interpolation,
    );
}

func _cumsum_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    index: felt, len: felt, xs: felt*, ys: felt*
) -> (len: felt, ys: felt*) {
    alloc_locals;

    // [Check] index is len, then stop
    if (index == len) {
        return (len=len, ys=ys);
    }

    let x = xs[index];

    // [Check] index is null, the sum is 0
    if (index == 0) {
        assert ys[index] = x;
        return _cumsum_iter(index=index + 1, len=len, xs=xs, ys=ys);
    }

    let y = ys[index - 1];
    assert ys[index] = x + y;
    return _cumsum_iter(index=index + 1, len=len, xs=xs, ys=ys);
}

func _diff_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    index: felt, len: felt, xs: felt*, ys: felt*
) -> (len: felt, ys: felt*) {
    alloc_locals;

    // [Check] index is null, then stop
    if (index == 0) {
        assert ys[index] = 0;
        return (len=len, ys=ys);
    }

    let x = xs[index];
    let previous_x = xs[index - 1];

    // [Check] previous_x <= x
    with_attr error_message("Math: xs must be sorted") {
        assert_le(previous_x, x);
    }

    assert ys[index] = x - previous_x;
    return _diff_iter(index=index - 1, len=len, xs=xs, ys=ys);
}

func _mul_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    index: felt, len: felt, xs: felt*, ys: felt*, zs: felt*
) -> (len: felt, zs: felt*) {
    alloc_locals;

    let x = xs[index];
    let y = ys[index];
    assert zs[index] = x * y;

    // [Check] index is null, then stop
    if (index == 0) {
        return (len=len, zs=zs);
    }
    return _mul_iter(index=index - 1, len=len, xs=xs, ys=ys, zs=zs);
}
