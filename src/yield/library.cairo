// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn, assert_le
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_lt,
    uint256_eq,
    uint256_unsigned_div_rem,
    uint256_mul_div_mod,
)
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard

// Carbonable dependencies
from src.interfaces.starkvest import IStarkVest
from src.interfaces.project import ICarbonableProject

//
// Events
//

@event
func VestingsCreated(total_amount: felt, time: felt) {
}

@event
func VestingOfAddrCreated(address: felt, vesting_id: felt, time: felt) {
}

//
// Storage variables - Common
//

@storage_var
func carbonable_project_address_() -> (address: felt) {
}

@storage_var
func starkvest_address_() -> (address: felt) {
}

@storage_var
func start_() -> (time: felt) {
}

@storage_var
func unlocked_duration_() -> (duration: felt) {
}

@storage_var
func period_duration_() -> (duration: felt) {
}

@storage_var
func registration_(token_id: Uint256) -> (address: felt) {
}

//
// Storage variables - Yield
//

@storage_var
func vestings_created_() -> (vesting_created: felt) {
}

namespace CarbonableYielder {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt, starkvest_address: felt
    ) {
        carbonable_project_address_.write(carbonable_project_address);
        starkvest_address_.write(starkvest_address);
        return ();
    }

    //
    // Getters
    //

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = carbonable_project_address_.read();
        return (carbonable_project_address,);
    }

    func carbonable_minter_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (carbonable_minter_address: felt) {
        let (carbonable_project_address) = carbonable_project_address_.read();
        let (carbonable_minter_address) = ICarbonableProject.owner(carbonable_project_address);
        return (carbonable_minter_address=carbonable_minter_address,);
    }

    func get_start_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        start_time: felt
    ) {
        let (start) = start_.read();
        return (start_time=start,);
    }

    func get_lock_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        lock_time: felt
    ) {
        let (start) = get_start_time();
        let (unlocked_duration) = unlocked_duration_.read();
        return (lock_time=start + unlocked_duration,);
    }

    func get_end_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        end_time: felt
    ) {
        let (start) = get_start_time();
        let (period_duration) = period_duration_.read();
        return (end_time=start + period_duration,);
    }

    func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        alloc_locals;

        // [Compute] Absolute times
        let (current_time) = get_block_timestamp();
        let (lock_time) = get_lock_time();
        let (end_time) = get_end_time();

        // [Evaluate] Boudaries and current time
        let is_before_lock = is_le(current_time, lock_time);
        let is_after_lock = is_le(end_time, current_time);
        let over = is_not_zero(is_before_lock + is_after_lock);
        let status = 1 - over;

        return (status=status,);
    }

    func total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        balance: Uint256
    ) {
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = carbonable_project_address_.read();

        let (balance) = IERC721.balanceOf(
            contract_address=carbonable_project_address, owner=contract_address
        );

        return (balance=balance,);
    }

    func shares_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt, precision: felt
    ) -> (shares: Uint256) {
        alloc_locals;

        let (total_deposit) = balance_of(address);
        let (total_contract) = total_locked();

        let dividend = precision * total_deposit;
        let dividend_uint256 = Uint256(low=dividend, high=0);

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableYielder: dividend_uint256 is not a valid Uint256") {
            uint256_check(dividend_uint256);
        }

        let (shares, _) = uint256_unsigned_div_rem(dividend_uint256, total_contract);
        return (shares=shares,);
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (balance: felt) {
        alloc_locals;

        let (balance) = _count(address);
        return (balance=balance,);
    }

    func registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (address: felt) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableYielder: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        // [Check] Owned token id
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = carbonable_project_address_.read();
        // [Check] Throws error if unknown token id
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableYielder: token_id has not been registred") {
            assert owner = contract_address;
        }

        let (address) = registration_.read(token_id);
        return (address=address,);
    }

    //
    // Externals
    //

    func start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt
    ) -> (success: felt) {
        // [Check] Duration inputs validity
        with_attr error_message("CarbonableYielder: Invalid period duration") {
            assert_nn(period_duration);
        }
        with_attr error_message("CarbonableYielder: Invalid locked duration") {
            assert_le(unlocked_duration, period_duration);
        }

        // [Effect] Store period information
        let (current_time) = get_block_timestamp();
        start_.write(current_time);
        period_duration_.write(period_duration);
        unlocked_duration_.write(unlocked_duration);

        // [Effect] Reset Vestings status
        vestings_created_.write(0);

        return (success=TRUE,);
    }

    func stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        // [Check] Current period
        let (current_time) = get_block_timestamp();
        let (start) = start_.read();
        let (period_duration) = period_duration_.read();
        let end = start + period_duration;
        with_attr error_message("CarbonableYielder: No current period") {
            assert_le(current_time, end);
        }

        // [Effect] Reset period information
        start_.write(0);
        period_duration_.write(0);
        unlocked_duration_.write(0);

        return (success=TRUE,);
    }

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Locked status
        let (status) = is_locked();
        with_attr error_message("CarbonableYielder: deposits are currently locked") {
            assert status = FALSE;
        }

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableYielder: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // [Interaction] Transfer token_id from caller to contract
        let (carbonable_project_address) = carbonable_project_address_.read();
        let (caller) = get_caller_address();
        let (contract_address) = get_contract_address();
        IERC721.transferFrom(
            contract_address=carbonable_project_address,
            from_=caller,
            to=contract_address,
            tokenId=token_id,
        );

        // [Check] Transfer successful
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableYielder: transfer failed") {
            assert owner = contract_address;
        }

        // [Effect] Register the caller with the token id
        registration_.write(token_id, caller);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success=TRUE,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Locked status
        let (status) = is_locked();
        with_attr error_message("CarbonableYielder: withdrawals are currently locked") {
            assert status = FALSE;
        }

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableYielder: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // [Effect] Remove the caller from registration for the token id
        registration_.write(token_id, 0);

        // [Interaction] Transfer token_id from contract to call
        let (carbonable_project_address) = carbonable_project_address_.read();
        let (contract_address) = get_contract_address();
        let (caller) = get_caller_address();
        IERC721.transferFrom(
            contract_address=carbonable_project_address,
            from_=contract_address,
            to=caller,
            tokenId=token_id,
        );

        // [Check] Transfer successful
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableYielder: transfer failed") {
            assert owner = caller;
        }

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success=TRUE,);
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

        // [Check] Locked period
        let (status) = is_locked();
        with_attr error_message(
                "CarbonableYielder: create vestings must be executed in locked period") {
            assert status = TRUE;
        }

        // [Check] Create Vesting not yet executed for the current period
        let (vestings_created) = vestings_created_.read();
        with_attr error_message(
                "CarbonableYielder: vestings was already executed for the current period") {
            assert vestings_created = FALSE;
        }

        // [Effect] Update snapshot status
        vestings_created_.write(TRUE);

        // [Interaction] Run create_vestings
        _create_vestings(
            total_amount=total_amount,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
        );

        // [Event] Emit all vesting are created
        let (current_time) = get_block_timestamp();
        VestingsCreated.emit(total_amount=total_amount, time=current_time);

        return (success=TRUE,);
    }

    //
    // Internals
    //

    func _count{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
        count: felt
    ) {
        alloc_locals;

        let (contract_address) = carbonable_project_address_.read();
        let (total_supply) = IERC721Enumerable.totalSupply(contract_address=contract_address);

        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(total_supply, zero);
        if (is_zero == TRUE) {
            return (count=0,);
        }

        let one = Uint256(low=1, high=0);
        let (index) = SafeUint256.sub_le(total_supply, one);
        let (count) = _count_iter(contract_address=contract_address, address=address, index=index);

        return (count=count,);
    }

    func _count_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt, address: felt, index: Uint256
    ) -> (count: felt) {
        alloc_locals;

        // Get registred owner of the current token index
        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index
        );
        let (owner) = registration_.read(token_id);

        // Increment the counter if owner is the specified address
        let not_eq = is_not_zero(owner - address);
        let count = 1 - not_eq;

        // Stop if index is null
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(index, zero);
        if (is_zero == TRUE) {
            return (count=count,);
        }

        // Else move on to next index
        let one = Uint256(low=1, high=0);
        let (next) = SafeUint256.sub_le(index, one);
        let (add) = _count_iter(contract_address=contract_address, address=address, index=next);
        return (count=count + add,);
    }

    func _create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) {
        alloc_locals;

        let zero = Uint256(low=0, high=0);
        let (starkvest_address) = starkvest_address_.read();
        let (contract_address) = carbonable_project_address_.read();
        let (total_supply) = IERC721Enumerable.totalSupply(contract_address=contract_address);

        let (is_zero) = uint256_eq(total_supply, zero);
        if (is_zero == TRUE) {
            return ();
        }

        // [Check] Enough unallocated amount into starkvest
        _check_enough_amount(total_amount=total_amount, total_supply=total_supply);

        let one = Uint256(low=1, high=0);
        let (index) = SafeUint256.sub_le(total_supply, one);
        let (token_total_deposited) = total_locked();
        return _create_vestings_iter(
            contract_address=contract_address,
            starkvest_address=starkvest_address,
            total_amount=total_amount,
            token_total_deposited=token_total_deposited,
            index=index,
            total_supply=total_supply,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
        );
    }

    func _check_enough_amount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt, total_supply: Uint256
    ) {
        alloc_locals;

        let (starkvest_address) = starkvest_address_.read();
        // [Interaction] Starkvest - withdrawable amount
        let (releasable_amount) = IStarkVest.withdrawable_amount(starkvest_address);

        // [Check] Enough unallocated amount into starkvest
        let total_amount_unint256 = Uint256(low=total_amount, high=0);
        let (enough_unallocated_amount) = uint256_lt(releasable_amount, total_amount_unint256);
        with_attr error_message("CarbonableYielder: not enough unallocated amount into starkvest") {
            assert enough_unallocated_amount = FALSE;
        }

        return ();
    }

    func _create_vestings_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt,
        starkvest_address: felt,
        total_amount: felt,
        token_total_deposited: Uint256,
        index: Uint256,
        total_supply: Uint256,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) {
        alloc_locals;

        // Get registred address of the current token index
        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index
        );
        let (address) = registration_.read(token_id);

        // If registred then create a vesting for each token_id
        let one = Uint256(low=1, high=0);
        if (address != 0) {
            // The value 1 is the 1 token_id
            let address_token_amount = 1;
            let (address_amount) = _amount_to_vest(
                token_total_deposited=token_total_deposited,
                total_amount=total_amount,
                address_token_amount=address_token_amount,
            );

            // [Interaction] Starkvest - create vesting for address
            // Vesting, with no cliff period, no duration and no delay to start
            let beneficiary = address;

            // [Interaction] Starkvest - create vesting for address
            let (vesting_id) = IStarkVest.create_vesting(
                starkvest_address,
                beneficiary,
                cliff_delta,
                start,
                duration,
                slice_period_seconds,
                revocable,
                address_amount,
            );

            // [Event] Emit addr vesting are created
            let (current_time) = get_block_timestamp();
            VestingOfAddrCreated.emit(address=address, vesting_id=vesting_id, time=current_time);

            tempvar _syscall_ptr = syscall_ptr;
            tempvar _pedersen_ptr = pedersen_ptr;
            tempvar _range_check_ptr = range_check_ptr;
        } else {
            tempvar _syscall_ptr = syscall_ptr;
            tempvar _pedersen_ptr = pedersen_ptr;
            tempvar _range_check_ptr = range_check_ptr;
        }
        let syscall_ptr = _syscall_ptr;
        let pedersen_ptr = _pedersen_ptr;
        let range_check_ptr = _range_check_ptr;

        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(index, zero);
        // Stop recursion if index is 0
        if (is_zero == TRUE) {
            return ();
        }
        // Else move on to the next index
        let (next) = SafeUint256.sub_le(index, one);
        return _create_vestings_iter(
            contract_address=contract_address,
            starkvest_address=starkvest_address,
            total_amount=total_amount,
            token_total_deposited=token_total_deposited,
            index=next,
            total_supply=total_supply,
            cliff_delta=cliff_delta,
            start=start,
            duration=duration,
            slice_period_seconds=slice_period_seconds,
            revocable=revocable,
        );
    }

    // We have to make a cross product, between address_token_amount, total_amount and token_total_deposited
    // to find the amount to distribut
    func _amount_to_vest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_total_deposited: Uint256, total_amount: felt, address_token_amount: felt
    ) -> (amount: Uint256) {
        let dividend = total_amount * address_token_amount;
        let dividend_uint256 = Uint256(low=dividend, high=0);

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableYielder: dividend_uint256 is not a valid Uint256") {
            uint256_check(dividend_uint256);
        }

        let (amount, _) = uint256_unsigned_div_rem(dividend_uint256, token_total_deposited);

        return (amount=amount,);
    }
}
