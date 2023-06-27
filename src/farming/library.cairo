// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le, assert_nn_le, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_eq,
    uint256_mul_div_mod,
    assert_uint256_le,
    assert_uint256_eq,
)
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)

// Project dependencies
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard
from openzeppelin.security.safemath.library import SafeUint256
from erc3525.IERC3525 import IERC3525

// Local dependencies
from src.interfaces.project import ICarbonableProject
from src.interfaces.minter import ICarbonableMinter
from src.utils.array.library import Array
from src.utils.math.library import Math, LINEAR, CONSTANT, CONST_LEFT, NULL, NEXT
from src.utils.type.library import _felt_to_uint, _uint_to_felt

//
// Constants
//

const TIME_SK = 'TIME';
const PRICE_SK = 'PRICE';
const YEAR_SECONDS = 31556925;

//
// Events
//

@event
func Deposit(address: felt, value: Uint256, time: felt) {
}

@event
func Withdraw(address: felt, value: Uint256, time: felt) {
}

@event
func PriceUpdate(time: felt, price: felt) {
}

//
// Storages
//

// Contract settings

@storage_var
func CarbonableFarming_carbonable_project_address_() -> (address: felt) {
}

@storage_var
func CarbonableFarming_carbonable_project_slot_() -> (slot: Uint256) {
}

// Contract total records

@storage_var
func CarbonableFarming_total_absorption_() -> (absorption: felt) {
}

@storage_var
func CarbonableFarming_total_sale_() -> (sale: felt) {
}

@storage_var
func CarbonableFarming_total_registered_value_() -> (value: Uint256) {
}

@storage_var
func CarbonableFarming_total_registered_time_() -> (time: felt) {
}

// Contract user records

@storage_var
func CarbonableFarming_absorption_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableFarming_sale_(address: felt) -> (sale: felt) {
}

@storage_var
func CarbonableFarming_registered_value_(address: felt) -> (value: Uint256) {
}

@storage_var
func CarbonableFarming_registered_time_(address: felt) -> (time: felt) {
}

