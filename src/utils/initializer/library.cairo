// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

@storage_var
func CarbonableInitializer_initialized_(name: felt) -> (res: felt) {
}

namespace CarbonableInitializer {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(name: felt) {
        CarbonableInitializer_initialized_.write(name, TRUE);
        return ();
    }

    func assert_initialized{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        name: felt
    ) {
        let (initialized) = CarbonableInitializer_initialized_.read(name);
        with_attr error_message("CarbonableInitializer: not initialized") {
            assert_not_zero(initialized);
        }
        return ();
    }
}
