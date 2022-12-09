// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.uint256 import uint256_lt
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
func Claim(address: felt, absorption: felt, time: felt) {
}

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
func Vestings(total_amount: felt, time: felt) {
}

@event
func Vesting(address: felt, vesting_id: felt, amount: felt, time: felt) {
}

//
// Storages
//

@storage_var
func carbonable_offseter_address_() -> (address: felt) {
}

@storage_var
func carbonable_vester_address_() -> (address: felt) {
}

@storage_var
func snapshoted_offseter_absorption_() -> (absorption: felt) {
}

@storage_var
func snapshoted_yielder_absorption_() -> (absorption: felt) {
}

@storage_var
func snapshoted_yielder_contribution_() -> (absorption: felt) {
}

@storage_var
func snapshoted_user_absorption_(address: felt) -> (absorption: felt) {
}

@storage_var
func snapshoted_user_contribution_(address: felt) -> (absorption: felt) {
}

@storage_var
func snapshoted_time_() -> (time: felt) {
}

namespace CarbonableYielder {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_offseter_address: felt, carbonable_vester_address: felt
    ) {
        carbonable_offseter_address_.write(carbonable_offseter_address);
        carbonable_vester_address_.write(carbonable_vester_address);
        return ();
    }

    //
    // Getters
    //

    func carbonable_offseter_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_offseter_address: felt) {
        let (carbonable_offseter_address) = carbonable_offseter_address_.read();
        return (carbonable_offseter_address,);
    }

    func carbonable_vester_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (carbonable_vester_address: felt) {
        let (carbonable_vester_address) = carbonable_vester_address_.read();
        return (carbonable_vester_address,);
    }

    func snapshoted_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        time: felt
    ) {
        let (time) = snapshoted_time_.read();
        return (time,);
    }

    //
    // Externals
    //

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        alloc_locals;

        // [Check] At least 1 user registered
        let (users_len, users) = CarbonableYielder_assert.is_snapshotable();

        let (carbonable_project_address) = CarbonableOffseter.carbonable_project_address();
        let (carbonable_offseter_address) = carbonable_offseter_address_.read();

        // [Compute] Previous information
        let (previous_time) = snapshoted_time_.read();
        let (previous_project_absorption) = ICarbonableProject.getAbsorption(
            contract_address=carbonable_project_address, time=previous_time
        );
        let (previous_offseter_absorption) = snapshoted_offseter_absorption_.read();
        let (previous_yielder_absorption) = snapshoted_yielder_absorption_.read();

        // [Compute] Current information
        let (current_project_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=carbonable_project_address
        );

        let (current_total_claimable) = ICarbonableOffseter.getTotalClaimable(
            contract_address=carbonable_offseter_address
        );
        let (current_total_claimed) = ICarbonableOffseter.getTotalClaimed(
            contract_address=carbonable_offseter_address
        );
        let current_offseter_absorption = current_total_claimed + current_total_claimable;

        let (current_total_claimable) = CarbonableOffseter.total_claimable();
        let (current_total_claimed) = CarbonableOffseter.total_claimed();
        let current_yielder_absorption = current_total_claimed + current_total_claimable;

        // [Compute] Period information
        let period_project_absorption = current_project_absorption - previous_project_absorption;
        let period_offseter_absorption = current_offseter_absorption - previous_offseter_absorption;
        let period_yielder_absorption = current_yielder_absorption - previous_yielder_absorption;

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
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

        // [Effect] Store snapshot values
        snapshoted_time_.write(current_time);
        snapshoted_offseter_absorption_.write(current_offseter_absorption);
        snapshoted_yielder_absorption_.write(current_yielder_absorption);
        snapshoted_yielder_contribution_.write(period_yielder_absorption);

        // [Effect] Store period shares per users
        _snapshot_iter(users_index=users_len - 1, users=users);

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
        CarbonableYielder_assert.is_snapshoted();
        let (users_len, users) = CarbonableYielder_assert.is_vestable(total_amount);

        // [Interaction] Run create_vestings
        let (carbonable_vester_address) = carbonable_vester_address_.read();
        _create_vestings_iter(
            contract_address=carbonable_vester_address,
            total_amount=total_amount,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
            users_index=users_len - 1,
            users=users,
        );

        // [Event] Emit all vesting are created
        let (current_time) = get_block_timestamp();
        Vestings.emit(total_amount=total_amount, time=current_time);

        return (success=TRUE);
    }

    //
    // Internals
    //

    func _snapshot_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        users_index: felt, users: felt*
    ) {
        alloc_locals;

        let user = users[users_index];
        let (claimable) = CarbonableOffseter.claimable_of(user);
        let (claimed) = CarbonableOffseter.claimed_of(user);
        let current_absorption = claimable + claimed;
        let (previous_absorption) = snapshoted_user_absorption_.read(user);

        // [Check] Overflow
        let is_lower = is_le(current_absorption + 1, previous_absorption);  // is_lt
        with_attr error_message("CarbonableYielder: user contribution overflow detected") {
            assert is_lower = FALSE;
        }
        let period_contribution = current_absorption - previous_absorption;

        // [Effect] Store new snapshoted absorption
        snapshoted_user_absorption_.write(user, current_absorption);
        // [Effect] Store new snapshoted contribution (period absorption)
        snapshoted_user_contribution_.write(user, period_contribution);

        // [Check] If not last, then continue
        if (users_index != 0) {
            _snapshot_iter(users_index=users_index - 1, users=users);
        }
        return ();
    }

    func _create_vestings_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt,
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        users_index: felt,
        users: felt*,
    ) {
        alloc_locals;

        let beneficiary = users[users_index];
        let (user_contribution) = snapshoted_user_contribution_.read(beneficiary);

        // [Check] If user abosrption is null, then continue
        if (user_contribution == 0) {
            _create_vestings_iter(
                contract_address=contract_address,
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                users_index=users_index - 1,
                users=users,
            );
            return ();
        }

        let (yielder_contribution) = snapshoted_yielder_contribution_.read();
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

        // [Event] Emit addr vesting are created
        let (current_time) = get_block_timestamp();
        Vesting.emit(address=beneficiary, vesting_id=vesting_id, amount=amount, time=current_time);

        // [Check] if index is not null, then continue
        if (users_index != 0) {
            _create_vestings_iter(
                contract_address=contract_address,
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                users_index=users_index - 1,
                users=users,
            );
            return ();
        }
        return ();
    }
}

