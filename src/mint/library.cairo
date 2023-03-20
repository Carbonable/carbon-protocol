// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_le,
    assert_nn,
    assert_in_range,
    assert_nn_le,
)
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_eq,
    uint256_lt,
    assert_uint256_le,
)
from starkware.starknet.common.syscalls import (
    get_block_timestamp,
    get_caller_address,
    get_contract_address,
)

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard
from openzeppelin.security.safemath.library import SafeUint256
from erc3525.IERC3525Full import IERC3525Full as IERC3525

// Local dependencies
from src.mint.merkletree import MerkleTree
from src.utils.type.library import _felt_to_uint, _uint_to_felt

//
// Events
//

@event
func PreSaleOpen(time: felt) {
}

@event
func PreSaleClose(time: felt) {
}

@event
func PublicSaleOpen(time: felt) {
}

@event
func PublicSaleClose(time: felt) {
}

@event
func SoldOut(time: felt) {
}

@event
func Airdrop(address: felt, value: Uint256, time: felt) {
}

@event
func Buy(address: felt, value: Uint256, time: felt) {
}

//
// Storages
//

@storage_var
func CarbonableMinter_carbonable_project_address_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_carbonable_project_slot_() -> (slot: Uint256) {
}

@storage_var
func CarbonableMinter_payment_token_address_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_public_sale_open_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_max_value_per_tx_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_min_value_per_tx_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_max_value_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_unit_price_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_reserved_value_() -> (res: felt) {
}

@storage_var
func CarbonableMinter_whitelist_merkle_root_() -> (whitelist_merkle_root: felt) {
}

@storage_var
func CarbonableMinter_claimed_value_(account: felt) -> (value: felt) {
}

