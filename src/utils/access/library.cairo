// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le, is_le_felt, is_not_zero

from openzeppelin.access.accesscontrol.library import AccessControl

const MINTER_ROLE = 'MINTER';
const VESTER_ROLE = 'VESTER';
const CERTIFIER_ROLE = 'CERTIFIER';
const WITHDRAWER_ROLE = 'WITHDRAWER';
const SNAPSHOTER_ROLE = 'SNAPSHOTER';

@storage_var
func CarbonableAccessControl_role_members_index(role: felt, index: felt) -> (member: felt) {
}

@storage_var
func CarbonableAccessControl_role_members(role: felt, member: felt) -> (index: felt) {
}

@storage_var
func CarbonableAccessControl_role_members_len(role: felt) -> (size: felt) {
}

namespace CarbonableAccessControl {
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.initializer();
        return ();
    }

    // Minter Role
    func assert_only_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.assert_only_role(MINTER_ROLE);
        return ();
    }

    func set_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user: felt) {
        _set_role(MINTER_ROLE, user);
        return ();
    }

    func get_minters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        minters_len: felt, minters: felt*
    ) {
        let (minters_len, minters) = _get_role_members(MINTER_ROLE);
        return (minters_len=minters_len, minters=minters);
    }

    func revoke_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) {
        _revoke_role(MINTER_ROLE, user);
        return ();
    }

    // Vester Role
    func assert_only_vester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.assert_only_role(VESTER_ROLE);
        return ();
    }

    func set_vester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user: felt) {
        _set_role(VESTER_ROLE, user);
        return ();
    }

    func get_vesters{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        vesters_len: felt, vesters: felt*
    ) {
        let (vesters_len, vesters) = _get_role_members(VESTER_ROLE);
        return (vesters_len=vesters_len, vesters=vesters);
    }

    func revoke_vester{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) {
        _revoke_role(VESTER_ROLE, user);
        return ();
    }

    // Certifier Role
    func assert_only_certifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.assert_only_role(CERTIFIER_ROLE);
        return ();
    }

    func set_certifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) {
        let (prev_certifier) = get_certifier();
        AccessControl._revoke_role(CERTIFIER_ROLE, prev_certifier);
        AccessControl._grant_role(CERTIFIER_ROLE, user);
        CarbonableAccessControl_role_members_index.write(CERTIFIER_ROLE, 0, user);
        return ();
    }

    func get_certifier{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        certifier: felt
    ) {
        let (certifier) = CarbonableAccessControl_role_members_index.read(CERTIFIER_ROLE, 0);
        return (certifier=certifier);
    }

    // Snapshoter Role
    func assert_only_snapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.assert_only_role(SNAPSHOTER_ROLE);
        return ();
    }

    func set_snapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) {
        let (prev_snapshoter) = get_snapshoter();
        AccessControl._revoke_role(SNAPSHOTER_ROLE, prev_snapshoter);
        AccessControl._grant_role(SNAPSHOTER_ROLE, user);
        CarbonableAccessControl_role_members_index.write(SNAPSHOTER_ROLE, 0, user);
        return ();
    }

    func get_snapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        snapshoter: felt
    ) {
        let (snapshoter) = CarbonableAccessControl_role_members_index.read(SNAPSHOTER_ROLE, 0);
        return (snapshoter=snapshoter);
    }

    // Withdrawer Role
    func assert_only_withdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        AccessControl.assert_only_role(WITHDRAWER_ROLE);
        return ();
    }

    func set_withdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) {
        let (prev_withdrawer) = get_withdrawer();
        AccessControl._revoke_role(WITHDRAWER_ROLE, prev_withdrawer);
        AccessControl._grant_role(WITHDRAWER_ROLE, user);
        CarbonableAccessControl_role_members_index.write(WITHDRAWER_ROLE, 0, user);
        return ();
    }

    func get_withdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        withdrawer: felt
    ) {
        let (withdrawer) = CarbonableAccessControl_role_members_index.read(WITHDRAWER_ROLE, 0);
        return (withdrawer=withdrawer);
    }

    //
    // Internal functions
    //

    func _get_role_members{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        role: felt
    ) -> (members_len: felt, members: felt*) {
        alloc_locals;
        let (local members: felt*) = alloc();
        let (n) = CarbonableAccessControl_role_members_len.read(role);
        _get_role_members_iter(role, n, members);
        return (members_len=n, members=members);
    }

    func _get_role_members_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        role: felt, n: felt, members: felt*
    ) {
        if (n == 0) {
            return ();
        }

        let (member) = CarbonableAccessControl_role_members_index.read(role, n - 1);
        assert [members] = member;
        return _get_role_members_iter(role, n - 1, members + 1);
    }

    func _set_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        role: felt, user: felt
    ) {
        let (user_has_role: felt) = AccessControl.has_role(role, user);
        if (user_has_role == TRUE) {
            return ();
        }

        AccessControl._grant_role(role, user);
        let (old_size) = CarbonableAccessControl_role_members_len.read(role);
        CarbonableAccessControl_role_members_len.write(role, old_size + 1);
        CarbonableAccessControl_role_members_index.write(role, old_size, user);
        CarbonableAccessControl_role_members.write(role, user, old_size);
        return ();
    }

    func _revoke_role{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        role: felt, user: felt
    ) {
        let (user_has_role: felt) = AccessControl.has_role(role, user);
        if (user_has_role == FALSE) {
            return ();
        }

        AccessControl._revoke_role(role, user);
        let (old_size) = CarbonableAccessControl_role_members_len.read(role);
        let (user_index) = CarbonableAccessControl_role_members.read(role, user);

        // Case where user has been registered by an older mechanism
        // Access control storage must be left unchanged
        let (stored_user) = CarbonableAccessControl_role_members_index.read(role, user_index);
        if (user != stored_user) {
            return ();
        }

        let (last_user) = CarbonableAccessControl_role_members_index.read(role, old_size - 1);
        CarbonableAccessControl_role_members_len.write(role, old_size - 1);
        CarbonableAccessControl_role_members_index.write(role, user_index, last_user);
        CarbonableAccessControl_role_members.write(role, last_user, user_index);
        return ();
    }
}