// Assert helpers
namespace CarbonableYielder_assert {
    func is_snapshoted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        // [Check] Snapshot has been executed
        let (time) = CarbonableYielder.snapshoted_time();
        let not_zero = is_not_zero(time);
        with_attr error_message(
                "CarbonableYielder: create vestings must be executed after snapshot") {
            assert not_zero = TRUE;
        }
        return ();
    }

    func is_snapshotable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        users_len: felt, users: felt*
    ) {
        // [Check] At least 1 user registered
        let (users_len, users) = CarbonableOffseter.registered_users();
        let not_zero = is_not_zero(users_len);
        with_attr error_message(
                "CarbonableYielder: cannot snapshot or create vestings if no user has registered") {
            assert not_zero = TRUE;
        }
        return (users_len=users_len, users=users);
    }

    func is_vestable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt
    ) -> (users_len: felt, users: felt*) {
        let (users_len, users) = is_snapshotable();

        // [Check] Vester has enough funds
        let (carbonable_vester_address) = CarbonableYielder.carbonable_vester_address();
        let (withdrawable_amount) = ICarbonableVester.withdrawable_amount(
            contract_address=carbonable_vester_address
        );
        let (total_amount_uint256) = _felt_to_uint(total_amount);
        let (is_not_enough) = uint256_lt(withdrawable_amount, total_amount_uint256);
        with_attr error_message("CarbonableYielder: not enough unallocated amount into starkvest") {
            assert is_not_enough = FALSE;
        }
        return (users_len=users_len, users=users);
    }
}
