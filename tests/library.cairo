# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Project dependencies
from cairopen.string.string import String

# Functions
func assert_string{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(string1 : String, string2 : String):
    assert string1.len = string2.len

    let (success) = compare_array_loop(string1.len, string1.data, string2.data)
    assert success = TRUE
    return ()
end

func compare_array_loop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    len : felt, array1 : felt*, array2 : felt*
) -> (success : felt):
    if len == 0:
        return (success=TRUE)
    end

    let index = len - 1
    if array1[index] != array2[index]:
        return (success=FALSE)
    end

    let (success) = compare_array_loop(index, array1, array2)
    return (success=success)
end
