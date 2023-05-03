// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_in_range, unsigned_div_rem
from starkware.cairo.common.uint256 import assert_uint256_le
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20

// Local dependencies
from src.interfaces.offseter import ICarbonableOffseter
from src.interfaces.project import ICarbonableProject
from src.offset.library import CarbonableOffseter
from src.utils.type.library import _felt_to_uint

//
// Events
//

@event
func Claim(address: felt, amount: felt, time: felt) {
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
func Provision(project: felt, amount: felt, time: felt) {
}

//
// Storages
//

@storage_var
func CarbonableYielder_carbonable_offseter_address_() -> (address: felt) {
}

@storage_var
func CarbonableYielder_payment_token_address_() -> (address: felt) {
}

@storage_var
func CarbonableYielder_claimable_(address: felt) -> (amount: felt) {
}

@storage_var
func CarbonableYielder_claimed_(address: felt) -> (amount: felt) {
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
func CarbonableYielder_provisioned_() -> (status: felt) {
}

@storage_var
func CarbonableYielder_total_amount_() -> (amount: felt) {
}

@storage_var
func CarbonableYielder_amount_() -> (amount: felt) {
}

@storage_var
func CarbonableYielder_amount_remainder_() -> (amount: felt) {
}

namespace CarbonableYielder {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_offseter_address: felt, payment_token_address: felt
    ) {
        CarbonableYielder_carbonable_offseter_address_.write(carbonable_offseter_address);
        CarbonableYielder_payment_token_address_.write(payment_token_address);
        CarbonableYielder_provisioned_.write(TRUE);  // To enable first snapshot
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

    func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address: felt) {
        let (payment_token_address) = CarbonableYielder_payment_token_address_.read();
        return (payment_token_address=payment_token_address);
    }

    func total_provisioned{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_provisioned: felt
    ) {
        let (amount) = CarbonableYielder_total_amount_.read();
        return (total_provisioned=amount);
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

    func claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        // [Compute] Claimable
        let (amount) = CarbonableYielder_amount_.read();
        let (stored_claimable) = CarbonableYielder_claimable_.read(address);
        let (stored_claimed) = CarbonableYielder_claimed_.read(address);
        let (contribution) = CarbonableYielder_snapshoted_user_yielder_contribution_.read(address);
        let (total) = CarbonableYielder_snapshoted_yielder_contribution_.read();
        let (computed_claimable, _) = unsigned_div_rem(amount * contribution, total);
        let claimable = stored_claimable + computed_claimable - stored_claimed;

        // [Check] Overflow
        with_attr error_message("CarbonableYielder: overflow while computing claimable") {
            assert_in_range(computed_claimable, 0, amount + 1);
        }

        return (claimable=claimable);
    }

    func claimed_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimed: felt) {
        let (claimed) = CarbonableYielder_claimed_.read(address);
        return (claimed=claimed);
    }

    //
    // Externals
    //

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        // [Check] Claimable is not null
        let (caller) = get_caller_address();
        let (claimable) = claimable_of(caller);
        with_attr error_message("CarbonableYielder: nothing to claim") {
            assert_not_zero(claimable);
        }

        // [Effect] Add claimed value
        let (stored_claimed) = CarbonableYielder_claimed_.read(caller);
        let claimed = stored_claimed + claimable;
        CarbonableYielder_claimed_.write(caller, claimed);

        // [Check] Claimable is null
        let (new_claimable) = claimable_of(caller);
        with_attr error_message("CarbonableYielder: nothing to claim") {
            assert new_claimable = 0;
        }

        // [Interaction] ERC20 transfer
        let (token_address) = CarbonableYielder_payment_token_address_.read();
        let (claimable_u256) = _felt_to_uint(claimable);
        let (transfer_success) = IERC20.transfer(
            contract_address=token_address, recipient=caller, amount=claimable_u256
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableYielder: transfer failed") {
            assert transfer_success = TRUE;
        }

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        Claim.emit(address=caller, amount=claimable, time=current_time);

        return (success=TRUE);
    }

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
        let (previous_yielder_contribution) = CarbonableYielder_snapshoted_yielder_contribution_.read();

        // [Compute] Current information
        let (current_project_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=carbonable_project_address, slot=slot
        );
        let (current_offseter_absorption) = ICarbonableOffseter.getTotalAbsorption(
            contract_address=carbonable_offseter_address
        );
        let (current_yielder_absorption) = CarbonableOffseter.total_absorption();

        // [Check] Yielder contribution not null
        let period_project_absorption = current_project_absorption - previous_project_absorption;
        let period_offseter_absorption = current_offseter_absorption - previous_offseter_absorption;
        let period_yielder_absorption = current_yielder_absorption - previous_yielder_absorption;
        with_attr error_message(
                "CarbonableYielder: cannot snapshot if the current yielder contribution is null") {
            assert_not_zero(period_yielder_absorption);
        }

        // [Effect] Store snapshot values
        let (current_time) = get_block_timestamp();
        CarbonableYielder_snapshoted_time_.write(current_time);
        CarbonableYielder_snapshoted_offseter_absorption_.write(current_offseter_absorption);
        CarbonableYielder_snapshoted_yielder_absorption_.write(current_yielder_absorption);
        CarbonableYielder_snapshoted_yielder_contribution_.write(period_yielder_absorption);

        // [Effect] Store period shares per users, previous amount remainder is added to the current amount
        let (count) = CarbonableOffseter.total_user_count();
        let (amount) = CarbonableYielder_amount_.read();
        let (remainder) = CarbonableYielder_amount_remainder_.read();
        let (new_remainder) = _snapshot_iter(
            index=count - 1,
            amount=amount + remainder,
            previous_yielder_contribution=previous_yielder_contribution,
            remainder=0,
        );

        // [Effect] Update provisioned status
        CarbonableYielder_amount_remainder_.write(new_remainder);
        CarbonableYielder_provisioned_.write(FALSE);
        CarbonableYielder_amount_.write(0);

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

    func provision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        amount: felt
    ) -> (success: felt) {
        alloc_locals;

        // [Check] Snapshot has been executed and provisionable
        CarbonableYielder_assert.snapshoted();
        CarbonableYielder_assert.provisionable();

        // [Check] Amount is not null
        with_attr error_message("CarbonableYielder: cannot provision with a null amount") {
            assert_not_zero(amount);
        }

        // [Interaction] ERC20 transfer
        let (token_address) = CarbonableYielder_payment_token_address_.read();
        let (caller) = get_caller_address();
        let (recipient) = get_contract_address();
        let (amount_u256) = _felt_to_uint(amount);
        let (transfer_success) = IERC20.transferFrom(
            contract_address=token_address, sender=caller, recipient=recipient, amount=amount_u256
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableYielder: transfer failed") {
            assert transfer_success = TRUE;
        }

        // [Effect] Update provision status and amounts
        CarbonableYielder_provisioned_.write(TRUE);
        CarbonableYielder_amount_.write(amount);
        let (total_amount) = CarbonableYielder_total_amount_.read();
        CarbonableYielder_total_amount_.write(total_amount + amount);

        // [Event] Emit provision event
        let (current_time) = get_block_timestamp();
        let (carbonable_project_address) = CarbonableOffseter.carbonable_project_address();
        Provision.emit(project=carbonable_project_address, amount=amount, time=current_time);

        return (success=TRUE);
    }

    //
    // Internals
    //

    func _snapshot_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, amount: felt, previous_yielder_contribution: felt, remainder: felt
    ) -> (new_remainder: felt) {
        alloc_locals;

        // [Compute] User absorptions and contribution
        let (user) = CarbonableOffseter.user_by_index(index);
        let (current_user_absorption) = CarbonableOffseter.absorption_of(address=user);
        let (previous_user_absorption) = CarbonableYielder_snapshoted_user_yielder_absorption_.read(
            user
        );
        let (
            previous_user_contribution
        ) = CarbonableYielder_snapshoted_user_yielder_contribution_.read(user);

        // [Check] User contribution overflow
        with_attr error_message("CarbonableYielder: user contribution overflow detected") {
            assert_in_range(previous_user_absorption, 0, current_user_absorption + 1);
        }
        let period_user_contribution = current_user_absorption - previous_user_absorption;

        // [Effect] Store new snapshoted absorptions and contibution
        CarbonableYielder_snapshoted_user_yielder_absorption_.write(user, current_user_absorption);
        CarbonableYielder_snapshoted_user_yielder_contribution_.write(user, period_user_contribution);

        // [Effect] Update user claimable if previous_yielder_contribution != 0
        let new_remainder = 0;
        if (previous_yielder_contribution != 0) {
            let (stored_claimable) = CarbonableYielder_claimable_.read(user);
            let (new_claimable, rem) = unsigned_div_rem(
                previous_user_contribution * amount, previous_yielder_contribution
            );
            CarbonableYielder_claimable_.write(user, stored_claimable + new_claimable);
            new_remainder = rem;
        }

        // [Check] If not last, then continue
        if (index != 0) {
            return _snapshot_iter(
                index=index - 1,
                amount=amount,
                previous_yielder_contribution=previous_yielder_contribution,
                remainder=remainder + new_remainder,
            );
        }
        return (new_remainder=remainder + new_remainder);
    }
}

// Assert helpers
namespace CarbonableYielder_assert {
    func snapshoted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        // [Check] Snapshot has been executed
        let (time) = CarbonableYielder.snapshoted_time();
        with_attr error_message("CarbonableYielder: provision must be executed after snapshot") {
            assert_not_zero(time);
        }
        return ();
    }

    func snapshotable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        // [Check] Previous provision has been executed
        let (status) = CarbonableYielder_provisioned_.read();
        with_attr error_message(
                "CarbonableYielder: cannot snapshot if previous provision has not been set") {
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
                "CarbonableYielder: cannot snapshot or provision if no user has registered") {
            assert_not_zero(count);
        }
        return ();
    }

    func provisionable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        // [Check] Provision has already been set
        let (status) = CarbonableYielder_provisioned_.read();
        with_attr error_message("CarbonableYielder: cannot provision if it has already been set") {
            assert status = FALSE;
        }
        return ();
    }
}
