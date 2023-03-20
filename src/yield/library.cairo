// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_in_range, unsigned_div_rem
from starkware.cairo.common.uint256 import assert_uint256_le
from starkware.starknet.common.syscalls import get_block_timestamp

// Local dependencies
from src.interfaces.offseter import ICarbonableOffseter
from src.interfaces.project import ICarbonableProject
from src.interfaces.vester import ICarbonableVester
from src.offset.library import CarbonableOffseter
from src.utils.type.library import _felt_to_uint

//
// Events
//

@event
func Snapshot(
    project: felt,
    previous_time: felt,
    previous_project_absorption: felt,
    previous_offseter_absorption: felt,
    previous_yielder_absorption: felt,
    current_time: felt,
    current_project_absorption: felt,
    current_offseter_absorption: felt,
    current_yielder_absorption: felt,
    period_project_absorption: felt,
    period_offseter_absorption: felt,
    period_yielder_absorption: felt,
) {
}

@event
func Vesting(project: felt, amount: felt, time: felt) {
}

//
// Storages
//

@storage_var
func CarbonableYielder_carbonable_offseter_address_() -> (address: felt) {
}

@storage_var
func CarbonableYielder_carbonable_vester_address_() -> (address: felt) {
}

@storage_var
func CarbonableYielder_snapshoted_offseter_absorption_() -> (absorption: felt) {
}

@storage_var
func CarbonableYielder_snapshoted_yielder_absorption_() -> (absorption: felt) {
}

@storage_var
func CarbonableYielder_snapshoted_yielder_contribution_() -> (absorption: felt) {
}

@storage_var
func CarbonableYielder_snapshoted_user_yielder_absorption_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableYielder_snapshoted_user_yielder_contribution_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableYielder_snapshoted_time_() -> (time: felt) {
}

@storage_var
func CarbonableYielder_vested_() -> (status: felt) {
}

