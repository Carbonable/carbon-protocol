// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_block_timestamp

// Local dependencies
from src.utils.metadata.library import Metadata

//
// Storage
//

@storage_var
func CarbonableProject_start_time_() -> (time: felt) {
}

@storage_var
func CarbonableProject_time_step_() -> (step: felt) {
}

@storage_var
func CarbonableProject_absorptions_len_() -> (length: felt) {
}

@storage_var
func CarbonableProject_absorptions_(index: felt) -> (absorption: felt) {
}

namespace CarbonableProject {
    //
    // Getters
    //

    func token_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(token_id: Uint256) -> (uri_len: felt, uri: felt*) {
        let (uri_len: felt, uri: felt*) = Metadata.uri();
        return (uri_len=uri_len, uri=uri);
    }

    func contract_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }() -> (uri_len: felt, uri: felt*) {
        let (uri_len: felt, uri: felt*) = Metadata.contract_uri();
        return (uri_len=uri_len, uri=uri);
    }

    func start_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        let (time) = CarbonableProject_start_time_.read();
        return (time=time);
    }

    func final_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        // [Check] absorptions have been defined
        CarbonableProject_assert.absorptions_are_defined();

        let (start_time) = CarbonableProject_start_time_.read();
        let (time_step) = CarbonableProject_time_step_.read();
        let (absorptions_len) = CarbonableProject_absorptions_len_.read();
        let final_index = absorptions_len - 1;
        let time = time_step * final_index + start_time;
        return (time=time);
    }

    func time_step{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        step: felt
    ) {
        let (step) = CarbonableProject_time_step_.read();
        return (step=step);
    }

    func absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorptions_len: felt, absorptions: felt*
    ) {
        let (absorptions_len, absorptions) = _read_absorptions();
        return (absorptions_len=absorptions_len, absorptions=absorptions);
    }

    func absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time: felt
    ) -> (absorption: felt) {
        let (absorption) = _compute_absorption(time=time);
        return (absorption=absorption);
    }

    func current_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorption: felt
    ) {
        alloc_locals;
        let (current_time) = get_block_timestamp();
        let (current_absorption) = absorption(time=current_time);
        return (absorption=current_absorption);
    }

    func final_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorption: felt
    ) {
        let (time) = final_time();
        let (final_absorption) = absorption(time=time);
        return (absorption=final_absorption);
    }

    func is_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (time_step) = CarbonableProject_time_step_.read();
        let (absorptions_len) = CarbonableProject_absorptions_len_.read();
        let status = is_not_zero(time_step * absorptions_len);
        return (status=status);
    }

    //
    // Externals
    //

    func set_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len: felt, uri: felt*) {
        Metadata.set_uri(uri_len, uri);
        return ();
    }

    func set_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        start_time: felt, time_step: felt
    ) {
        alloc_locals;

        // [Check] Consistency
        let not_zero = is_not_zero(time_step);
        with_attr error_message("CarbonableProject: time_step must be not null") {
            not_zero = TRUE;
        }

        // [Effect] Update storage
        CarbonableProject_start_time_.write(start_time);
        CarbonableProject_time_step_.write(time_step);
        return ();
    }

    func set_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        absorptions_len: felt, absorptions: felt*
    ) {
        alloc_locals;

        // [Check] Consistency
        let not_zero = is_not_zero(absorptions_len);
        with_attr error_message("CarbonableProject: absorptions must be defined") {
            not_zero = TRUE;
        }

        // [Effect] Update storage
        _write_absorptions(absorptions_len=absorptions_len, absorptions=absorptions);
        return ();
    }

    //
    // Internals
    //

    func _read_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorptions_len: felt, absorptions: felt*
    ) {
        alloc_locals;

        // [Check] absorptions have been defined
        CarbonableProject_assert.absorptions_are_defined();

        let (absorptions_len) = CarbonableProject_absorptions_len_.read();
        let (local absorptions: felt*) = alloc();
        _read_absorptions_iter(index=absorptions_len - 1, absorptions=absorptions);
        return (absorptions_len=absorptions_len, absorptions=absorptions);
    }

    func _read_absorptions_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, absorptions: felt*
    ) {
        alloc_locals;

        let (absorption) = CarbonableProject_absorptions_.read(index);
        assert absorptions[index] = absorption;
        if (index == 0) {
            return ();
        }
        _read_absorptions_iter(index=index - 1, absorptions=absorptions);
        return ();
    }

    func _write_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        absorptions_len: felt, absorptions: felt*
    ) {
        alloc_locals;

        CarbonableProject_absorptions_len_.write(absorptions_len);
        _write_absorptions_iter(index=absorptions_len - 1, absorptions=absorptions);
        return ();
    }

    func _write_absorptions_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, absorptions: felt*
    ) {
        alloc_locals;

        CarbonableProject_absorptions_.write(index, absorptions[index]);
        if (index == 0) {
            return ();
        }
        _write_absorptions_iter(index=index - 1, absorptions=absorptions);
        return ();
    }

    func _compute_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time: felt
    ) -> (computed_absorption: felt) {
        alloc_locals;

        // Check absorptions are set
        let (absorptions_len, absorptions) = _read_absorptions();

        // Check if time is before the start_time, then absorption is 0
        let (stored_start_time) = start_time();
        let is_before = is_le(time, stored_start_time - 1);  // is_lt
        if (is_before == TRUE) {
            return (computed_absorption=0);
        }

        // Check if time is after the final_time, then absorption is the latest stored
        let (stored_final_time) = final_time();
        let index = absorptions_len - 1;
        let final_absorption = absorptions[index];
        let is_after = is_le(stored_final_time, time - 1);  // is_lt
        if (is_after == TRUE) {
            return (computed_absorption=final_absorption);
        }

        // Else iter over times to get the value
        let (stored_time_step) = time_step();
        let (computed_absorption) = _compute_absorption_iter(
            time=time,
            index=index - 1,
            absorptions=absorptions,
            start_time=stored_start_time,
            time_step=stored_time_step,
            next_time=stored_final_time,
            next_absorption=final_absorption,
        );
        return (computed_absorption=computed_absorption);
    }

    func _compute_absorption_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time: felt,
        index: felt,
        absorptions: felt*,
        start_time: felt,
        time_step: felt,
        next_time: felt,
        next_absorption: felt,
    ) -> (computed_absorption: felt) {
        let stored_absorption = absorptions[index];
        let stored_time = index * time_step + start_time;
        let is_after = is_le(stored_time, time);
        if (is_after == TRUE) {
            // [Check] exact time
            if (time == stored_time) {
                return (computed_absorption=stored_absorption);
            }

            // [Compute] linear interpolation
            // Overflow is riskless since time is < 1E10 and absorption is <1E12 which is << 1E38
            // y = [(xb - x) * ya + (x - xa) * yb] / (xb - xa)
            let den = next_time - stored_time;
            let alpha = next_time - time;
            let beta = time - stored_time;
            let num = alpha * stored_absorption + beta * next_absorption;

            // [Check] Zero division
            let den_not_zero = is_not_zero(den);
            with_attr error_message(
                    "CarbonableProject: division by zero, two consecutive times are equals") {
                assert den_not_zero = TRUE;
            }
            let (computed_absorption, _) = unsigned_div_rem(num, den);
            return (computed_absorption=computed_absorption);
        }

        // [Check] index is null
        if (index == 0) {
            return (computed_absorption=0);
        }

        let (computed_absorption) = _compute_absorption_iter(
            time=time,
            index=index - 1,
            absorptions=absorptions,
            start_time=start_time,
            time_step=time_step,
            next_time=stored_time,
            next_absorption=stored_absorption,
        );
        return (computed_absorption=computed_absorption);
    }
}

// Assert helpers
namespace CarbonableProject_assert {
    func absorptions_are_defined{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) {
        let (status) = CarbonableProject.is_setup();
        with_attr error_message("CarbonableProject: absorptions must be defined") {
            assert status = TRUE;
        }
        return ();
    }
}
