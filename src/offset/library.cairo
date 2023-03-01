// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le_felt, is_not_zero
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_eq,
    uint256_mul_div_mod,
    uint256_le,
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
from erc3525.IERC3525Full import IERC3525Full

// Local dependencies
from src.interfaces.project import ICarbonableProject
from src.utils.type.library import _felt_to_uint, _uint_to_felt

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
func Claim(address: felt, absorption: felt, time: felt) {
}

//
// Storages
//

@storage_var
func CarbonableOffseter_carbonable_project_address_() -> (address: felt) {
}

@storage_var
func CarbonableOffseter_carbonable_project_slot_() -> (slot: Uint256) {
}

@storage_var
func CarbonableOffseter_min_claimable_() -> (quantity: felt) {
}

@storage_var
func CarbonableOffseter_claimable_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableOffseter_claimed_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableOffseter_registered_value_(address: felt) -> (value: Uint256) {
}

@storage_var
func CarbonableOffseter_registered_time_(address: felt) -> (time: felt) {
}

@storage_var
func CarbonableOffseter_users_len_() -> (length: felt) {
}

@storage_var
func CarbonableOffseter_users_(index: felt) -> (address: felt) {
}

@storage_var
func CarbonableOffseter_users_index_(address: felt) -> (index: felt) {
}