namespace CarbonableMinter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt,
        carbonable_project_slot: Uint256,
        payment_token_address: felt,
        public_sale_open: felt,
        max_value_per_tx: felt,
        min_value_per_tx: felt,
        max_value: felt,
        unit_price: felt,
        reserved_value: felt,
    ) {
        // [Check] valid initialization
        with_attr error_message("CarbonableMinter: min_value_per_tx should be positive") {
            assert_nn(min_value_per_tx);
            assert_not_zero(min_value_per_tx);
        }
        with_attr error_message("CarbonableMinter: unit_price should be non-negative") {
            assert_nn(unit_price);
        }
        with_attr error_message("CarbonableMinter: reserved_value should be non-negative") {
            assert_nn(reserved_value);
        }
        with_attr error_message(
                "CarbonableMinter: reserved_value should be smaller than max_value") {
            assert_le(reserved_value, max_value);
        }
        with_attr error_message(
                "CarbonableMinter: min_value_per_tx should be smaller than max_value") {
            assert_le(max_value_per_tx, max_value);
        }

        // [Check] Uint256 compliance
        with_attr error_message(
                "CarbonableMinter: carbonable_project_slot is not a valid Uint256") {
            uint256_check(carbonable_project_slot);
        }

        // [Effect] Set storage variables
        CarbonableMinter_carbonable_project_address_.write(carbonable_project_address);
        CarbonableMinter_carbonable_project_slot_.write(carbonable_project_slot);
        CarbonableMinter_payment_token_address_.write(payment_token_address);
        CarbonableMinter_max_value_per_tx_.write(max_value_per_tx);
        CarbonableMinter_min_value_per_tx_.write(min_value_per_tx);
        CarbonableMinter_max_value_.write(max_value);
        CarbonableMinter_unit_price_.write(unit_price);
        CarbonableMinter_reserved_value_.write(reserved_value);

        // Use dedicated function to emit corresponding events
        set_public_sale_open(public_sale_open);

        return ();
    }

    //
    // Getters
    //

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = CarbonableMinter_carbonable_project_address_.read();
        return (carbonable_project_address,);
    }

    func carbonable_project_slot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (slot: Uint256) {
        let (carbonable_project_slot) = CarbonableMinter_carbonable_project_slot_.read();
        return (carbonable_project_slot,);
    }

    func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address: felt) {
        let (payment_token_address) = CarbonableMinter_payment_token_address_.read();
        return (payment_token_address,);
    }

    func pre_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        pre_sale_open: felt
    ) {
        let (whitelist_merkle_root) = CarbonableMinter_whitelist_merkle_root_.read();
        let pre_sale_open = is_not_zero(whitelist_merkle_root);
        return (pre_sale_open,);
    }

    func public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        public_sale_open: felt
    ) {
        let (public_sale_open) = CarbonableMinter_public_sale_open_.read();
        return (public_sale_open,);
    }

    func max_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        max_value_per_tx: felt
    ) {
        let (max_value_per_tx) = CarbonableMinter_max_value_per_tx_.read();
        return (max_value_per_tx,);
    }

    func min_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        min_value_per_tx: felt
    ) {
        let (min_value_per_tx) = CarbonableMinter_min_value_per_tx_.read();
        return (min_value_per_tx,);
    }

    func max_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        max_value: felt
    ) {
        let (max_value) = CarbonableMinter_max_value_.read();
        return (max_value,);
    }

    func unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        unit_price: felt
    ) {
        let (unit_price) = CarbonableMinter_unit_price_.read();
        return (unit_price,);
    }

    func reserved_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        reserved_value: felt
    ) {
        let (reserved_value) = CarbonableMinter_reserved_value_.read();
        return (reserved_value,);
    }

    func whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (whitelist_merkle_root: felt) {
        let (whitelist_merkle_root) = CarbonableMinter_whitelist_merkle_root_.read();
        return (whitelist_merkle_root,);
    }

    func whitelist_allocation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt, allocation: felt, proof_len: felt, proof: felt*
    ) -> (allocation: felt) {
        let (leaf) = hash2{hash_ptr=pedersen_ptr}(account, allocation);
        let (whitelist_merkle_root) = CarbonableMinter_whitelist_merkle_root_.read();  // 0 by default if not write
        let (whitelisted) = MerkleTree.verify(
            leaf=leaf, merkle_root=whitelist_merkle_root, proof_len=proof_len, proof=proof
        );
        return (allocation=whitelisted * allocation);  // 0 if not whitelisted else 1 * allocation
    }

    func claimed_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (value: felt) {
        let (value) = CarbonableMinter_claimed_value_.read(account);
        return (value,);
    }

    func sold_out{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        alloc_locals;
        let (max_value) = CarbonableMinter_max_value_.read();
        let (reserved_value) = CarbonableMinter_reserved_value_.read();
        let (sold_out_value) = _felt_to_uint(max_value - reserved_value);

        let (project_address) = CarbonableMinter_carbonable_project_address_.read();
        let (carbonable_project_slot) = CarbonableMinter_carbonable_project_slot_.read();
        let (total_value) = IERC3525.totalValue(project_address, carbonable_project_slot);

        let (status) = uint256_eq(sold_out_value, total_value);
        return (status=status);
    }

    //
    // Externals
    //

    func set_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        whitelist_merkle_root: felt
    ) {
        // [Effect] Update storage
        CarbonableMinter_whitelist_merkle_root_.write(whitelist_merkle_root);

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        if (whitelist_merkle_root != 0) {
            PreSaleOpen.emit(time=current_time);
            return ();
        }
        PreSaleClose.emit(time=current_time);
        return ();
    }

    func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        public_sale_open: felt
    ) {
        // [Check] Input is a boolean
        let is_not_boolean = is_not_zero(public_sale_open * (1 - public_sale_open));
        with_attr error_message("CarbonableMinter: public_sale_open must be either 0 or 1") {
            assert is_not_boolean = FALSE;
        }

        // [Effect] Update storage
        CarbonableMinter_public_sale_open_.write(public_sale_open);

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        if (public_sale_open == TRUE) {
            PublicSaleOpen.emit(time=current_time);
            return ();
        }
        PublicSaleClose.emit(time=current_time);
        return ();
    }

    func set_max_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        max_value_per_tx: felt
    ) {
        // [Check] 0 <= max_value_per_tx <= max_value
        with_attr error_message(
                "CarbonableMinter: max_value_per_tx should be less than max_value") {
            let (max_value) = CarbonableMinter_max_value_.read();
            assert_in_range(max_value_per_tx, 0, max_value + 1);
        }
        CarbonableMinter_max_value_per_tx_.write(max_value_per_tx);
        return ();
    }

    func set_min_value_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        min_value_per_tx: felt
    ) {
        // [Check] 0 <= min_value_per_tx <= max_value_per_tx
        with_attr error_message(
                "CarbonableMinter: min_value_per_tx should be less than max_value_per_tx") {
            let (max_value_per_tx) = CarbonableMinter_max_value_per_tx_.read();
            assert_in_range(min_value_per_tx, 0, max_value_per_tx + 1);
        }
        // [Effect] Set min_value_per_tx
        CarbonableMinter_min_value_per_tx_.write(min_value_per_tx);
        return ();
    }

    func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unit_price: felt
    ) {
        // [Check] Non_negative unit_price
        with_attr error_message("CarbonableMinter: unit_price should be non-negative") {
            assert_nn(unit_price);
        }
        // [Effect] Set unit_price
        CarbonableMinter_unit_price_.write(unit_price);
        return ();
    }

    func decrease_reserved_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt
    ) {
        alloc_locals;

        // [Check] Non_negative value
        with_attr error_message("CarbonableMinter: value is not valid") {
            assert_nn(value);
        }

        // [Check] Enough reserved value
        let (reserved_value) = CarbonableMinter_reserved_value_.read();
        let new_reserved_value = reserved_value - value;
        with_attr error_message("CarbonableMinter: not enough reserved value") {
            assert_nn(new_reserved_value);
        }

        // [Effect] Decrease the reserved value
        CarbonableMinter_reserved_value_.write(new_reserved_value);
        return ();
    }

    func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, value: felt
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Not zero address
        let (caller) = get_caller_address();
        with_attr error_message("CarbonableMinter: caller is the zero address") {
            assert_not_zero(caller);
        }
        // [Check] Amount non-negative
        with_attr error_message("CarbonableMinter: invalid value") {
            assert_nn(value);
        }

        // [Check] Enough value available
        let (carbonable_project_address) = CarbonableMinter_carbonable_project_address_.read();
        let (carbonable_project_slot) = CarbonableMinter_carbonable_project_slot_.read();
        let (total_value) = IERC3525.totalValue(
            carbonable_project_address, carbonable_project_slot
        );
        let (max_value_felt) = CarbonableMinter_max_value_.read();
        let (max_value) = _felt_to_uint(max_value_felt);
        let (value_left) = SafeUint256.sub_le(max_value, total_value);
        let (value_u256) = _felt_to_uint(value);
        with_attr error_message("CarbonableMinter: not enough available value") {
            assert_uint256_le(value_u256, value_left);
        }

        // [Check] Enough reserved value available
        let (reserved_value) = CarbonableMinter_reserved_value_.read();
        let new_reserved_value = reserved_value - value;
        with_attr error_message("CarbonableMinter: not enough available reserved value") {
            assert_nn(new_reserved_value);
        }

        // [Effect] Remove the minted amount from the reserved value
        CarbonableMinter_reserved_value_.write(new_reserved_value);

        // [Interaction] Mint
        IERC3525.mintNew(carbonable_project_address, to, carbonable_project_slot, value_u256);
        // [Effect] Emit event

        let (current_time) = get_block_timestamp();
        Airdrop.emit(address=to, value=value_u256, time=current_time);

        // [Security] End reentrancy guard
        ReentrancyGuard.end();

        return (TRUE,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        // [Interaction] ERC20 transfer
        let (caller) = get_caller_address();
        let (contract_address) = get_contract_address();
        let (payment_token_address) = CarbonableMinter_payment_token_address_.read();
        let (balance) = IERC20.balanceOf(
            contract_address=payment_token_address, account=contract_address
        );
        let (transfer_success) = transfer(
            token_address=payment_token_address, recipient=caller, amount=balance
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableMinter: transfer failed") {
            assert transfer_success = TRUE;
        }

        return (transfer_success,);
    }

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_address: felt, recipient: felt, amount: Uint256
    ) -> (success: felt) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableMinter: amount is not a valid Uint256") {
            uint256_check(amount);
        }

        // [Interaction] ERC20 transfer
        let (transfer_success) = IERC20.transfer(
            contract_address=token_address, recipient=recipient, amount=amount
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableMinter: transfer failed") {
            assert transfer_success = TRUE;
        }

        return (TRUE,);
    }

    func pre_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        allocation: felt, proof_len: felt, proof: felt*, value: felt, force: felt
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Whitelisted sale is open
        let (is_pre_sale) = pre_sale_open();
        with_attr error_message("CarbonableMinter: pre sale is not open") {
            assert_not_zero(is_pre_sale);
        }

        // [Check] Caller is whitelisted
        let (caller) = get_caller_address();
        let (allocation) = whitelist_allocation(
            account=caller, allocation=allocation, proof_len=proof_len, proof=proof
        );
        with_attr error_message("CarbonableMinter: caller address is not whitelisted") {
            assert_not_zero(allocation);
        }

        // [Check] Caller has available whitelisted value
        let (claimed_value) = CarbonableMinter_claimed_value_.read(caller);
        let available_value = value - claimed_value;
        with_attr error_message("CarbonableMinter: not enough allocation available") {
            assert_le(value, available_value);
        }

        // [Interaction] Buy
        let (minted_value) = buy(value, force);
        // Safe conversion since the minted value is lower or equal to the specified value in felt
        let (minted_value_felt) = _uint_to_felt(minted_value);

        // [Effect] Update claimed value
        let new_claimed_value = claimed_value + minted_value_felt;
        CarbonableMinter_claimed_value_.write(caller, new_claimed_value);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success=TRUE,);
    }

    func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt, force: felt
    ) -> (success: felt) {
        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] if at least pre or public sale is open
        let (public_sale_open) = CarbonableMinter_public_sale_open_.read();
        with_attr error_message("CarbonableMinter: public sale is not open") {
            assert_not_zero(public_sale_open);
        }

        // [Interaction] Buy
        buy(value, force);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success=TRUE,);
    }

    //
    // Internals
    //

    func buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        value: felt, force: felt
    ) -> (minted_value: Uint256) {
        alloc_locals;

        // [Check] value is not zero
        with_attr error_message("CarbonableMinter: value must be non-negative") {
            assert_not_zero(value);
        }

        // [Check] force is a boolean
        let is_not_boolean = is_not_zero(force * (1 - force));
        with_attr error_message("CarbonableMinter: force must be either 0 or 1") {
            assert is_not_boolean = FALSE;
        }

        // [Check] Not zero address
        let (caller) = get_caller_address();
        with_attr error_message("CarbonableMinter: caller is the zero address") {
            assert_not_zero(caller);
        }

        // [Check] Desired value is within range
        let (max_value_per_tx) = CarbonableMinter_max_value_per_tx_.read();
        let (min_value_per_tx) = CarbonableMinter_min_value_per_tx_.read();
        with_attr error_message("CarbonableMinter: value not allowed") {
            assert_le(min_value_per_tx, value);
            assert_le(value, max_value_per_tx);
        }

        // [Effect] If remaining value is lower than specified value and force is enabled
        // Then replace the specified value by the remaining value otherwize keep the value unchanged
        let (max_value) = CarbonableMinter_max_value_.read();
        let (reserved_value) = CarbonableMinter_reserved_value_.read();
        let (available_value_u256) = _felt_to_uint(max_value - reserved_value);

        let (project_address) = CarbonableMinter_carbonable_project_address_.read();
        let (project_slot) = CarbonableMinter_carbonable_project_slot_.read();
        let (total_value) = IERC3525.totalValue(project_address, project_slot);

        let (remaining_value) = SafeUint256.sub_le(available_value_u256, total_value);
        let (value_u256) = _felt_to_uint(value);
        let (is_lower) = uint256_lt(remaining_value, value_u256);

        // Set value = condition * remaining_value + (1 - condition) * value
        let condition = is_lower * force;
        let not_condition = 1 - condition;
        let cond_low = condition * remaining_value.low + not_condition * value_u256.low;
        let cond_high = condition * remaining_value.high + not_condition * value_u256.high;
        let value_u256 = Uint256(low=cond_low, high=cond_high);

        // [Check] Enough value available
        let (value_after_buy) = SafeUint256.add(total_value, value_u256);
        with_attr error_message("CarbonableMinter: not enough available value") {
            assert_uint256_le(value_after_buy, available_value_u256);
        }

        // [Interaction] ERC20 transfer
        let (unit_price) = CarbonableMinter_unit_price_.read();
        let (unit_price_u256) = _felt_to_uint(unit_price);
        let (amount) = SafeUint256.mul(value_u256, unit_price_u256);
        let (contract_address) = get_contract_address();
        let (payment_token_address) = CarbonableMinter_payment_token_address_.read();
        let (transfer_success) = IERC20.transferFrom(
            payment_token_address, caller, contract_address, amount
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableMinter: transfer failed") {
            assert transfer_success = TRUE;
        }

        // [Interaction] Mint
        IERC3525.mintNew(project_address, caller, project_slot, value_u256);

        // [Effect] Emit event
        let (current_time) = get_block_timestamp();
        Buy.emit(address=caller, value=value_u256, time=current_time);

        // [Effect] Close the sale if sold out
        let (is_sold_out) = sold_out();
        if (is_sold_out == TRUE) {
            // Close pre sale
            set_whitelist_merkle_root(whitelist_merkle_root=0);

            // Close public sale
            set_public_sale_open(public_sale_open=FALSE);

            // Emit sold out event
            SoldOut.emit(time=current_time);

            return (minted_value=value_u256,);
        }

        return (minted_value=value_u256,);
    }
}
