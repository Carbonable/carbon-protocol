// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from openzeppelin.access.accesscontrol.library import AccessControl

const MINTER_ROLE = 'MINTER';

namespace CarbonableAccessControl {
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.initializer();
        return ();
    }

    func assert_only_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.assert_only_role(MINTER_ROLE);
        return ();
    }

    func set_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user: felt) {
        AccessControl._grant_role(MINTER_ROLE, user);
        return ();
    }
}
