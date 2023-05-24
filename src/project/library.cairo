// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_check, uint256_eq
from starkware.starknet.common.syscalls import get_block_timestamp

//
// Events
//

@event
func AbsorptionUpdate(slot: Uint256, time: felt) {
}

@event
func ProjectValueUpdate(slot: Uint256, projectValue: Uint256) {
}

//
// Storage
//

@storage_var
func CarbonableProject_times_len_(slot: Uint256) -> (length: felt) {
}

@storage_var
func CarbonableProject_times_(slot: Uint256, index: felt) -> (time: felt) {
}

@storage_var
func CarbonableProject_absorptions_ton_equivalent_(slot: Uint256) -> (precision: felt) {
}

@storage_var
func CarbonableProject_absorptions_len_(slot: Uint256) -> (length: felt) {
}

@storage_var
func CarbonableProject_absorptions_(slot: Uint256, index: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableProject_project_value_(slot: Uint256) -> (project_value: Uint256) {
}

namespace CarbonableProject {
    //
    // Getters
    //

    func start_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (time: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (time) = CarbonableProject_times_.read(slot, 0);
        return (time=time);
    }

    func final_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (time: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (times_len) = CarbonableProject_times_len_.read(slot);
        let index = times_len - 1;
        let (time) = CarbonableProject_times_.read(slot, index);
        return (time=time);
    }

    func times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
        times_len: felt, times: felt*
    ) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (times_len, times) = _read_times(slot);
        return (times_len=times_len, times=times);
    }

    func absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (absorptions_len: felt, absorptions: felt*) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (absorptions_len, absorptions) = _read_absorptions(slot=slot);
        return (absorptions_len=absorptions_len, absorptions=absorptions);
    }

    func absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, time: felt
    ) -> (absorption: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (absorption) = _compute_absorption(slot=slot, time=time);
        return (absorption=absorption);
    }

    func current_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (absorption: felt) {
        alloc_locals;

        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (current_time) = get_block_timestamp();
        let (current_absorption) = absorption(slot=slot, time=current_time);
        return (absorption=current_absorption);
    }

    func final_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (absorption: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (absorptions_len) = CarbonableProject_absorptions_len_.read(slot);
        let index = absorptions_len - 1;
        let (absorption) = CarbonableProject_absorptions_.read(slot, index);
        return (absorption=absorption);
    }

    func ton_equivalent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (ton_equivalent: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (ton_equivalent) = CarbonableProject_absorptions_ton_equivalent_.read(slot);
        return (ton_equivalent=ton_equivalent);
    }

    func is_times_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (status: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (times_len) = CarbonableProject_times_len_.read(slot);
        let status = is_not_zero(times_len);
        return (status=status);
    }

    func is_absorptions_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (status: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (absorptions_len) = CarbonableProject_absorptions_len_.read(slot);
        let status = is_not_zero(absorptions_len);
        return (status=status);
    }

    func is_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (status: felt) {
        alloc_locals;

        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (project_value) = CarbonableProject_project_value_.read(slot);
        let (project_value_status) = uint256_eq(project_value, Uint256(0, 0));
        let project_value_status = 1 - project_value_status;

        let (absorptions_len) = CarbonableProject_absorptions_len_.read(slot);
        let absorptions_status = is_not_zero(absorptions_len);

        let (times_len) = CarbonableProject_times_len_.read(slot);
        let times_status = is_not_zero(times_len);

        let status = is_not_zero(times_status * absorptions_status * project_value_status);
        return (status=status);
    }

    func project_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (project_value: Uint256) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (project_value) = CarbonableProject_project_value_.read(slot);
        return (project_value=project_value);
    }

    //
    // Externals
    //

    func set_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256,
        times_len: felt,
        times: felt*,
        absorptions_len: felt,
        absorptions: felt*,
        ton_equivalent: felt,
    ) {
        alloc_locals;

        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

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
        _write_times(slot=slot, times_len=times_len, times=times);
        _write_absorptions(slot=slot, absorptions_len=absorptions_len, absorptions=absorptions);
        CarbonableProject_absorptions_ton_equivalent_.write(slot, ton_equivalent);

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        AbsorptionUpdate.emit(slot=slot, time=current_time);

        return ();
    }

    func set_project_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, project_value: Uint256
    ) {
        alloc_locals;
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);
        Assert.u256(value=project_value);

        // [Check] Project value is not zero
        let (is_zero) = uint256_eq(project_value, Uint256(0, 0));
        with_attr error_message("CarbonableProject: project value must be defined positive") {
            assert FALSE = is_zero;
        }

        CarbonableProject_project_value_.write(slot, project_value);
        ProjectValueUpdate.emit(slot=slot, projectValue=project_value);
        return ();
    }

    //
    // Internals
    //

    func _read_times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (times_len: felt, times: felt*) {
        alloc_locals;

        let (times_len) = CarbonableProject_times_len_.read(slot);
        let (local times: felt*) = alloc();

        // [Check] times have been defined
        let (status) = is_times_setup(slot=slot);
        if (status != TRUE) {
            return (times_len=times_len, times=times);
        }

        _read_times_iter(slot=slot, index=times_len - 1, times=times);
        return (times_len=times_len, times=times);
    }

    func _read_times_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, index: felt, times: felt*
    ) {
        alloc_locals;

        let (time) = CarbonableProject_times_.read(slot, index);
        assert times[index] = time;
        if (index == 0) {
            return ();
        }
        _read_times_iter(slot=slot, index=index - 1, times=times);
        return ();
    }

    func _write_times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, times_len: felt, times: felt*
    ) {
        alloc_locals;

        CarbonableProject_times_len_.write(slot, times_len);
        _write_times_iter(slot=slot, index=times_len - 1, times=times);
        return ();
    }

    func _write_times_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, index: felt, times: felt*
    ) {
        alloc_locals;

        CarbonableProject_times_.write(slot, index, times[index]);
        if (index == 0) {
            return ();
        }
        _write_times_iter(slot=slot, index=index - 1, times=times);
        return ();
    }

    func _read_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (absorptions_len: felt, absorptions: felt*) {
        alloc_locals;

        let (absorptions_len) = CarbonableProject_absorptions_len_.read(slot);
        let (local absorptions: felt*) = alloc();

        // [Check] absorptions have been defined
        let (status) = is_times_setup(slot=slot);
        if (status != TRUE) {
            return (absorptions_len=absorptions_len, absorptions=absorptions);
        }

        _read_absorptions_iter(slot=slot, index=absorptions_len - 1, absorptions=absorptions);
        return (absorptions_len=absorptions_len, absorptions=absorptions);
    }

    func _read_absorptions_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, index: felt, absorptions: felt*
    ) {
        alloc_locals;

        let (absorption) = CarbonableProject_absorptions_.read(slot, index);
        assert absorptions[index] = absorption;
        if (index == 0) {
            return ();
        }
        _read_absorptions_iter(slot=slot, index=index - 1, absorptions=absorptions);
        return ();
    }

    func _write_absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, absorptions_len: felt, absorptions: felt*
    ) {
        alloc_locals;

        CarbonableProject_absorptions_len_.write(slot, absorptions_len);
        _write_absorptions_iter(slot=slot, index=absorptions_len - 1, absorptions=absorptions);
        return ();
    }

    func _write_absorptions_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, index: felt, absorptions: felt*
    ) {
        alloc_locals;

        CarbonableProject_absorptions_.write(slot, index, absorptions[index]);
        if (index == 0) {
            return ();
        }
        _write_absorptions_iter(slot=slot, index=index - 1, absorptions=absorptions);
        return ();
    }

    func _compute_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, time: felt
    ) -> (computed_absorption: felt) {
        alloc_locals;

        // Check times are set
        let (times_len, times) = _read_times(slot=slot);
        if (times_len == 0) {
            return (computed_absorption=0);
        }

        // Check absorptions are set
        let (absorptions_len, absorptions) = _read_absorptions(slot=slot);
        if (absorptions_len == 0) {
            return (computed_absorption=0);
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

// Assert helpers
namespace Assert {
    func u256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(value: Uint256) {
        with_attr error_message("CarbonableProject: value is not a valid Uint256") {
            uint256_check(value);
        }
        return ();
    }
}
