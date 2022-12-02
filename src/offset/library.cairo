// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn, assert_le, split_felt
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
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard
from interfaces.starkvest import IStarkVest

// Local dependencies
from src.interfaces.project import ICarbonableProject

const TIMES = 'times';
const ABSORPTIONS = 'absorptions';

//
// Events
//

@event
func Claim(address: felt, quantity: felt, time: felt) {
}

@storage_var
func carbonable_project_address_() -> (address: felt) {
}

@storage_var
func registered_owner_(tokenId: Uint256) -> (address: felt) {
}

@storage_var
func registered_time_(tokenId: Uint256) -> (time: felt) {
}

@storage_var
func absorptions_len_() -> (length: felt) {
}

@storage_var
func absorptions_(index: felt) -> (absorption: felt) {
}

@storage_var
func times_(index: felt) -> (absorption: felt) {
}

@storage_var
func claimable_(address: felt) -> (claimable: felt) {
}

@storage_var
func claimed_(address: felt) -> (claimed: felt) {
}

namespace CarbonableOffseter {
    //
    // Constructor
    //

    func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(
        carbonable_project_address: felt,
        times_len: felt,
        times: felt*,
        absoprtions_len: felt,
        absoprtions: felt*,
    ) {
        alloc_locals;
        carbonable_project_address_.write(carbonable_project_address);

        let (stored_times) = StringCodec.ss_arr_to_string(times_len, times);
        StringCodec.write(TIMES, stored_times);

        let (stored_absorptions) = StringCodec.ss_arr_to_string(absoprtions_len, absoprtions);
        StringCodec.write(ABSORPTIONS, stored_absorptions);

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

    func claimable_of{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(address: felt) -> (claimable: felt) {
        alloc_locals;

        let (current_time) = get_block_timestamp();
        let (computed_claimable) = _claimable(address=address, time=current_time);
        let (stored_claimable) = claimable_.read(address);
        let (stored_claimed) = claimed_.read(address);
        return (claimable=stored_claimable + computed_claimable - stored_claimed,);
    }

    func claimed_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimed: felt) {
        let (claimed) = claimed_.read(address);
        return (claimed=claimed,);
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
        let (carbonable_project_address) = carbonable_project_address_.read();
        // [Check] Throws error if unknown token id
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token_id has not been registered") {
            assert owner = contract_address;
        }

        let (address) = registered_owner_.read(token_id);
        return (address=address,);
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
        let (carbonable_project_address) = carbonable_project_address_.read();
        // [Check] Throws error if unknown token id
        let (owner) = IERC721.ownerOf(
            contract_address=carbonable_project_address, tokenId=token_id
        );
        with_attr error_message("CarbonableOffseter: token_id has not been registered") {
            assert owner = contract_address;
        }

        let (time) = registered_time_.read(token_id);
        return (time=time,);
    }

    //
    // Externals
    //

    func claim{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }() -> (success: felt) {
        alloc_locals;

        // [Check] Total offsetable not null
        let (caller) = get_caller_address();
        let (claimable) = claimable_of(caller);
        let is_zero = is_not_zero(claimable);
        with_attr error_message("CarbonableOffseter: claimable balance must be positive") {
            assert is_zero = FALSE;
        }

        // [Effect] Transfer value from offsetable to offseted
        let (claimed) = claimed_.read(caller);
        claimed_.write(caller, claimed + claimable);

        let (current_time) = get_block_timestamp();
        Claim.emit(address=caller, quantity=claimable, time=current_time);
        return (success=TRUE,);
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

        // [Effect] Register the caller with the token id and the current timestamp
        let (current_time) = get_block_timestamp();
        registered_owner_.write(token_id, caller);
        registered_time_.write(token_id, current_time);

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

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableOffseter: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // [Effect] Remove the caller from registration for the token id
        registered_owner_.write(token_id, 0);
        registered_time_.write(token_id, 0);

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

    //
    // Internals
    //

    func _claimable{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(address: felt, time: felt) -> (claimable: felt) {
        alloc_locals;

        let (contract_address) = carbonable_project_address_.read();
        let (total_supply_uint256) = IERC721Enumerable.totalSupply(
            contract_address=contract_address
        );

        // [Check] totalSupply is lower than 2**128
        let is_too_high = is_not_zero(total_supply_uint256.high);
        with_attr error_message("CarbonableOffseter: project total supply too high") {
            assert is_too_high = 0;
        }

        let total_supply = total_supply_uint256.low;

        if (total_supply == 0) {
            return (claimable=0,);
        }

        let index = total_supply - 1;
        let (claimable) = _claimable_iter(
            contract_address=contract_address, address=address, current_time=time, index=index
        );

        return (claimable=claimable,);
    }

    func _claimable_iter{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(contract_address: felt, address: felt, current_time: felt, index: felt) -> (claimable: felt) {
        alloc_locals;

        // Get registered owner of the current token index
        let (low, high) = split_felt(index);
        let index_uint256 = Uint256(low=low, high=high);
        let (token_id) = IERC721Enumerable.tokenByIndex(
            contract_address=contract_address, index=index_uint256
        );
        let (owner) = registered_owner_.read(token_id);
        let (time) = registered_time_.read(token_id);

        // Increment the counter if owner is the specified address
        let not_eq = is_not_zero(owner - address);
        let eq = 1 - not_eq;

        let (initial_claimable) = _compute_claimable(time=time);
        let (final_claimable) = _compute_claimable(time=current_time);
        let claimable = final_claimable - initial_claimable;

        // Stop if index is null
        if (index == 0) {
            return (claimable=claimable,);
        }

        // Else move on to next index
        let (add) = _claimable_iter(
            contract_address=contract_address,
            address=address,
            current_time=current_time,
            index=index - 1,
        );
        return (claimable=claimable + add,);
    }

    func _compute_claimable{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(time: felt) -> (computed_claimable: felt) {
        alloc_locals;

        let (absorptions) = StringCodec.read(ABSORPTIONS);
        let (times) = StringCodec.read(TIMES);
        let (computed_claimable) = _compute_claimable_iter(
            time=time, index=times.len - 1, times=times.data, absorptions=absorptions.data
        );
        return (computed_claimable=computed_claimable,);
    }

    func _compute_claimable_iter{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(time: felt, index: felt, times: felt*, absorptions: felt*) -> (computed_claimable: felt) {
        let stored_time = times[index];
        let is_after = is_le(stored_time, time);
        if (is_after == TRUE) {
            let computed_claimable = absorptions[index];
            return (computed_claimable=computed_claimable);
        }

        if (index == 0) {
            return (computed_claimable=0);
        }

        let (computed_claimable) = _compute_claimable_iter(
            time=time, index=index - 1, times=times, absorptions=absorptions
        );
        return (computed_claimable=computed_claimable,);
    }
}