namespace CarbonableOffseter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt, carbonable_project_slot: Uint256
    ) {
        CarbonableOffseter_carbonable_project_address_.write(carbonable_project_address);
        CarbonableOffseter_carbonable_project_slot_.write(carbonable_project_slot);
        return ();
    }

    //
    // Getters
    //

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        return (carbonable_project_address=carbonable_project_address);
    }

    func carbonable_project_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (carbonable_project_slot: Uint256) {
        let (carbonable_project_slot) = CarbonableOffseter_carbonable_project_slot_.read();
        return (carbonable_project_slot=carbonable_project_slot);
    }

    func min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        min_claimable: felt
    ) {
        let (min_claimable) = CarbonableOffseter_min_claimable_.read();
        return (min_claimable=min_claimable);
    }

    func total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        value: Uint256
    ) {
        alloc_locals;

        // [Check] Contract token id is not null
        let (token_id) = _get_token_id();
        let zero = Uint256(low=0, high=0);
        let (equal) = uint256_eq(token_id, zero);
        if (equal == TRUE) {
            return (value=token_id);
        }

        // [Effect] Read corresponding value
        let (contract_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (value) = IERC3525.valueOf(contract_address=contract_address, tokenId=token_id);

        return (value=value);
    }

    func total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_claimed: felt
    ) {
        let (users_len) = CarbonableOffseter_users_len_.read();

        if (users_len == 0) {
            return (total_claimed=0);
        }

        let (total_claimed) = _total_claimed_iter(index=users_len - 1);
        return (total_claimed=total_claimed);
    }

    func total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_claimable: felt
    ) {
        let (users_len) = CarbonableOffseter_users_len_.read();

        if (users_len == 0) {
            return (total_claimable=0);
        }

        let (total_claimable) = _total_claimable_iter(index=users_len - 1);
        return (total_claimable=total_claimable);
    }

    func deposited_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (value: Uint256) {
        let (value) = CarbonableOffseter_registered_value_.read(address);
        return (value=value);
    }

    func claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        alloc_locals;

        let (computed_claimable) = _claimable(address=address);
        let (stored_claimable) = CarbonableOffseter_claimable_.read(address);
        let (stored_claimed) = CarbonableOffseter_claimed_.read(address);
        let claimable = stored_claimable + computed_claimable - stored_claimed;

        // [Check] Overflow
        let (contract_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (slot) = CarbonableOffseter_carbonable_project_slot_.read();
        let (max_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address, slot=slot
        );
        let not_overflow = is_le_felt(claimable, max_absorption);
        with_attr error_message("CarbonableOffseter: overflow while computing claimable") {
            assert not_overflow = TRUE;
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
        let not_zero = is_not_zero(min_claimable);
        with_attr error_message("CarbonableOffseter: min claimable balance must be not null") {
            assert not_zero = TRUE;
        }
        CarbonableOffseter_min_claimable_.write(min_claimable);
        return ();
    }

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) -> (
        success: felt
    ) {
        // [Check] Quanity is not null
        CarbonableOffseter_assert.claimable_not_negligible(quantity);

        // [Check] Quantity is lower or equal to the total claimable
        let (caller) = get_caller_address();
        let (claimable) = claimable_of(caller);
        let is_lower = is_le_felt(quantity, claimable);
        with_attr error_message(
                "CarbonableOffseter: quantity to claim must be lower than the total claimable") {
            assert is_lower = TRUE;
        }

        // [Effect] Claim
        _claim(quantity=quantity);
        return (success=TRUE);
    }

    func claim_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        alloc_locals;

        // [Check] Total offsetable is not null
        let (caller) = get_caller_address();
        let (claimable) = claimable_of(caller);
        CarbonableOffseter_assert.claimable_not_negligible(claimable);

        // [Effect] Claim
        _claim(quantity=claimable);
        return (success=TRUE);
    }

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        with_attr error_message("CarbonableOffseter: value is not a valid Uint256") {
            uint256_check(value);
        }

        // [Check] Token belongs to the caller
        let (caller) = get_caller_address();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token does not belong to the caller") {
            assert caller = owner;
        }

        // [Check] Deposited value is not null
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(value, zero);
        with_attr error_message("CarbonableOffseter: value is null") {
            assert is_zero = FALSE;
        }

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
        with_attr error_message("CarbonableOffseter: value is not a valid Uint256") {
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
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        with_attr error_message("CarbonableOffseter: value is not a valid Uint256") {
            uint256_check(value);
        }

        // [Check] Token belongs to the caller
        let (caller) = get_caller_address();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token does not belong to the caller") {
            assert caller = owner;
        }

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
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
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

    func _total_claimed_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt
    ) -> (total_claimed: felt) {
        alloc_locals;

        let (address) = CarbonableOffseter_users_.read(index);
        let (claimed) = CarbonableOffseter_claimed_.read(address);

        if (index == 0) {
            return (total_claimed=claimed);
        }

        let (add) = _total_claimed_iter(index=index - 1);
        return (total_claimed=claimed + add);
    }

    func _total_claimable_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt
    ) -> (total_claimable: felt) {
        alloc_locals;

        let (address) = CarbonableOffseter_users_.read(index);
        let (claimable) = claimable_of(address);

        if (index == 0) {
            return (total_claimable=claimable);
        }

        let (add) = _total_claimable_iter(index=index - 1);
        return (total_claimable=claimable + add);
    }

    func _claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        alloc_locals;

        // [Compute] Get user deposited value
        let (user_value) = CarbonableOffseter_registered_value_.read(address);

        // [Compute] Get project total value
        let (contract_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (slot) = CarbonableOffseter_carbonable_project_slot_.read();
        let (total_value) = IERC3525Full.totalValue(contract_address=contract_address, slot=slot);

        // [Check] total value is not zero
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(total_value, zero);
        if (is_zero == TRUE) {
            return (claimable=0);
        }

        // [Compute] Computed absorption
        let (time) = CarbonableOffseter_registered_time_.read(address);
        let (initial_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, slot=slot, time=time
        );
        let (final_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address, slot=slot
        );

        // [Check] Absorption overflow
        let right_order = is_le_felt(initial_absorption, final_absorption);
        with_attr error_message("CarbonableOffseter: Error while computing claimable") {
            assert right_order = TRUE;
        }

        // [Compute] Total absorption, if then return 0
        let total_absorption_felt = final_absorption - initial_absorption;
        if (total_absorption_felt == 0) {
            return (claimable=0);
        }
        let (total_absorption) = _felt_to_uint(total_absorption_felt);

        // [Compute] Otherwise returns the absorption corresponding to the ratio
        // Keep quotient_low only since user_value <= total_value
        let (quotient_low, _, _) = uint256_mul_div_mod(user_value, total_absorption, total_value);
        let (claimable) = _uint_to_felt(quotient_low);
        return (claimable=claimable);
    }

    func _claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) -> () {
        // [Effect] Add claimed value
        let (caller) = get_caller_address();
        let (stored_claimed) = CarbonableOffseter_claimed_.read(caller);
        let claimed = stored_claimed + quantity;
        CarbonableOffseter_claimed_.write(caller, claimed);

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        Claim.emit(address=caller, absorption=quantity, time=current_time);
        return ();
    }

    func _deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        from_token_id: Uint256, to_token_id: Uint256, to: felt, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Interaction] Transfer value from from_token_id to to_token_id
        let (old_deposited) = total_deposited();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (contract_address) = get_contract_address();
        IERC3525.transferValueFrom(
            contract_address=carbonable_project_address,
            fromTokenId=from_token_id,
            toTokenId=to_token_id,
            to=to,
            value=value,
        );

        // [Check] Transfer successful
        let (new_deposited) = total_deposited();
        let (expected_deposited) = SafeUint256.add(old_deposited, value);
        let (is_equal) = uint256_eq(new_deposited, expected_deposited);
        with_attr error_message("CarbonableOffseter: transfer failed") {
            assert is_equal = TRUE;
        }

        // [Effect] Store cumulated claimable
        let (caller) = get_caller_address();
        let (computed_claimable) = _claimable(address=caller);
        let (stored_claimable) = CarbonableOffseter_claimable_.read(caller);
        CarbonableOffseter_claimable_.write(caller, stored_claimable + computed_claimable);

        // [Effect] Register the caller with the new value and the current timestamp
        let (current_time) = get_block_timestamp();
        let (previous_value) = CarbonableOffseter_registered_value_.read(caller);
        let (new_value) = SafeUint256.add(previous_value, value);
        CarbonableOffseter_registered_time_.write(caller, current_time);
        CarbonableOffseter_registered_value_.write(caller, new_value);

        // [Effect] Emit event
        Deposit.emit(address=caller, value=value, time=current_time);

        // [Effect] Register the caller if first deposit
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(previous_value, zero);
        if (is_zero == TRUE) {
            let (index) = CarbonableOffseter_users_len_.read();
            // Create new user
            CarbonableOffseter_users_len_.write(index + 1);
            CarbonableOffseter_users_.write(index, caller);
            CarbonableOffseter_users_index_.write(caller, index);

            // [Security] End reetrancy guard
            ReentrancyGuard.end();
            return (success=TRUE);
        }

        // [Security] End reetrancy guard
        ReentrancyGuard.end();
        return (success=TRUE);
    }

    func _withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to_token_id: Uint256, to: felt, value: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] value is less than or equal to the registered value
        let (caller) = get_caller_address();
        let (registered_value) = CarbonableOffseter_registered_value_.read(caller);
        let (is_lower) = uint256_le(value, registered_value);
        with_attr error_message("CarbonableOffseter: value is higher than withdrawable value") {
            assert is_lower = TRUE;
        }

        // [Effect] Store cumulated claimable
        let (computed_claimable) = _claimable(address=caller);
        let (stored_claimable) = CarbonableOffseter_claimable_.read(caller);
        CarbonableOffseter_claimable_.write(caller, stored_claimable + computed_claimable);

        // [Effect] Register the caller with the new value and the current timestamp
        let (current_time) = get_block_timestamp();
        let (previous_value) = CarbonableOffseter_registered_value_.read(caller);
        let (new_value) = SafeUint256.sub_le(previous_value, value);
        CarbonableOffseter_registered_time_.write(caller, current_time);
        CarbonableOffseter_registered_value_.write(caller, new_value);

        // [Interaction] Transfer value from contract to caller
        let (old_deposited) = total_deposited();
        let (from_token_id) = _get_token_id();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        IERC3525.transferValueFrom(
            contract_address=carbonable_project_address,
            fromTokenId=from_token_id,
            toTokenId=to_token_id,
            to=to,
            value=value,
        );

        // [Check] Transfer successful
        let (new_deposited) = total_deposited();
        let (expected_deposited) = SafeUint256.sub_le(old_deposited, value);
        let (is_equal) = uint256_eq(new_deposited, expected_deposited);
        with_attr error_message("CarbonableOffseter: transfer failed") {
            assert is_equal = TRUE;
        }

        // [Effect] Emit event
        Withdraw.emit(address=caller, value=value, time=current_time);

        // [Effect] Remove the caller if registered value reached zero
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(new_value, zero);
        if (is_zero == TRUE) {
            let (length) = CarbonableOffseter_users_len_.read();
            let last_index = length - 1;
            let (last_user) = CarbonableOffseter_users_.read(last_index);
            let (user_index) = CarbonableOffseter_users_index_.read(caller);

            // Overwrite user with last user
            CarbonableOffseter_users_len_.write(last_index);
            CarbonableOffseter_users_.write(user_index, last_user);
            CarbonableOffseter_users_index_.write(last_user, user_index);
            // Remove last user index
            CarbonableOffseter_users_.write(last_index, 0);
            // Remove user index
            CarbonableOffseter_users_index_.write(user_index, 0);

            // [Security] End reetrancy guard
            ReentrancyGuard.end();
            return (success=TRUE);
        }

        // [Security] End reetrancy guard
        ReentrancyGuard.end();
        return (success=TRUE);
    }
}

// Assert helpers
namespace CarbonableOffseter_assert {
    func claimable_not_negligible{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        claimable: felt
    ) {
        let (minimum) = CarbonableOffseter.min_claimable();
        let is_lower = is_le_felt(minimum, claimable);
        with_attr error_message("CarbonableOffseter: claimable balance must be not negligible") {
            assert is_lower = TRUE;
        }
        return ();
    }
}