namespace CarbonableFarming {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt, carbonable_project_slot: Uint256
    ) {
        CarbonableFarming_carbonable_project_address_.write(carbonable_project_address);
        CarbonableFarming_carbonable_project_slot_.write(carbonable_project_slot);
        return ();
    }

    //
    // Getters
    //

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = CarbonableFarming_carbonable_project_address_.read();
        return (carbonable_project_address=carbonable_project_address);
    }

    func carbonable_project_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (carbonable_project_slot: Uint256) {
        let (carbonable_project_slot) = CarbonableFarming_carbonable_project_slot_.read();
        return (carbonable_project_slot=carbonable_project_slot);
    }

    func total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        value: Uint256
    ) {
        let (value) = CarbonableFarming_total_registered_value_.read();
        return (value=value);
    }

    func total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorption: felt
    ) {
        let (computed) = _compute_total_absorption();
        let (stored) = CarbonableFarming_total_absorption_.read();
        return (absorption=computed + stored);
    }

    func max_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        absorption: felt
    ) {
        // [Compute] Max absorption, which is the whole project absorption until now
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address, slot=slot
        );
        return (absorption=absorption);
    }

    func total_sale{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        sale: felt
    ) {
        alloc_locals;

        // [Check] Price is setup, otherwise return 0
        let (len) = Array.read_len(key=TIME_SK);
        if (len == 0) {
            return (sale=0);
        }

        // [Check] Ton equivalent is not zero
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (ton_equivalent) = ICarbonableProject.getTonEquivalent(
            contract_address=contract_address, slot=slot
        );
        if (ton_equivalent == 0) {
            return (sale=0);
        }

        // [Compute] Total sale
        let (computed) = _compute_total_sale();
        let (stored) = CarbonableFarming_total_sale_.read();
        let (sale_in_dollars, _) = unsigned_div_rem(computed + stored, ton_equivalent);

        return (sale=sale_in_dollars);
    }

    func max_sale{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        sale: felt
    ) {
        alloc_locals;

        // [Check] Price is setup, otherwise return 0
        let (len) = Array.read_len(key=TIME_SK);
        if (len == 0) {
            return (sale=0);
        }

        // [Check] Ton equivalent is not zero
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (ton_equivalent) = ICarbonableProject.getTonEquivalent(
            contract_address=contract_address, slot=slot
        );
        if (ton_equivalent == 0) {
            return (sale=0);
        }

        // [Compute] Max sale, which is the whole project sale until now
        let (project_value) = ICarbonableProject.getProjectValue(
            contract_address=contract_address, slot=slot
        );
        let (first_time) = ICarbonableProject.getStartTime(
            contract_address=contract_address, slot=slot
        );
        let (sale) = _compute_sale(value=project_value, time=first_time);
        let (sale_in_dollars, _) = unsigned_div_rem(sale, ton_equivalent);
        return (sale=sale_in_dollars);
    }

    func deposited_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (value: Uint256) {
        let (value) = CarbonableFarming_registered_value_.read(address);
        return (value=value);
    }

    func absorption_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        let (computed) = _compute_user_absorption(address=address);
        let (stored) = CarbonableFarming_absorption_.read(address);

        return (absorption=computed + stored);
    }

    func sale_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (sale: felt) {
        alloc_locals;

        // [Check] Price is setup, otherwise return 0
        let (len) = Array.read_len(key=TIME_SK);
        if (len == 0) {
            return (sale=0);
        }

        // [Check] Ton equivalent is not zero
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (ton_equivalent) = ICarbonableProject.getTonEquivalent(
            contract_address=contract_address, slot=slot
        );
        if (ton_equivalent == 0) {
            return (sale=0);
        }

        // [Compute] User sale and convert from g * µ$/t to µ$
        let (computed) = _compute_user_sale(address=address);
        let (stored) = CarbonableFarming_sale_.read(address);
        let (sale_in_dollars, _) = unsigned_div_rem(computed + stored, ton_equivalent);

        return (sale=sale_in_dollars);
    }

    func current_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        current_price: felt
    ) {
        alloc_locals;

        let (len, times, _, updated_prices, _) = CarbonableFarming._compute_cumsales();
        let (time) = get_block_timestamp();
        let current_price = Math.interpolate(
            x=time,
            len=len,
            xs=times,
            ys=updated_prices,
            interpolation=CONST_LEFT,
            extrapolation=NULL,
        );

        return (current_price=current_price);
    }

    func prices{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        len: felt, times: felt*, prices: felt*, updated_prices: felt*, cumsales: felt*
    ) {
        alloc_locals;

        return CarbonableFarming._compute_cumsales();
    }

    func apr{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(minter_address: felt) -> (
        num: felt, den: felt
    ) {
        alloc_locals;

        let (len, times, _, _, cumsales) = CarbonableFarming._compute_cumsales();

        // [Compute] Current cumsale
        let (time) = get_block_timestamp();
        let current_cumsale = Math.interpolate(
            x=time,
            len=len,
            xs=times,
            ys=cumsales,
            interpolation=LINEAR,
            extrapolation=CONSTANT,
        );

        // [Compute] Latest cumsale
        let (closest_index) = Math.closest_index(
            x=time,
            len=len,
            xs=times,
            side=NEXT,
        );
        let next_time = times[closest_index];
        let next_cumsale = cumsales[closest_index];

        // [Check] Overflow
        with_attr error_message("CarbonableFarming: apr overflow") {
            assert_le(time + 1, next_time);
            assert_le(current_cumsale, next_cumsale);
        }

        // [Compute] Total investement
        let (project_address) = CarbonableFarming_carbonable_project_address_.read();
        let (project_slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (project_value_u256) = ICarbonableProject.getProjectValue(
            contract_address=project_address,
            slot=project_slot,
        );
        let (project_value) = _uint_to_felt(project_value_u256);
        let (unit_price) = ICarbonableMinter.getUnitPrice(contract_address=minter_address);
        let (ton_equivalent) = ICarbonableProject.getTonEquivalent(
            contract_address=project_address,
            slot=project_slot,
        );

        // [Compute] APR
        return (
            num=(next_cumsale - current_cumsale) * YEAR_SECONDS,
            den=project_value * unit_price * (next_time - time) * ton_equivalent
        );
    }

    //
    // Externals
    //

    func set_prices{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        times_len: felt, times: felt*, prices_len, prices: felt*
    ) {
        alloc_locals;

        Array.store(key=TIME_SK, len=times_len, values=times);
        Array.store(key=PRICE_SK, len=prices_len, values=prices);

        return ();
    }

    func add_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time: felt, price: felt
    ) {
        alloc_locals;

        // [Check] Time is later than the project start time
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (first_time) = ICarbonableProject.getStartTime(
            contract_address=contract_address, slot=slot
        );
        with_attr error_message("CarbonableFarming: time is sooner than the project start time") {
            assert_le(first_time + 1, time);
        }

        // [Check] First time to store
        let (len) = Array.read_len(key=TIME_SK);
        let (current_time) = get_block_timestamp();
        if (len == 0) {
            // [Effect] Update storage
            Array.add(key=TIME_SK, value=first_time);
            Array.add(key=TIME_SK, value=time);
            Array.add(key=PRICE_SK, value=price);
            Array.add(key=PRICE_SK, value=price);

            // [Event] Emit event
            PriceUpdate.emit(time=time, price=price);

            return ();
        }

        // [Check] Time is later than the last stored time
        let (last_time) = Array.read(key=TIME_SK, index=len - 1);
        with_attr error_message("CarbonableFarming: time is later than the last stored time") {
            assert_le(last_time + 1, time);
        }

        // [Check] Absorption is captured between these times
        let (initial_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=last_time
        );
        let (final_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=time
        );
        with_attr error_message("CarbonableFarming: the period must capture absorption") {
            assert_le(initial_absorption + 1, final_absorption);
        }

        // [Effect] Update storage
        Array.add(key=TIME_SK, value=time);
        Array.add(key=PRICE_SK, value=price);

        // [Event] Emit event
        PriceUpdate.emit(time=time, price=price);

        return ();
    }

    func update_last_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        time: felt, price: felt
    ) {
        alloc_locals;

        // [Check] At least 2 prices stored
        let (len) = Array.read_len(key=TIME_SK);
        with_attr error_message("CarbonableFarming: at least 2 prices must be stored") {
            assert_le(2, len);
        }

        // [Check] Current time is sooner than the last 2 stored times and specified time is later than the last stored time
        let (current_time) = get_block_timestamp();
        let (before_last_time) = Array.read(key=TIME_SK, index=len - 2);
        with_attr error_message("CarbonableFarming: current time is too high") {
            assert_le(current_time, before_last_time + 1);
        }

        // [Check] Specified time is later than the before last stored time
        with_attr error_message("CarbonableFarming: current time is too high") {
            assert_le(before_last_time + 1, time);
        }

        // [Check] Absorption is captured between the 2 new last times
        let (last_time) = Array.read(key=TIME_SK, index=len - 1);
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (initial_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=last_time
        );
        let (final_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=time
        );
        with_attr error_message("CarbonableFarming: the two last times must wrap absorption") {
            assert_not_zero(final_absorption - initial_absorption);
        }

        // [Effect] Update storage
        Array.replace(key=TIME_SK, index=len - 1, value=time);
        Array.replace(key=PRICE_SK, index=len - 1, value=price);

        // [Event] Emit event
        PriceUpdate.emit(time=time, price=price);

        return ();
    }

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarming: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        with_attr error_message("CarbonableFarming: value is not a valid Uint256") {
            uint256_check(value);
        }

        // [Check] Deposited value is not null
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(value, zero);
        with_attr error_message("CarbonableFarming: value is null") {
            assert is_zero = FALSE;
        }

        // [Check] Token id is owned by caller
        Assert.caller_is_owner(token_id=token_id);

        // [Effect] If owned token id exists then deposit to (create a new token)
        let (to_token_id) = _get_token_id();
        let (is_zero) = uint256_eq(to_token_id, zero);
        if (is_zero == TRUE) {
            let (contract_address) = get_contract_address();
            let (success) = _deposit(
                from_token_id=token_id, to_token_id=zero, to=contract_address, value=value
            );
            return (success=success);
        }

        // [Effect] Otherwise deposit to the existing contract token id
        let (success) = _deposit(
            from_token_id=token_id, to_token_id=to_token_id, to=0, value=value
        );
        return (success=success);
    }

    func withdraw_to{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarming: value is not a valid Uint256") {
            uint256_check(value);
        }

        // [Effect] Withdraw to caller address
        let zero = Uint256(low=0, high=0);
        let (caller) = get_caller_address();
        let (success) = _withdraw(to_token_id=zero, to=caller, value=value);
        return (success=success);
    }

    func withdraw_to_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarming: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        with_attr error_message("CarbonableFarming: value is not a valid Uint256") {
            uint256_check(value);
        }

        // [Check] Token id is owned by caller
        Assert.caller_is_owner(token_id=token_id);

        // [Effect] Withdraw to token id
        let (success) = _withdraw(to_token_id=token_id, to=0, value=value);
        return (success=success);
    }

    //
    // Internals
    //

    func _get_token_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        token_id: Uint256
    ) {
        alloc_locals;

        // [Check] Contract token balance is null then return zero
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = CarbonableFarming_carbonable_project_address_.read();
        let (balance) = IERC721.balanceOf(
            contract_address=carbonable_project_address, owner=contract_address
        );
        let zero = Uint256(low=0, high=0);
        let (equal) = uint256_eq(balance, zero);
        if (equal == TRUE) {
            return (token_id=zero);
        }

        // [Check] Otherwise return token id
        let (token_id) = IERC721Enumerable.tokenOfOwnerByIndex(
            contract_address=carbonable_project_address, owner=contract_address, index=zero
        );

        return (token_id=token_id);
    }

    func _deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_token_id: Uint256, to_token_id: Uint256, to: felt, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reentrancy guard
        ReentrancyGuard.start();

        // [Effect] Store absorption
        let (caller) = get_caller_address();
        let (absorption) = CarbonableFarming.absorption_of(address=caller);
        CarbonableFarming_absorption_.write(caller, absorption);

        // [Effect] Store total absorption
        let (total_absorption) = CarbonableFarming.total_absorption();
        CarbonableFarming_total_absorption_.write(total_absorption);

        // [Effect] Store sale
        let (sale) = CarbonableFarming.sale_of(address=caller);
        CarbonableFarming_sale_.write(caller, sale);

        // [Effect] Store total sale
        let (total_sale) = CarbonableFarming.total_sale();
        CarbonableFarming_total_sale_.write(total_sale);

        // [Effect] Register the new caller value and the current timestamp
        let (current_time) = get_block_timestamp();
        let (previous_value) = CarbonableFarming_registered_value_.read(caller);
        let (new_value) = SafeUint256.add(previous_value, value);
        CarbonableFarming_registered_time_.write(caller, current_time);
        CarbonableFarming_registered_value_.write(caller, new_value);

        // [Effect] Register the new total value and current timestamp
        let (previous_value) = CarbonableFarming_total_registered_value_.read();
        let (new_value) = SafeUint256.add(previous_value, value);
        CarbonableFarming_total_registered_value_.write(new_value);
        CarbonableFarming_total_registered_time_.write(current_time);

        // [Interaction] Transfer value from from_token_id to to_token_id
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        IERC3525.transferValueFrom(
            contract_address=contract_address,
            fromTokenId=from_token_id,
            toTokenId=to_token_id,
            to=to,
            value=value,
        );

        // [Event] Emit event
        Deposit.emit(address=caller, value=value, time=current_time);

        // [Security] End reentrancy guard
        ReentrancyGuard.end();
        return (success=TRUE);
    }

    func _withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to_token_id: Uint256, to: felt, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reentrancy guard
        ReentrancyGuard.start();

        // [Check] value is less than or equal to the registered value
        let (caller) = get_caller_address();
        let (registered_value) = CarbonableFarming_registered_value_.read(caller);
        with_attr error_message("CarbonableFarming: value is higher than the withdrawable value") {
            assert_uint256_le(value, registered_value);
        }

        // [Effect] Store absorption
        let (absorption) = CarbonableFarming.absorption_of(address=caller);
        CarbonableFarming_absorption_.write(caller, absorption);

        // [Effect] Store total absorption
        let (total_absorption) = CarbonableFarming.total_absorption();
        CarbonableFarming_total_absorption_.write(total_absorption);

        // [Effect] Store sale
        let (sale) = CarbonableFarming.sale_of(address=caller);
        CarbonableFarming_sale_.write(caller, sale);

        // [Effect] Store total sale
        let (total_sale) = CarbonableFarming.total_sale();
        CarbonableFarming_total_sale_.write(total_sale);

        // [Effect] Register the new caller value and the current timestamp
        let (current_time) = get_block_timestamp();
        let (previous_value) = CarbonableFarming_registered_value_.read(caller);
        let (new_value) = SafeUint256.sub_le(previous_value, value);
        CarbonableFarming_registered_time_.write(caller, current_time);
        CarbonableFarming_registered_value_.write(caller, new_value);

        // [Effect] Register the new total value and current timestamp
        let (previous_value) = CarbonableFarming_total_registered_value_.read();
        let (new_value) = SafeUint256.sub_le(previous_value, value);
        CarbonableFarming_total_registered_value_.write(new_value);
        CarbonableFarming_total_registered_time_.write(current_time);

        // [Interaction] Transfer value from contract to caller
        let (from_token_id) = _get_token_id();
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        IERC3525.transferValueFrom(
            contract_address=contract_address,
            fromTokenId=from_token_id,
            toTokenId=to_token_id,
            to=to,
            value=value,
        );

        // [Event] Emit event
        Withdraw.emit(address=caller, value=value, time=current_time);

        // [Security] End reentrancy guard
        ReentrancyGuard.end();
        return (success=TRUE);
    }

    func _compute_total_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (absorption: felt) {
        alloc_locals;

        // [Compute] Total deposited value and registered time
        let (value) = CarbonableFarming_total_registered_value_.read();
        let (time) = CarbonableFarming_total_registered_time_.read();

        // [Compute] Total computed absorption
        return _compute_absorption(value=value, time=time);
    }

    func _compute_user_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (absorption: felt) {
        alloc_locals;

        // [Compute] User deposited value and registered time
        let (value) = CarbonableFarming_registered_value_.read(address);
        let (time) = CarbonableFarming_registered_time_.read(address);

        // [Compute] User computed absorption
        return _compute_absorption(value=value, time=time);
    }

    func _compute_absorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: Uint256, time: felt
    ) -> (absorption: felt) {
        alloc_locals;

        // [Check] Deposited value not null
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(value, zero);
        if (is_zero == TRUE) {
            return (absorption=0);
        }

        // [Compute] Project value is not zero
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (project_value) = ICarbonableProject.getProjectValue(
            contract_address=contract_address, slot=slot
        );
        let (is_zero) = uint256_eq(project_value, zero);
        if (is_zero == TRUE) {
            return (absorption=0);
        }

        // [Compute] Interpolated absorptions
        let (initial_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=time
        );
        let (final_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address, slot=slot
        );

        // [Check] Absorption overflow
        with_attr error_message("CarbonableFarming: Error while computing absorption") {
            assert_nn_le(initial_absorption, final_absorption);
        }

        // [Compute] Total absorption, if null then return 0
        let total_absorption = final_absorption - initial_absorption;
        if (total_absorption == 0) {
            return (absorption=0);
        }
        let (total_absorption_u256) = _felt_to_uint(total_absorption);

        // [Check] Value is lower than or equal to project value
        with_attr error_message("CarbonableFarming: Unexpected underflow") {
            assert_uint256_le(value, project_value);
        }

        // [Compute] Otherwise returns the absorption corresponding to the ratio
        // Keep quotient_low only since value <= project_value
        let (quotient_low, quotient_high, _) = uint256_mul_div_mod(value, total_absorption_u256, project_value);

        // [Check] No underflow
        let zero = Uint256(low=0, high=0);
        with_attr error_message("CarbonableFarming: Unexpected underflow") {
            assert_uint256_eq(quotient_high, zero);
        }

        let (absorption) = _uint_to_felt(quotient_low);
        return (absorption=absorption);
    }

    func _compute_total_sale{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        sale: felt
    ) {
        alloc_locals;

        // [Compute] Total deposited value and registered time
        let (value) = CarbonableFarming_total_registered_value_.read();
        let (time) = CarbonableFarming_total_registered_time_.read();

        // [Compute] Total computed sale
        return _compute_sale(value=value, time=time);
    }

    func _compute_user_sale{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (sale: felt) {
        alloc_locals;

        // [Compute] User deposited value and registered time
        let (value) = CarbonableFarming_registered_value_.read(address);
        let (time) = CarbonableFarming_registered_time_.read(address);

        // [Compute] User computed sale
        return _compute_sale(value=value, time=time);
    }

    func _compute_sale{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: Uint256, time: felt
    ) -> (sale: felt) {
        alloc_locals;

        // [Check] Deposited value not null
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(value, zero);
        if (is_zero == TRUE) {
            return (sale=0);
        }

        // [Compute] Project value is not zero
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (project_value) = ICarbonableProject.getProjectValue(
            contract_address=contract_address, slot=slot
        );
        let (is_zero) = uint256_eq(project_value, zero);
        if (is_zero == TRUE) {
            return (sale=0);
        }

        // [Compute] Interpolated sales
        let (current_time) = get_block_timestamp();
        let (len, times, _, _, cumsales) = CarbonableFarming._compute_cumsales();

        // [Check] Times and prices are set
        if (len == 0) {
            return (sale=0);
        }

        // [Compute] Total sale
        let initial_cumsale = Math.interpolate(
            x=time, len=len, xs=times, ys=cumsales, interpolation=LINEAR, extrapolation=CONSTANT
        );
        let final_cumsale = Math.interpolate(
            x=current_time,
            len=len,
            xs=times,
            ys=cumsales,
            interpolation=LINEAR,
            extrapolation=CONSTANT,
        );

        // [Check] Sale overflow
        with_attr error_message("CarbonableFarming: Error while computing sale") {
            assert_nn_le(initial_cumsale, final_cumsale);
        }

        // [Compute] Total sale, if null then return 0
        let total_sale = final_cumsale - initial_cumsale;
        if (total_sale == 0) {
            return (sale=0);
        }
        let (total_sale_u256) = _felt_to_uint(total_sale);

        // [Compute] Otherwise returns the sale corresponding to the ratio
        // Keep quotient_low only since value <= project_value
        let (quotient_low, _, _) = uint256_mul_div_mod(value, total_sale_u256, project_value);
        let (sale) = _uint_to_felt(quotient_low);
        return (sale=sale);
    }

    func _compute_cumsales{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        len: felt, times: felt*, prices: felt*, updated_prices: felt*, cumsales: felt*
    ) {
        alloc_locals;

        let (local empty: felt*) = alloc();

        // [Check] Times are set
        let (len, times) = Array.load(key=TIME_SK);
        if (len == 0) {
            return (len=0, times=empty, prices=empty, updated_prices=empty, cumsales=empty);
        }

        // [Check] Prices are set
        let (len, prices) = Array.load(key=PRICE_SK);
        if (len == 0) {
            return (len=0, times=empty, prices=empty, updated_prices=empty, cumsales=empty);
        }

        // [Compute] Project information
        let (local updated_prices: felt*) = alloc();
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (slot) = CarbonableFarming_carbonable_project_slot_.read();
        let (len, updated_prices, sales) = _compute_sales_iter(
            index=0,
            absorption=0,
            negative_delta=0,
            positive_delta=0,
            len=len,
            times=times,
            prices=prices,
            contract_address=contract_address,
            slot=slot,
            sales=empty,
            updated_prices=updated_prices,
        );
        let (len, cumsales) = Math.cumsum(len=len, xs=sales);
        return (
            len=len, times=times, prices=prices, updated_prices=updated_prices, cumsales=cumsales
        );
    }

    func _compute_sales_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt,
        absorption: felt,
        negative_delta: felt,
        positive_delta: felt,
        len: felt,
        times: felt*,
        prices: felt*,
        contract_address: felt,
        slot: Uint256,
        sales: felt*,
        updated_prices: felt*,
    ) -> (len: felt, updated_prices: felt*, sales: felt*) {
        alloc_locals;

        // [Check] End criteria
        if (index == len) {
            return (len=len, updated_prices=updated_prices, sales=sales);
        }

        // [Check] First iteration (special case)
        let time = times[index];
        let price = prices[index];
        if (index == 0) {
            // [Compute] Interpolated absorptions
            let (first_time) = ICarbonableProject.getStartTime(
                contract_address=contract_address, slot=slot
            );
            let (initial_absorption) = ICarbonableProject.getAbsorption(
                contract_address=contract_address, slot=slot, time=first_time
            );
            let (final_absorption) = ICarbonableProject.getAbsorption(
                contract_address=contract_address, slot=slot, time=time
            );
            let absorption = final_absorption - initial_absorption;
            assert sales[index] = absorption * price;
            assert updated_prices[index] = price;
            return _compute_sales_iter(
                index=index + 1,
                absorption=absorption,
                negative_delta=negative_delta,
                positive_delta=positive_delta,
                len=len,
                times=times,
                prices=prices,
                contract_address=contract_address,
                slot=slot,
                sales=sales,
                updated_prices=updated_prices,
            );
        }

        // [Compute] Current time and price
        let previous_time = times[index - 1];

        // [Compute] Interpolated absorptions
        let (initial_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=previous_time
        );
        let (final_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=time
        );
        let new_absorption = final_absorption - initial_absorption;

        // [Check] Absorption cannot wrap a null absorption
        with_attr error_message("CarbonableFarming: Prices cannot wrap a null absorption") {
            assert_not_zero(new_absorption);
        }

        // [Compute] Delta to compensate from the previous sale
        let real_sale = absorption * price;
        let previous_sale = sales[index - 1];
        let is_lower = is_le(real_sale, previous_sale);
        let negative_delta = negative_delta + (previous_sale - real_sale) * is_lower;
        let positive_delta = positive_delta + (real_sale - previous_sale) * (1 - is_lower);

        // [Compute] Updated price
        let (negative_update, _) = unsigned_div_rem(negative_delta, new_absorption);
        let (positive_update, _) = unsigned_div_rem(positive_delta, new_absorption);

        // [Check] Overflow, if too much to compensate then price drop to zero
        let is_lower = is_le(negative_update, price + positive_update);
        let updated_price = (price + positive_update - negative_update) * is_lower;
        assert sales[index] = new_absorption * updated_price;
        assert updated_prices[index] = updated_price;
        return _compute_sales_iter(
            index=index + 1,
            absorption=new_absorption,
            negative_delta=negative_delta,
            positive_delta=positive_delta,
            len=len,
            times=times,
            prices=prices,
            contract_address=contract_address,
            slot=slot,
            sales=sales,
            updated_prices=updated_prices,
        );
    }
}

// Assert helpers
namespace Assert {
    func caller_is_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) {
        let (caller) = get_caller_address();
        let (contract_address) = CarbonableFarming_carbonable_project_address_.read();
        let (owner) = IERC721.ownerOf(contract_address=contract_address, tokenId=token_id);
        with_attr error_message("CarbonableFarming: caller is not the owner of the token") {
            assert caller = owner;
        }
        return ();
    }
}
