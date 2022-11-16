// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn, assert_le
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_lt,
    uint256_eq,
    uint256_unsigned_div_rem,
)
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)
from starkware.cairo.common.math_cmp import is_le, is_not_zero

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard

// Local dependencies
from src.interfaces.project import ICarbonableProject

// Address of the project NFT contract
@storage_var
func carbonable_project_address_() -> (res: felt) {
}

// Start timestamp
@storage_var
func start_() -> (res: felt) {
}

// Unlocked duration
@storage_var
func unlocked_duration_() -> (res: felt) {
}

// Period duration
@storage_var
func period_duration_() -> (res: felt) {
}

// Registration
@storage_var
func registration_(token_id: Uint256) -> (address: felt) {
}

namespace CarbonableFarmer {
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

    func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        alloc_locals;

        // [Compute] Absolute locked time
        let (current_time) = get_block_timestamp();
        let (start) = start_.read();
        let (unlocked_duration) = unlocked_duration_.read();
        let locked_time = start + unlocked_duration;

        // [Compute] Absolute end time
        let (period_duration) = period_duration_.read();
        let end = start + period_duration;

        // [Evaluate] Boudaries and current time
        let is_before_locked = is_le(current_time, locked_time);
        let is_after_locked = is_le(end, current_time);
        let over = is_not_zero(is_before_locked + is_after_locked);
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
        with_attr error_message("CarbonableFarmer: dividend_uint256 is not a valid Uint256") {
            uint256_check(dividend_uint256);
        }

        let (shares, _) = uint256_unsigned_div_rem(dividend_uint256, total_contract);
        return (shares=shares,);
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (balance: felt) {
        alloc_locals;

        let (balance) = count(address);
        return (balance=balance,);
    }

    func registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (address: felt) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarmer: token_id is not a valid Uint256") {
            uint256_check(token_id);
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
        with_attr error_message("CarbonableFarmer: Invalid period duration") {
            assert_nn(period_duration);
        }
        with_attr error_message("CarbonableFarmer: Invalid locked duration") {
            assert_le(unlocked_duration, period_duration);
        }

        // [Effect] Store period information
        let (current_time) = get_block_timestamp();
        start_.write(current_time);
        period_duration_.write(period_duration);
        unlocked_duration_.write(unlocked_duration);

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
        with_attr error_message("CarbonableFarmer: No current period") {
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
        ReentrancyGuard._start();

        // [Check] Locked status
        let (status) = is_locked();
        with_attr error_message("CarbonableFarmer: deposits are currently locked") {
            assert status = FALSE;
        }

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarmer: token_id is not a valid Uint256") {
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
        with_attr error_message("CarbonableFarmer: transfer failed") {
            assert owner = contract_address;
        }

        // [Effect] Register the caller with the token id
        registration_.write(token_id, caller);

        // [Security] End reetrancy guard
        ReentrancyGuard._end();

        return (success=TRUE,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard._start();

        // [Check] Locked status
        let (status) = is_locked();
        with_attr error_message("CarbonableFarmer: withdrawals are currently locked") {
            assert status = FALSE;
        }

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarmer: token_id is not a valid Uint256") {
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
        with_attr error_message("CarbonableFarmer: transfer failed") {
            assert owner = caller;
        }

        // [Security] End reetrancy guard
        ReentrancyGuard._end();

        return (success=TRUE,);
    }

    //
    // Internals
    //

    func count{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
        count: felt
    ) {
        alloc_locals;

        let (contract_address) = carbonable_project_address_.read();
        let (total_supply) = IERC721Enumerable.totalSupply(contract_address=contract_address);
        let one = Uint256(1, 0);

        let (is_le) = uint256_lt(total_supply, one);
        if (is_le == TRUE) {
            return (count=0,);
        }

        let (index) = SafeUint256.sub_le(total_supply, one);
        let (count) = count_iter(contract_address=contract_address, address=address, index=index);

        return (count=count,);
    }

    func count_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract_address: felt, address: felt, index: Uint256
    ) -> (count: felt) {
        alloc_locals;

        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index
        );

        // Increment the counter if owner is the specified address
        let (owner) = registration_.read(token_id);
        let zero = Uint256(0, 0);
        let (is_zero) = uint256_eq(index, zero);
        if (owner == address) {
            let count = 1;

            // Stop if index is null
            if (is_zero == TRUE) {
                return (count=count,);
            }

            let one = Uint256(1, 0);
            let (next) = SafeUint256.sub_le(index, one);
            let (add) = count_iter(contract_address=contract_address, address=address, index=next);
            return (count=count + add,);
        } else {
            let count = 0;

            // Stop if index is null
            if (is_zero == TRUE) {
                return (count=count,);
            }

            let one = Uint256(1, 0);
            let (next) = SafeUint256.sub_le(index, one);
            let (add) = count_iter(contract_address=contract_address, address=address, index=next);
            return (count=count + add,);
        }
    }
}
