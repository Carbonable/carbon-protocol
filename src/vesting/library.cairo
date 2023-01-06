// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from starkvest.library import StarkVest

namespace CarbonableVester {
    //
    // Getters
    //

    func releasable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (amount: Uint256) {
        // [Check] If no vesting associated to the caller, then return 0
        let (vesting_count) = StarkVest.vesting_count(account=account);
        if (vesting_count == 0) {
            let zero = Uint256(low=0, high=0);
            return (amount=zero);
        }

        // [Compute] Sum releasable amount per vesting
        let vesting_index = vesting_count - 1;
        let (amount) = _releasable_iter(account=account, vesting_index=vesting_index);
        return (amount=amount);
    }

    //
    // Externals
    //

    func release_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (caller) = get_caller_address();
        let (vesting_count) = StarkVest.vesting_count(account=caller);

        // [Check] If no vesting associated to the caller, then return
        if (vesting_count == 0) {
            return ();
        }

        _release_all_iter(account=caller, vesting_index=vesting_count - 1);
        return ();
    }

    //
    // Internals
    //

    func _releasable_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt, vesting_index: felt
    ) -> (amount: Uint256) {
        alloc_locals;

        let (vesting_id) = StarkVest.compute_vesting_id(
            account=account, vesting_count=vesting_index
        );
        let (releasable_amount) = StarkVest.releasable_amount(vesting_id=vesting_id);

        // [Check] If latest vesting, then return the amount
        if (vesting_index == 0) {
            return (amount=releasable_amount);
        }

        let (add) = _releasable_iter(account=account, vesting_index=vesting_index - 1);
        let (amount) = SafeUint256.add(releasable_amount, add);
        return (amount=amount);
    }

    func _release_all_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt, vesting_index: felt
    ) {
        alloc_locals;

        let (vesting_id) = StarkVest.compute_vesting_id(account, vesting_index);
        let (amount) = StarkVest.releasable_amount(vesting_id);
        StarkVest.release(vesting_id=vesting_id, amount=amount);

        // [Check] If not the latest vesting, then continue
        if (vesting_index != 0) {
            _release_all_iter(account=account, vesting_index=vesting_index - 1);
        }
        return ();
    }
}
