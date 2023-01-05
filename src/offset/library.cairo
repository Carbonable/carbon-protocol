// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import split_felt, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_check
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard

// Local dependencies
from src.interfaces.project import ICarbonableProject
from src.utils.type.library import _uint_to_felt

//
// Events
//

@event
func Deposit(address: felt, token_id: Uint256, time: felt) {
}

@event
func Withdraw(address: felt, token_id: Uint256, time: felt) {
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
func CarbonableOffseter_min_claimable_() -> (quantity: felt) {
}

@storage_var
func CarbonableOffseter_registered_owner_(tokenId: Uint256) -> (address: felt) {
}

@storage_var
func CarbonableOffseter_registered_time_(tokenId: Uint256) -> (time: felt) {
}

@storage_var
func CarbonableOffseter_claimable_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableOffseter_claimed_(address: felt) -> (absorption: felt) {
}

@storage_var
func CarbonableOffseter_users_len_() -> (length: felt) {
}

@storage_var
func CarbonableOffseter_users_(index: felt) -> (address: felt) {
}

@storage_var
func CarbonableOffseter_known_user_(address: felt) -> (bool: felt) {
}

namespace CarbonableOffseter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt
    ) {
        CarbonableOffseter_carbonable_project_address_.write(carbonable_project_address);
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

    func min_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        min_claimable: felt
    ) {
        let (min_claimable) = CarbonableOffseter_min_claimable_.read();
        return (min_claimable=min_claimable);
    }

    func total_deposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        balance: Uint256
    ) {
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();

        let (balance) = IERC721.balanceOf(
            contract_address=carbonable_project_address, owner=contract_address
        );

        return (balance=balance);
    }

    func total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_claimed: felt
    ) {
        let (users_len, users) = _read_users();

        if (users_len == 0) {
            return (total_claimed=0);
        }

        let (total_claimed) = _total_claimed_iter(index=users_len - 1, users=users);
        return (total_claimed=total_claimed);
    }

    func total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_claimable: felt
    ) {
        let (users_len, users) = _read_users();

        if (users_len == 0) {
            return (total_claimable=0);
        }

        let (total_claimable) = _total_claimable_iter(index=users_len - 1, users=users);
        return (total_claimable=total_claimable);
    }

    func claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        alloc_locals;

        let (computed_claimable) = _claimable(user=address);
        let (stored_claimable) = CarbonableOffseter_claimable_.read(address);
        let (stored_claimed) = CarbonableOffseter_claimed_.read(address);
        let claimable = stored_claimable + computed_claimable - stored_claimed;

        // [Check] Overflow
        let (contract_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (max_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address
        );
        let not_overflow = is_le(claimable, max_absorption);
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

    func registered_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (address: felt) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        // [Check] Owned token id
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        // [Check] Throws error if unknown token id
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token_id has not been registered") {
            assert owner = contract_address;
        }

        let (address) = CarbonableOffseter_registered_owner_.read(token_id);
        return (address=address);
    }

    func registered_time_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (time: felt) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        // [Check] Owned token id
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        // [Check] Throws error if unknown token id
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token_id has not been registered") {
            assert owner = contract_address;
        }

        let (time) = CarbonableOffseter_registered_time_.read(token_id);
        return (time=time);
    }

    func registered_tokens_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (tokens_len: felt, tokens: Uint256*) {
        alloc_locals;

        let (contract_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (total_supply_uint256) = IERC721Enumerable.totalSupply(
            contract_address=contract_address
        );
        let (total_supply) = _uint_to_felt(total_supply_uint256);

        // [Check] totalSupply is not zero
        let not_zero = is_not_zero(total_supply);
        with_attr error_message("CarbonableOffseter: project total supply is null") {
            assert not_zero = TRUE;
        }

        let (local empty: Uint256*) = alloc();
        let (tokens_len, tokens) = _registerd_tokens_iter(
            contract_address=contract_address,
            user=address,
            index=total_supply - 1,
            tokens_len=0,
            tokens=empty,
        );
        return (tokens_len=tokens_len, tokens=tokens);
    }

    func registered_users{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        users_len: felt, users: felt*
    ) {
        let (users_len, users) = _read_users();
        return (users_len=users_len, users=users);
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
        let is_lower = is_le(quantity, claimable);
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
        token_id: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // [Interaction] Transfer token_id from caller to contract
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
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

        // [Effect] Register the caller with the token id and the current timestamp
        let (current_time) = get_block_timestamp();
        CarbonableOffseter_registered_owner_.write(token_id, caller);
        CarbonableOffseter_registered_time_.write(token_id, current_time);

        // [Effect] Emit event
        Deposit.emit(address=caller, token_id=token_id, time=current_time);

        // [Effect] Register the caller
        let (is_known) = CarbonableOffseter_known_user_.read(caller);
        let (index) = CarbonableOffseter_users_len_.read();
        if (is_known == FALSE) {
            CarbonableOffseter_users_.write(index, caller);
            CarbonableOffseter_users_len_.write(index + 1);
            CarbonableOffseter_known_user_.write(caller, TRUE);

            // [Security] End reetrancy guard
            ReentrancyGuard.end();
            return (success=TRUE);
        }

        // [Security] End reetrancy guard
        ReentrancyGuard.end();
        return (success=TRUE);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // [Effect] Store cumulated claimable
        let (caller) = get_caller_address();
        let (computed_claimable) = _claimable(user=caller);
        let (stored_claimable) = CarbonableOffseter_claimable_.read(caller);
        CarbonableOffseter_claimable_.write(caller, stored_claimable + computed_claimable);

        // [Effect] Remove the caller from registration for the token id
        CarbonableOffseter_registered_owner_.write(token_id, 0);
        CarbonableOffseter_registered_time_.write(token_id, 0);

        // [Interaction] Transfer token_id from contract to call
        let (carbonable_project_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (contract_address) = get_contract_address();
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

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        Withdraw.emit(address=caller, token_id=token_id, time=current_time);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success=TRUE);
    }

    //
    // Internals
    //

    func _read_users{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        users_len: felt, users: felt*
    ) {
        alloc_locals;
        let (users_len) = CarbonableOffseter_users_len_.read();
        let (local users: felt*) = alloc();

        if (users_len == 0) {
            return (users_len=users_len, users=users);
        }

        _read_users_iter(index=users_len - 1, users=users);
        return (users_len=users_len, users=users);
    }

    func _read_users_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, users: felt*
    ) {
        alloc_locals;
        let (user) = CarbonableOffseter_users_.read(index);
        assert users[index] = user;
        if (index == 0) {
            return ();
        }
        _read_users_iter(index=index - 1, users=users);
        return ();
    }

    func _registerd_tokens_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt, user: felt, index: felt, tokens_len: felt, tokens: Uint256*
    ) -> (tokens_len: felt, tokens: Uint256*) {
        alloc_locals;

        // Get registered owner of the current token index
        let (high, low) = split_felt(index);
        let index_uint256 = Uint256(low=low, high=high);
        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index_uint256
        );
        let (owner) = CarbonableOffseter_registered_owner_.read(token_id);

        // Check if user is registered owner
        let not_eq = is_not_zero(owner - user);
        if (not_eq == TRUE) {
            // Stop if index = 0
            if (index == 0) {
                return (tokens_len=tokens_len, tokens=tokens);
            }

            // Else move on to next index
            let (updated_tokens_len, updated_tokens) = _registerd_tokens_iter(
                contract_address=contract_address,
                user=user,
                index=index - 1,
                tokens_len=tokens_len,
                tokens=tokens,
            );
            return (tokens_len=updated_tokens_len, tokens=updated_tokens);
        }

        // User is the registered owner, the add the token id to the tokens array
        assert tokens[tokens_len] = token_id;

        // Stop if index is null
        if (index == 0) {
            return (tokens_len=tokens_len + 1, tokens=tokens);
        }
        let (updated_tokens_len, updated_tokens) = _registerd_tokens_iter(
            contract_address=contract_address,
            user=user,
            index=index - 1,
            tokens_len=tokens_len + 1,
            tokens=tokens,
        );
        return (tokens_len=updated_tokens_len, tokens=updated_tokens);
    }

    func _total_claimed_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, users: felt*
    ) -> (total_claimed: felt) {
        alloc_locals;

        let user = users[index];
        let (claimed) = CarbonableOffseter_claimed_.read(user);

        if (index == 0) {
            return (total_claimed=claimed);
        }

        let (add) = _total_claimed_iter(index=index - 1, users=users);
        return (total_claimed=claimed + add);
    }

    func _total_claimable_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        index: felt, users: felt*
    ) -> (total_claimable: felt) {
        alloc_locals;

        let user = users[index];
        let (claimable) = claimable_of(user);

        if (index == 0) {
            return (total_claimable=claimable);
        }

        let (add) = _total_claimable_iter(index=index - 1, users=users);
        return (total_claimable=claimable + add);
    }

    func _claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (claimable: felt) {
        alloc_locals;

        let (contract_address) = CarbonableOffseter_carbonable_project_address_.read();
        let (total_supply_uint256) = IERC721Enumerable.totalSupply(
            contract_address=contract_address
        );
        let (total_supply) = _uint_to_felt(total_supply_uint256);

        // [Check] totalSupply is not zero
        let not_zero = is_not_zero(total_supply);
        with_attr error_message("CarbonableOffseter: project total supply is null") {
            assert not_zero = TRUE;
        }

        let (total_claimable) = _claimable_iter(
            contract_address=contract_address, user=user, index=total_supply - 1
        );

        if (total_claimable == 0) {
            return (claimable=total_claimable);
        }

        let (claimable, _) = unsigned_div_rem(total_claimable, total_supply);
        return (claimable=claimable);
    }

    func _claimable_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt, user: felt, index: felt
    ) -> (claimable: felt) {
        alloc_locals;

        // Get registered owner of the current token index
        let (high, low) = split_felt(index);
        let index_uint256 = Uint256(low=low, high=high);
        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index_uint256
        );
        let (owner) = CarbonableOffseter_registered_owner_.read(token_id);
        let (time) = CarbonableOffseter_registered_time_.read(token_id);

        // Check if user is registered owner
        let not_eq = is_not_zero(owner - user);
        if (not_eq == TRUE) {
            // Stop if index = 0
            if (index == 0) {
                return (claimable=0);
            }

            // Else move on to next index
            let (add) = _claimable_iter(
                contract_address=contract_address, user=user, index=index - 1
            );
            return (claimable=add);
        }

        // User is the registered owner, then compute claimable for the current token
        let (initial_absorption) = ICarbonableProject.getAbsorption(
            contract_address=contract_address, time=time
        );
        let (final_absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=contract_address
        );

        // [Check] felt overflow
        let right_order = is_le(initial_absorption, final_absorption);
        with_attr error_message("CarbonableOffseter: Error while computing claimable") {
            assert right_order = TRUE;
        }
        let claimable = final_absorption - initial_absorption;

        // Stop if index is null
        if (index == 0) {
            return (claimable=claimable);
        }

        // Else move on to next index
        let (add) = _claimable_iter(contract_address=contract_address, user=user, index=index - 1);
        return (claimable=claimable + add);
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
}

// Assert helpers
namespace CarbonableOffseter_assert {
    func claimable_not_negligible{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        claimable: felt
    ) {
        let (minimum) = CarbonableOffseter.min_claimable();
        let is_lower = is_le(minimum, claimable);
        with_attr error_message("CarbonableOffseter: claimable balance must be not negligible") {
            assert is_lower = TRUE;
        }
        return ();
    }
}
