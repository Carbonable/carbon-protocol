// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_nn_le
from starkware.starknet.common.syscalls import get_block_timestamp, get_caller_address

// Local dependencies
from src.farming.library import CarbonableFarming
from src.utils.type.library import _felt_to_uint

//
// Events
//

@event
func Claim(address: felt, absorption: felt, time: felt) {
}

//
// Storages
//

@storage_var
func CarbonableOffseter_min_claimable_() -> (absorption: felt) {
}

@storage_var
func CarbonableOffseter_total_claimed_() -> (claimed: felt) {
}

@storage_var
func CarbonableOffseter_claimed_(address: felt) -> (claimed: felt) {
}

namespace CarbonableOffseter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        min_claimable: felt
    ) {
        CarbonableOffseter.set_min_claimable(min_claimable);
        return ();
    }
    //
    // Getters
    //

    func min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        min_claimable: felt
    ) {
        let (min_claimable) = CarbonableOffseter_min_claimable_.read();
        return (min_claimable=min_claimable);
    }

    func total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        claimable: felt
    ) {
        let (absorption) = CarbonableFarming.total_absorption();
        let (claimed) = CarbonableOffseter_total_claimed_.read();
        let claimable = absorption - claimed;

        // [Check] Overflow
        let (max_claimable) = CarbonableFarming.max_absorption();
        with_attr error_message("CarbonableOffseter: overflow while computing claimable") {
            assert_nn_le(claimable, max_claimable);
        }
        return (claimable=claimable);
    }

    func total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        claimed: felt
    ) {
        let (claimed) = CarbonableOffseter_total_claimed_.read();
        return (claimed=claimed);
    }

    func claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        alloc_locals;

        let (absorption) = CarbonableFarming.absorption_of(address=address);
        let (claimed) = CarbonableOffseter_claimed_.read(address);
        let claimable = absorption - claimed;

        // [Check] Overflow
        let (total_claimable) = CarbonableOffseter.total_claimable();
        with_attr error_message("CarbonableOffseter: overflow while computing claimable") {
            assert_nn_le(claimable, total_claimable);
        }
        return (claimable=claimable);
    }

    func claimed_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimed: felt) {
        let (claimed) = CarbonableOffseter_claimed_.read(address);
        return (claimed=claimed);
    }

    //
    // Externals
    //

    func set_min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        min_claimable: felt
    ) -> () {
        with_attr error_message("CarbonableOffseter: min claimable balance must be not null") {
            assert_not_zero(min_claimable);
        }
        CarbonableOffseter_min_claimable_.write(min_claimable);
        return ();
    }

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) {
        alloc_locals;

        // [Check] Quantity is lower or equal to the total claimable
        let (caller) = get_caller_address();
        let (claimable) = claimable_of(caller);
        with_attr error_message("CarbonableOffseter: claim quantity too high") {
            assert_nn_le(quantity, claimable);
        }

        // [Effect] Claim
        _claim(caller=caller, quantity=quantity);
        return ();
    }

    func claim_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;

        // [Check] Total offsetable is not null
        let (caller) = get_caller_address();
        let (claimable) = claimable_of(caller);

        // [Effect] Claim
        _claim(caller=caller, quantity=claimable);
        return ();
    }

    //
    // Internals
    //

    func _claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: felt, quantity: felt
    ) -> () {
        alloc_locals;

        // [Check] Quantity is not negligeable
        Assert.quantity_not_negligible(quantity=quantity);

        // [Effect] Update user claimed
        let (stored) = CarbonableOffseter_claimed_.read(caller);
        let claimed = stored + quantity;
        CarbonableOffseter_claimed_.write(caller, claimed);

        // [Effect] Update total claimed
        let (stored) = CarbonableOffseter_total_claimed_.read();
        let claimed = stored + quantity;
        CarbonableOffseter_total_claimed_.write(claimed);

        // [Event] Emit event
        let (current_time) = get_block_timestamp();
        Claim.emit(address=caller, absorption=quantity, time=current_time);
        return ();
    }
}

// Assert helpers
namespace Assert {
    func quantity_not_negligible{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) {
        let (minimum) = CarbonableOffseter.min_claimable();
        with_attr error_message("CarbonableOffseter: quantity must be not negligible") {
            assert_nn_le(minimum, quantity);
        }
        return ();
    }
}