namespace CarbonableYielder {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_offseter_address: felt, carbonable_vester_address: felt
    ) {
        CarbonableYielder_carbonable_offseter_address_.write(carbonable_offseter_address);
        CarbonableYielder_carbonable_vester_address_.write(carbonable_vester_address);
        CarbonableYielder_vested_.write(TRUE);  // To enable first snapshot
        return ();
    }

    //
    // Getters
    //

    func carbonable_offseter_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_offseter_address: felt) {
        let (carbonable_offseter_address) = CarbonableYielder_carbonable_offseter_address_.read();
        return (carbonable_offseter_address=carbonable_offseter_address);
    }

    func carbonable_vester_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (carbonable_vester_address: felt) {
        let (carbonable_vester_address) = CarbonableYielder_carbonable_vester_address_.read();
        return (carbonable_vester_address=carbonable_vester_address);
    }

    func snapshoted_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        let (time) = CarbonableYielder_snapshoted_time_.read();
        return (time=time);
    }

    func snapshoted_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        let (absorption) = CarbonableYielder_snapshoted_user_yielder_contribution_.read(address);
        return (absorption=absorption);
    }

    //
    // Externals
    //

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        alloc_locals;

        // [Check] At least 1 user registered
        CarbonableYielder_assert.snapshotable();

        let (carbonable_project_address) = CarbonableOffseter.carbonable_project_address();
        let (slot) = CarbonableOffseter.carbonable_project_slot();
        let (carbonable_offseter_address) = CarbonableYielder_carbonable_offseter_address_.read();

        // [Compute] Previous information
        let (previous_time) = CarbonableYielder_snapshoted_time_.read();
        let (previous_project_absorption) = ICarbonableProject.getAbsorption(
            contract_address=carbonable_project_address, slot=slot, time=previous_time
        );
        let (previous_offseter_absorption) = CarbonableYielder_snapshoted_offseter_absorption_.read(
            );
        let (previous_yielder_absorption) = CarbonableYielder_snapshoted_yielder_absorption_.read();

        // [Compute] Current information
        let (current_project_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=carbonable_project_address, slot=slot
        );
        let (current_offseter_absorption) = ICarbonableOffseter.getTotalAbsorption(
            contract_address=carbonable_offseter_address
        );
        let (current_yielder_absorption) = CarbonableOffseter.total_absorption();

        // [Compute] Period information
        let period_project_absorption = current_project_absorption - previous_project_absorption;
        let period_offseter_absorption = current_offseter_absorption - previous_offseter_absorption;
        let period_yielder_absorption = current_yielder_absorption - previous_yielder_absorption;

        // [Check] Period duration not null
        let (current_time) = get_block_timestamp();
        let period_duration = current_time - previous_time;
        with_attr error_message(
                "CarbonableYielder: cannot estimate tCO2 price if the period duration is null") {
            assert_not_zero(period_duration);
        }

        // [Effect] Store snapshot values
        CarbonableYielder_snapshoted_time_.write(current_time);
        CarbonableYielder_snapshoted_offseter_absorption_.write(current_offseter_absorption);
        CarbonableYielder_snapshoted_yielder_absorption_.write(current_yielder_absorption);
        CarbonableYielder_snapshoted_yielder_contribution_.write(period_yielder_absorption);

        // [Effect] Store period shares per users
        let (count) = CarbonableOffseter.total_user_count();
        _snapshot_iter(index=count - 1);

        // [Effect] Update vested status
        CarbonableYielder_vested_.write(FALSE);

        // [Effect] Emit event
        Snapshot.emit(
            project=carbonable_project_address,
            previous_time=previous_time,
            previous_project_absorption=previous_project_absorption,
            previous_offseter_absorption=previous_offseter_absorption,
            previous_yielder_absorption=previous_yielder_absorption,
            current_time=current_time,
            current_project_absorption=current_project_absorption,
            current_offseter_absorption=current_offseter_absorption,
            current_yielder_absorption=current_yielder_absorption,
            period_project_absorption=period_project_absorption,
            period_offseter_absorption=period_offseter_absorption,
            period_yielder_absorption=period_yielder_absorption,
        );
        return (success=TRUE);
    }

    func create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) -> (success: felt) {
        alloc_locals;

        // [Check] Snapshot has been executed and vestable
        CarbonableYielder_assert.snapshoted();
        CarbonableYielder_assert.vestable(total_amount);

        // [Check] Contribution not null
        let (yielder_contribution) = CarbonableYielder_snapshoted_yielder_contribution_.read();
        with_attr error_message(
                "CarbonableYielder: cannot vest if the total yielder contribution is null") {
            assert_not_zero(yielder_contribution);
        }

        // [Interaction] Run create_vestings
        let (carbonable_project_address) = CarbonableOffseter.carbonable_project_address();
        let (carbonable_vester_address) = CarbonableYielder_carbonable_vester_address_.read();
        let (current_time) = get_block_timestamp();
        let (count) = CarbonableOffseter.total_user_count();
        _create_vestings_iter(
            contract_address=carbonable_vester_address,
            yielder_contribution=yielder_contribution,
            total_amount=total_amount,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
            carbonable_project_address=carbonable_project_address,
            current_time=current_time,
            index=count - 1,
        );

        // [Effect] Update vested status
        CarbonableYielder_vested_.write(TRUE);

        // [Event] Emit all vesting are created
        Vesting.emit(project=carbonable_project_address, amount=total_amount, time=current_time);

        return (success=TRUE);
    }

    //
    // Internals
    //

    func _snapshot_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt
    ) {
        alloc_locals;

        // [Compute] Yield absorption and contribution
        let (user) = CarbonableOffseter.user_by_index(index);
        let (current_yielder_absorption) = CarbonableOffseter.absorption_of(address=user);
        let (
            previous_yielder_absorption
        ) = CarbonableYielder_snapshoted_user_yielder_absorption_.read(user);

        // [Check] Yielder contribution overflow
        with_attr error_message("CarbonableYielder: user yielder contribution overflow detected") {
            assert_in_range(previous_yielder_absorption, 0, current_yielder_absorption + 1);
        }
        let period_contribution = current_yielder_absorption - previous_yielder_absorption;

        // [Effect] Store new snapshoted absorptions and contibution
        CarbonableYielder_snapshoted_user_yielder_absorption_.write(
            user, current_yielder_absorption
        );
        CarbonableYielder_snapshoted_user_yielder_contribution_.write(user, period_contribution);

        // [Check] If not last, then continue
        if (index != 0) {
            _snapshot_iter(index=index - 1);
            return ();
        }
        return ();
    }

    func _create_vestings_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt,
        yielder_contribution: felt,
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        carbonable_project_address,
        current_time,
        index: felt,
    ) {
        alloc_locals;

        let (beneficiary) = CarbonableOffseter.user_by_index(index);
        let (user_contribution) = CarbonableYielder_snapshoted_user_yielder_contribution_.read(
            beneficiary
        );

        // [Check] If user abosrption is null, then continue
        if (user_contribution == 0) {
            // [Check] If index is null, then stop
            if (index == 0) {
                return ();
            }

            return _create_vestings_iter(
                contract_address=contract_address,
                yielder_contribution=yielder_contribution,
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                carbonable_project_address=carbonable_project_address,
                current_time=current_time,
                index=index - 1,
            );
        }

        let (amount, _) = unsigned_div_rem(user_contribution * total_amount, yielder_contribution);
        let (amount_uint256) = _felt_to_uint(amount);

        // [Interaction] Starkvest - create vesting for address
        // Vesting, with no cliff period, no duration and no delay to start
        let (vesting_id) = ICarbonableVester.create_vesting(
            contract_address=contract_address,
            beneficiary=beneficiary,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
            amount_total=amount_uint256,
        );

        // [Check] if index is not null, then continue
        if (index != 0) {
            return _create_vestings_iter(
                contract_address=contract_address,
                yielder_contribution=yielder_contribution,
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                carbonable_project_address=carbonable_project_address,
                current_time=current_time,
                index=index - 1,
            );
        }
        return ();
    }
}

