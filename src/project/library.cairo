// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_check, uint256_eq
from starkware.starknet.common.syscalls import get_block_timestamp

// Local dependencies
from src.utils.array.library import Array
from src.utils.math.library import Math, CONSTANT, LINEAR

//
// Constants
//

const TIME_SK = 'TIME';
const ABSORPTION_SK = 'ABSORPTION';

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
func CarbonableProject_absorptions_ton_equivalent_(slot: Uint256) -> (precision: felt) {
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

        // [Compute] Storage key
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (hash) = hash2{hash_ptr=pedersen_ptr}(hash, TIME_SK);

        // [Compute] Storage value
        let (time) = Array.read(hash, 0);
        return (time=time);
    }

    func final_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (time: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        // [Compute] Storage key
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (hash) = hash2{hash_ptr=pedersen_ptr}(hash, TIME_SK);

        // [Compute] Read storage
        let (len) = Array.read_len(hash);
        let (time) = Array.read(hash, len - 1);
        return (time=time);
    }

    func times{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(slot: Uint256) -> (
        times_len: felt, times: felt*
    ) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        // [Compute] Storage key
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (hash) = hash2{hash_ptr=pedersen_ptr}(hash, TIME_SK);
 
        // [Compute] Read storage
        let (len, values) = Array.load(hash);
        return (times_len=len, times=values);
    }

    func absorptions{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (absorptions_len: felt, absorptions: felt*) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        // [Compute] Storage key
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (hash) = hash2{hash_ptr=pedersen_ptr}(hash, ABSORPTION_SK);
 
        // [Compute] Read storage
        let (len, values) = Array.load(hash);
        return (absorptions_len=len, absorptions=values);
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

        // [Compute] Storage key
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (hash) = hash2{hash_ptr=pedersen_ptr}(hash, ABSORPTION_SK);

        // [Compute] Read storage
        let (len) = Array.read_len(hash);
        let (value) = Array.read(hash, len - 1);
        return (absorption=value);
    }

    func ton_equivalent{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (ton_equivalent: felt) {
        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        let (ton_equivalent) = CarbonableProject_absorptions_ton_equivalent_.read(slot);
        return (ton_equivalent=ton_equivalent);
    }

    func is_setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (status: felt) {
        alloc_locals;

        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        // [Compute] Project status
        let (project_value) = CarbonableProject_project_value_.read(slot);
        let (project_value_status) = uint256_eq(project_value, Uint256(0, 0));

        // [Compute] Time status
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (time_hash) = hash2{hash_ptr=pedersen_ptr}(hash, TIME_SK);
        let (len) = Array.read_len(time_hash);
        let times_status = is_not_zero(len);

        // [Compute] Absorption status
        let (absorption_hash) = hash2{hash_ptr=pedersen_ptr}(hash, ABSORPTION_SK);
        let (len) = Array.read_len(absorption_hash);
        let absorptions_status = is_not_zero(len);

        let status = is_not_zero(times_status * absorptions_status * (1 - project_value_status));
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
        len: felt,
        times: felt*,
        absorptions: felt*,
        ton_equivalent: felt,
    ) {
        alloc_locals;

        // [Check] Uint256 compliancy
        Assert.u256(value=slot);

        // [Check] Consistency
        let is_defined = is_not_zero(len);
        with_attr error_message(
                "CarbonableProject: times and absorptions must be defined and equal") {
            assert is_defined = TRUE;
        }

        // [Check] Precision is not null
        let not_zero = is_not_zero(ton_equivalent);
        with_attr error_message("CarbonableProject: ton equivalent must be defined positive") {
            assert not_zero = TRUE;
        }

        // [Compute] Storage key
        let (hash) = hash2{hash_ptr=pedersen_ptr}(slot.low, slot.high);
        let (time_hash) = hash2{hash_ptr=pedersen_ptr}(hash, TIME_SK);
        let (absorption_hash) = hash2{hash_ptr=pedersen_ptr}(hash, ABSORPTION_SK);

        // [Effect] Update storage
        Array.store(key=time_hash, len=len, values=times);
        Array.store(key=absorption_hash, len=len, values=absorptions);
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

    func _compute_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, time: felt
    ) -> (computed_absorption: felt) {
        alloc_locals;

        // Check times are set
        let (times_len, times) = CarbonableProject.times(slot=slot);
        if (times_len == 0) {
            return (computed_absorption=0);
        }

        // Check absorptions are set
        let (absorptions_len, absorptions) = CarbonableProject.absorptions(slot=slot);
        if (absorptions_len == 0) {
            return (computed_absorption=0);
        }

        let computed_absorption = Math.interpolate(x=time, len=times_len, xs=times, ys=absorptions, interpolation=LINEAR, extrapolation=CONSTANT);
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
