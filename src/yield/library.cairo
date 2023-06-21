// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn_le
from starkware.starknet.common.syscalls import get_block_timestamp, get_caller_address

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20

// Local dependencies
from src.farming.library import CarbonableFarming
from src.utils.type.library import _felt_to_uint

//
// Events
//

@event
func Claim(address: felt, amount: felt, time: felt) {
}

//
// Storages
//

@storage_var
func CarbonableYielder_payment_token_address_() -> (address: felt) {
}

@storage_var
func CarbonableYielder_total_claimed_() -> (claimed: felt) {
}

@storage_var
func CarbonableYielder_claimed_(address: felt) -> (claimed: felt) {
}

namespace CarbonableYielder {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        payment_token_address: felt
    ) {
        CarbonableYielder_payment_token_address_.write(payment_token_address);
        return ();
    }

    //
    // Getters
    //

    func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address: felt) {
        let (payment_token_address) = CarbonableYielder_payment_token_address_.read();
        return (payment_token_address=payment_token_address);
    }

    func total_claimable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        claimable: felt
    ) {
        alloc_locals;

        let (sale) = CarbonableFarming.total_sale();
        let (claimed) = CarbonableYielder_total_claimed_.read();
        let claimable = sale - claimed;

        // [Check] Overflow
        let (max_claimable) = CarbonableFarming.max_sale();
        with_attr error_message("CarbonableYielder: overflow while computing claimable") {
            assert_nn_le(claimable, max_claimable);
        }
        return (claimable=claimable);
    }

    func total_claimed{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        claimed: felt
    ) {
        let (claimed) = CarbonableYielder_total_claimed_.read();
        return (claimed=claimed);
    }

    func claimable_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (claimable: felt) {
        alloc_locals;

        let (sale) = CarbonableFarming.sale_of(address=address);
        let (claimed) = CarbonableYielder_claimed_.read(address);
        let claimable = sale - claimed;

        // [Check] Overflow
        let (total_claimable) = CarbonableYielder.total_claimable();
        with_attr error_message("CarbonableYielder: overflow while computing claimable") {
            assert_nn_le(claimable, total_claimable);
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

    func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        alloc_locals;

        // [Check] Total offsetable is not null
        let (caller) = get_caller_address();
        let (amount) = claimable_of(caller);

        // [Effect] Update user claimed
        let (stored) = CarbonableYielder_claimed_.read(caller);
        let claimed = stored + amount;
        CarbonableYielder_claimed_.write(caller, claimed);

        // [Effect] Update total claimed
        let (stored) = CarbonableYielder_total_claimed_.read();
        let claimed = stored + amount;
        CarbonableYielder_total_claimed_.write(claimed);

        // [Interaction] ERC20 transfer
        let (token_address) = CarbonableYielder_payment_token_address_.read();
        let (amount_u256) = _felt_to_uint(amount);
        let (transfer_success) = IERC20.transfer(
            contract_address=token_address, recipient=caller, amount=amount_u256
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableYielder: transfer failed") {
            assert transfer_success = TRUE;
        }

        // [Event] Emit event
        let (current_time) = get_block_timestamp();
        Claim.emit(address=caller, amount=amount, time=current_time);
        return ();
    }
}