// Assert helpers
namespace CarbonableYielder_assert {
    func snapshoted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        // [Check] Snapshot has been executed
        let (time) = CarbonableYielder.snapshoted_time();
        with_attr error_message(
                "CarbonableYielder: create vestings must be executed after snapshot") {
            assert_not_zero(time);
        }
        return ();
    }

    func snapshotable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        // [Check] Previous vesting has been executed
        let (status) = CarbonableYielder_vested_.read();
        with_attr error_message(
                "CarbonableYielder: cannot snapshot if previous vesting has not been set") {
            assert status = TRUE;
        }

        // [Check] Snapshot timestamp is lower than the current time
        let (current_time) = get_block_timestamp();
        let (snapshoted_time) = CarbonableYielder.snapshoted_time();
        with_attr error_message(
                "CarbonableYielder: cannot snapshot at a sooner time that previous snapshot") {
            assert_in_range(snapshoted_time, 0, current_time);
        }

        // [Check] Project is setup
        let (carbonable_project_address) = CarbonableOffseter.carbonable_project_address();
        let (slot) = CarbonableOffseter.carbonable_project_slot();
        let (setup) = ICarbonableProject.isSetup(
            contract_address=carbonable_project_address, slot=slot
        );
        with_attr error_message("CarbonableYielder: cannot snapshot if the project is not set up") {
            assert setup = TRUE;
        }

        // [Check] At least 1 user registered
        let (count) = CarbonableOffseter.total_user_count();
        with_attr error_message(
                "CarbonableYielder: cannot snapshot or create vestings if no user has registered") {
            assert_not_zero(count);
        }
        return ();
    }

    func vestable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt
    ) {
        // [Check] Vesting has not been already executed
        let (status) = CarbonableYielder_vested_.read();
        with_attr error_message("CarbonableYielder: cannot vest if vesting has already been set") {
            assert status = FALSE;
        }

        // [Check] Vester has enough funds
        let (carbonable_vester_address) = CarbonableYielder.carbonable_vester_address();
        let (withdrawable_amount) = ICarbonableVester.withdrawable_amount(
            contract_address=carbonable_vester_address
        );
        let (total_amount_uint256) = _felt_to_uint(total_amount);
        with_attr error_message("CarbonableYielder: not enough unallocated amount into vester") {
            assert_uint256_le(total_amount_uint256, withdrawable_amount);
        }

        // [Check] At least 1 user registered
        let (count) = CarbonableOffseter.total_user_count();
        with_attr error_message(
                "CarbonableYielder: cannot snapshot or create vestings if no user has registered") {
            assert_not_zero(count);
        }
        return ();
    }
}
