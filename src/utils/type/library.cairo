// Source: https://github.com/briqNFT/briq-protocol/blob/main/contracts/utilities/Uint256_felt_conv.cairo

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256, uint256_check

const HIGH_BIT_MAX = 0x8000000000000110000000000000000;

func _check_uint_fits_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: Uint256
) {
    let high_clear = is_le_felt(value.high, HIGH_BIT_MAX - 1);
    // Only one possible value otherwise, the actual PRIME - 1;
    if (high_clear == 0) {
        assert value.high = HIGH_BIT_MAX;
        assert value.low = 0;
    }
    return ();
}

func _uint_to_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: Uint256
) -> (value: felt) {
    uint256_check(value);
    with_attr error_message("CarbonableUtils: Uint256 to felt conversion failure") {
        _check_uint_fits_felt(value);
    }
    return (value.high * (2 ** 128) + value.low,);
}

func _felt_to_uint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: felt
) -> (value: Uint256) {
    let (high, low) = split_felt(value);
    tempvar res: Uint256;
    res.high = high;
    res.low = low;
    return (res,);
}
