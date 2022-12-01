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
from interfaces.starkvest import IStarkVest

// Local dependencies
from src.interfaces.project import ICarbonableProject

//
// Events
//

@event
func Offset(address: felt, quantity: Uint256, time: felt) {
}

@event
func Snapshot(time: felt) {
}

//
// Storage variables - Common
//

@storage_var
func carbonable_project_address_() -> (address: felt) {
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
// Storage variables - Offset
//

@storage_var
func absorption_() -> (absorption: Uint256) {
}

@storage_var
func total_offsetable_(address: felt) -> (balance: Uint256) {
}

@storage_var
func total_offseted_(address: felt) -> (balance: Uint256) {
}

@storage_var
func snapshoted_() -> (snapshoted: felt) {
}

namespace CarbonableOffseter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt
    ) {
        carbonable_project_address_.write(carbonable_project_address);
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
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        // [Check] Owned token id
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = carbonable_project_address_.read();
        // [Check] Throws error if unknown token id
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token_id has not been registred") {
            assert owner = contract_address;
        }

        let (address) = registration_.read(token_id);
        return (address=address,);
    }

    func total_offsetable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (total_offsetable: Uint256) {
        let (total_offsetable) = total_offsetable_.read(address);
        return (total_offsetable=total_offsetable,);
    }

    func total_offseted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (total_offseted: Uint256) {
        let (total_offseted) = total_offseted_.read(address);
        return (total_offseted=total_offseted,);
    }

    //
    // Externals
    //

    func start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt, absorption: felt
    ) -> (success: felt) {
        // [Check] Duration inputs validity
        with_attr error_message("CarbonableOffseter: Invalid period duration") {
            assert_nn(period_duration);
        }
        with_attr error_message("CarbonableOffseter: Invalid locked duration") {
            assert_le(unlocked_duration, period_duration);
        }

        // [Effect] Store absorption information
        absorption_.write(Uint256(low=absorption, high=0));

        // [Effect] Store period information
        let (current_time) = get_block_timestamp();
        start_.write(current_time);
        period_duration_.write(period_duration);
        unlocked_duration_.write(unlocked_duration);

        // [Effect] Reset snapshoted status
        snapshoted_.write(0);

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
        with_attr error_message("CarbonableOffseter: No current period") {
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
        with_attr error_message("CarbonableOffseter: deposits are currently locked") {
            assert status = FALSE;
        }

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
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
        with_attr error_message("CarbonableOffseter: transfer failed") {
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
        with_attr error_message("CarbonableOffseter: withdrawals are currently locked") {
            assert status = FALSE;
        }

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
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
        with_attr error_message("CarbonableOffseter: transfer failed") {
            assert owner = caller;
        }

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success=TRUE,);
    }

    func offset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        alloc_locals;

        // [Check] Total offsetable not null
        let (caller) = get_caller_address();
        let (total_offsetable) = total_offsetable_.read(caller);
        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(total_offsetable, zero);
        with_attr error_message("CarbonableOffseter: offsetable balance must be positive") {
            assert is_zero = FALSE;
        }

        // [Effect] Transfer value from offsetable to offseted
        let (total_offseted) = total_offseted_.read(caller);
        let (new_total_offseted) = SafeUint256.add(total_offseted, total_offsetable);
        total_offsetable_.write(caller, zero);
        total_offseted_.write(caller, new_total_offseted);

        let (current_time) = get_block_timestamp();
        Offset.emit(address=caller, quantity=total_offsetable, time=current_time);
        return (success=TRUE,);
    }

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        // [Check] Locked period
        let (status) = is_locked();
        with_attr error_message("CarbonableOffseter: snapshot must be executed in locked period") {
            assert status = TRUE;
        }

        // [Check] Snapshot not yet executed for the current period
        let (snapshoted) = snapshoted_.read();
        with_attr error_message(
                "CarbonableOffseter: snapshot already executed for the current period") {
            assert snapshoted = FALSE;
        }

        // [Effect] Update snapshot status
        snapshoted_.write(TRUE);

        // [Interaction] Run snapshot
        _snapshot();

        let (current_time) = get_block_timestamp();
        Snapshot.emit(time=current_time);

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

    func _snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;

        let (contract_address) = carbonable_project_address_.read();
        let (total_supply) = IERC721Enumerable.totalSupply(contract_address=contract_address);

        let zero = Uint256(low=0, high=0);
        let (is_zero) = uint256_eq(total_supply, zero);
        if (is_zero == TRUE) {
            return ();
        }

        let one = Uint256(low=1, high=0);
        let (index) = SafeUint256.sub_le(total_supply, one);
        return _snapshot_iter(
            contract_address=contract_address, index=index, total_supply=total_supply
        );
    }

    func _snapshot_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt, index: Uint256, total_supply: Uint256
    ) {
        alloc_locals;

        // Get registred address of the current token index
        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index
        );
        let (address) = registration_.read(token_id);

        // If registred then update the total offsetable
        let one = Uint256(low=1, high=0);
        if (address != 0) {
            let (absorption) = absorption_.read();
            let (quantity, _, _) = uint256_mul_div_mod(absorption, one, total_supply);
            let (balance) = total_offsetable_.read(address);
            let (new_balance) = SafeUint256.add(balance, quantity);
            total_offsetable_.write(address, new_balance);

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
        return _snapshot_iter(
            contract_address=contract_address, index=next, total_supply=total_supply
        );
    }
}
