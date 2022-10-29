// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_nn,
    assert_le,
    assert_in_range,
    unsigned_div_rem,
)
from starkware.cairo.common.uint256 import Uint256, uint256_check, uint256_le
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)
from starkware.cairo.common.math_cmp import is_le

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

// End timestamp
@storage_var
func end_() -> (res: felt) {
}

// Locked duration
@storage_var
func locked_duration_() -> (res: felt) {
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
        start: felt,
        end: felt,
        locked_duration: felt,
        period_duration: felt,
        carbonable_project_address: felt,
    ) {
        start_.write(start);
        end_.write(end);
        locked_duration_.write(locked_duration);
        period_duration_.write(period_duration);

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
        return (carbonable_minter_address,);
    }

    func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        alloc_locals;

        // Get current timestamp
        let (current_time) = get_block_timestamp();

        // Return FALSE if the current time is before the start period or after the end period
        let (start) = start_.read();
        let (end) = end_.read();
        let (is_before_start) = is_le(current_time, start);
        let (is_after_end) = is_le(end, current_time);
        let over = is_before_start + is_after_end;
        if (over == TRUE) {
            return (status=FALSE,);
        }

        // Compute the relative time in the current period
        let (total_duration) = current_time - start;
        let (period_duration) = period_duration_.read();
        let (_, current_duration) = unsigned_div_rem(total_duration, period_duration);

        // Returns FALSE if the relative time is before the end of the locked period else TRUE
        let (locked_duration) = locked_duration_.read();
        let (status) = is_le(current_duration, locked_duration);
        return (status=status,);
    }

    func total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        count: felt
    ) {
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = carbonable_project_address_.read();
        // TODO

        return (count=count,);
    }

    func share{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
        share: felt
    ) {
        let share = 0;
        return (share=share,);
    }

    func user{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
        share: felt
    ) {
        let share = 0;
        return (share=share,);
    }

    //
    // Externals
    //

    func lock{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard._start();

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableFarmer: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // [Interaction] Transfer token_id from caller to contract
        let (caller) = get_caller_address();
        let (contract_address) = get_contract_address();
        let (carbonable_project_address) = carbonable_project_address_.read();
        IERC721.transferFrom(
            contract=carbonable_project_address, from_=caller, to=contract_address, tokenId=token_id
        );

        // [Check] Transfer successful
        let (owner) = IERC721.ownerOf(contract=carbonable_project_address, tokenId=token_id);
        with_attr error_message("CarbonableFarmer: transfer failed") {
            assert owner = contract_address;
        }

        // [Effect] Regesiter the caller with the token id
        registration_.write(token_id, caller);

        // [Security] End reetrancy guard
        ReentrancyGuard._end();

        return (sucess=TRUE,);
    }

    //
    // Internals
    //

    func count{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
        count: felt
    ) {
        alloc_locals;

        let (carbonable_project_address) = carbonable_project_address_.read();
        let (total_supply) = IERC721Enumerable.totalSupply(contract=carbonable_project_address);
        let one = Uint256(1, 0);

        let (is_le) = uint256_le(total_supply, one);
        if (is_le == TRUE) {
            return (count=0,);
        }

        let (index) = SafeUint256.sub_le(total_supply, one);
        let (count) = count_iter(contract=carbonable_project_address, address=address, index=index);

        return (count=count,);
    }

    func count_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        contract: felt, address: felt, index: Uint256
    ) -> (count: felt) {
        alloc_locals;

        let zero = Uint256(0, 0);
        let (token_id) = IERC721Enumerable.tokenByIndex(contract=contract, index=index);
        // TODO
    }
}

namespace CarbonableYielder {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        return ();
    }
}

namespace CarbonableOffseter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        return ();
    }
}
