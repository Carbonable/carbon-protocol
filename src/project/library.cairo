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
// Events
//

@event
func AbsorptionUpdate(time: felt) {
}

//
// Storage
//

@storage_var
func CarbonableProject_metadata_() -> (set: felt) {
}

@storage_var
func CarbonableProject_times_len_() -> (length: felt) {
}

@storage_var
func CarbonableProject_times_(index: felt) -> (time: felt) {
}

@storage_var
func CarbonableProject_absorptions_ton_equivalent_() -> (precision: felt) {
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
        alloc_locals;

        // [Check] Metadata has been set else it will fail reading unkown storage
        let (is_metadata_set) = CarbonableProject_metadata_.read();
        if (is_metadata_set != TRUE) {
            let (local uri: felt*) = alloc();
            return (uri_len=0, uri=uri);
        }

        let (uri_len: felt, uri: felt*) = Metadata.uri();
        return (uri_len=uri_len, uri=uri);
    }

    func contract_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }() -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        // [Check] Metadata has been set else it will fail reading unkown storage
        let (is_metadata_set) = CarbonableProject_metadata_.read();
        if (is_metadata_set != TRUE) {
            let (local uri: felt*) = alloc();
            return (uri_len=0, uri=uri);
        }

        let (uri_len: felt, uri: felt*) = Metadata.contract_uri();
        return (uri_len=uri_len, uri=uri);
    }

    func start_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        let (time) = CarbonableProject_times_.read(0);
        return (time=time);
    }

    func final_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        let (times_len) = CarbonableProject_times_len_.read();
        let index = times_len - 1;
        let (time) = CarbonableProject_times_.read(index);
        return (time=time);
    }

    func times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        times_len: felt, times: felt*
    ) {
        let (times_len, times) = _read_times();
        return (times_len=times_len, times=times);
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
        let (absorptions_len) = CarbonableProject_absorptions_len_.read();
        let index = absorptions_len - 1;
        let (absorption) = CarbonableProject_absorptions_.read(index);
        return (absorption=absorption);
    }

    func ton_equivalent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        ton_equivalent: felt
    ) {
        let (ton_equivalent) = CarbonableProject_absorptions_ton_equivalent_.read();
        return (ton_equivalent=ton_equivalent);
    }

    func is_times_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (times_len) = CarbonableProject_times_len_.read();
        let status = is_not_zero(times_len);
        return (status=status);
    }

    func is_absorptions_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (status: felt) {
        let (absorptions_len) = CarbonableProject_absorptions_len_.read();
        let status = is_not_zero(absorptions_len);
        return (status=status);
    }

    func is_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (times_status) = is_times_setup();
        let (absorptions_status) = is_absorptions_setup();
        let status = is_not_zero(times_status * absorptions_status);
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
        // [Effect] Update metadata status
        CarbonableProject_metadata_.write(TRUE);

        // [Effect] Update metadata
        Metadata.set_uri(uri_len, uri);
        return ();
    }

    func set_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        times_len: felt,
        times: felt*,
        absorptions_len: felt,
        absorptions: felt*,
        ton_equivalent: felt,
    ) {
        alloc_locals;

        // [Check] Consistency
        let is_times_defined = is_not_zero(times_len);
        let is_absorptions_defined = is_not_zero(absorptions_len);
        with_attr error_message(
                "CarbonableProject: times and absorptions must be defined and equal") {
            assert is_times_defined = TRUE;
            assert is_absorptions_defined = TRUE;
            assert times_len = absorptions_len;
        }

        // [Check] Precision is not null
        let not_zero = is_not_zero(ton_equivalent);
        with_attr error_message("CarbonableProject: ton equivalent must be defined positive") {
            assert not_zero = TRUE;
        }

        // [Effect] Update storage
        _write_times(times_len=times_len, times=times);
        _write_absorptions(absorptions_len=absorptions_len, absorptions=absorptions);
        CarbonableProject_absorptions_ton_equivalent_.write(ton_equivalent);

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        AbsorptionUpdate.emit(time=current_time);

        return ();
    }

    //
    // Internals
    //

    func _read_times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        times_len: felt, times: felt*
    ) {
        alloc_locals;

        let (times_len) = CarbonableProject_times_len_.read();
        let (local times: felt*) = alloc();

        // [Check] times have been defined
        let (status) = is_times_setup();
        if (status != TRUE) {
            return (times_len=times_len, times=times);
        }

        _read_times_iter(index=times_len - 1, times=times);
        return (times_len=times_len, times=times);
    }

    func _read_times_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, times: felt*
    ) {
        alloc_locals;

        let (time) = CarbonableProject_times_.read(index);
        assert times[index] = time;
        if (index == 0) {
            return ();
        }
        _read_times_iter(index=index - 1, times=times);
        return ();
    }

    func _write_times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        times_len: felt, times: felt*
    ) {
        alloc_locals;

        CarbonableProject_times_len_.write(times_len);
        _write_times_iter(index=times_len - 1, times=times);
        return ();
    }

    func _write_times_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, times: felt*
    ) {
        alloc_locals;

        CarbonableProject_times_.write(index, times[index]);
        if (index == 0) {
            return ();
        }
        _write_times_iter(index=index - 1, times=times);
        return ();
    }

    func _read_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorptions_len: felt, absorptions: felt*
    ) {
        alloc_locals;

        let (absorptions_len) = CarbonableProject_absorptions_len_.read();
        let (local absorptions: felt*) = alloc();

        // [Check] absorptions have been defined
        let (status) = is_times_setup();
        if (status != TRUE) {
            return (absorptions_len=absorptions_len, absorptions=absorptions);
        }

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
        
        // Check times are set
        let (times_len, times) = _read_times();
        if (times_len == 0) {
            return(computed_absorption=0);
        }

        // Check absorptions are set
        let (absorptions_len, absorptions) = _read_absorptions();
        if (absorptions_len == 0) {
            return(computed_absorption=0);
        }

        // Check if time is before the start_time, then absorption is 0
        let stored_start_time = times[0];
        let is_before = is_le(time + 1, stored_start_time);  // is_lt
        if (is_before == TRUE) {
            return (computed_absorption=0);
        }

        // Check if time is after the final_time, then absorption is the latest stored
        let index = absorptions_len - 1;
        let stored_final_time = times[index];
        let final_absorption = absorptions[index];
        let is_after = is_le(stored_final_time + 1, time);  // is_lt
        if (is_after == TRUE) {
            return (computed_absorption=final_absorption);
        }

        // Else iter over times to get the value
        let (computed_absorption) = _compute_absorption_iter(
            time=time,
            index=index - 1,
            absorptions=absorptions,
            times=times,
            next_time=stored_final_time,
            next_absorption=final_absorption,
        );
        return (computed_absorption=computed_absorption);
    }

    func _compute_absorption_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time: felt,
        index: felt,
        absorptions: felt*,
        times: felt*,
        next_time: felt,
        next_absorption: felt,
    ) -> (computed_absorption: felt) {
        let stored_absorption = absorptions[index];
        let stored_time = times[index];
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
            times=times,
            next_time=stored_time,
            next_absorption=stored_absorption,
        );
        return (computed_absorption=computed_absorption);
    }
}
