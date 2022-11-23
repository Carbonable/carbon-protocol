// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.math_cmp import is_le, is_le_felt, is_not_zero
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_mul,
    uint256_le,
    uint256_eq,
)
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.reentrancyguard.library import ReentrancyGuard
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from src.interfaces.project import ICarbonableProject
from src.mint.merkletree import MerkleTree

//
// Storage
//

// Address of the project NFT contract
@storage_var
func carbonable_project_address_() -> (res: felt) {
}

// Address of the project NFT contract
@storage_var
func payment_token_address_() -> (res: felt) {
}

// Whether or not the public sale is open
@storage_var
func public_sale_open_() -> (res: felt) {
}

// Maximum number of NFTs possible to buy per transaction
@storage_var
func max_buy_per_tx_() -> (res: felt) {
}

// NFT unit price (expressed in payment token address)
@storage_var
func unit_price_() -> (res: Uint256) {
}

// Total supply
@storage_var
func max_supply_for_mint_() -> (res: Uint256) {
}

// Reserved supply
@storage_var
func reserved_supply_for_mint_() -> (res: Uint256) {
}

// Whitelist
@storage_var
func whitelist_merkle_root_() -> (whitelist_merkle_root: felt) {
}

// Claimed slots
@storage_var
func claimed_slots_(account: felt) -> (slots: felt) {
}

namespace CarbonableMinter {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        carbonable_project_address: felt,
        payment_token_address: felt,
        public_sale_open: felt,
        max_buy_per_tx: felt,
        unit_price: Uint256,
        max_supply_for_mint: Uint256,
        reserved_supply_for_mint: Uint256,
    ) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableMinter: unit_price is not a valid Uint256") {
            uint256_check(unit_price);
        }
        with_attr error_message("CarbonableMinter: max_supply_for_mint is not a valid Uint256") {
            uint256_check(max_supply_for_mint);
        }
        with_attr error_message(
                "CarbonableMinter: reserved_supply_for_mint is not a valid Uint256") {
            uint256_check(reserved_supply_for_mint);
        }

        // [Effect] Set storage variables
        carbonable_project_address_.write(carbonable_project_address);
        payment_token_address_.write(payment_token_address);
        public_sale_open_.write(public_sale_open);
        max_buy_per_tx_.write(max_buy_per_tx);
        unit_price_.write(unit_price);
        max_supply_for_mint_.write(max_supply_for_mint);
        reserved_supply_for_mint_.write(reserved_supply_for_mint);
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

    func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address: felt) {
        let (payment_token_address) = payment_token_address_.read();
        return (payment_token_address,);
    }

    func whitelisted_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (whitelisted_sale_open: felt) {
        let (whitelist_merkle_root) = whitelist_merkle_root_.read();
        let whitelisted_sale_open = is_not_zero(whitelist_merkle_root);
        return (whitelisted_sale_open,);
    }

    func public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        public_sale_open: felt
    ) {
        let (public_sale_open) = public_sale_open_.read();
        return (public_sale_open,);
    }

    func max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        max_buy_per_tx: felt
    ) {
        let (max_buy_per_tx) = max_buy_per_tx_.read();
        return (max_buy_per_tx,);
    }

    func unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        unit_price: Uint256
    ) {
        let (unit_price) = unit_price_.read();
        return (unit_price,);
    }

    func max_supply_for_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        max_supply_for_mint: Uint256
    ) {
        let (max_supply_for_mint) = max_supply_for_mint_.read();
        return (max_supply_for_mint,);
    }

    func reserved_supply_for_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (reserved_supply_for_mint: Uint256) {
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read();
        return (reserved_supply_for_mint,);
    }

    func whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (whitelist_merkle_root: felt) {
        let (whitelist_merkle_root) = whitelist_merkle_root_.read();
        return (whitelist_merkle_root,);
    }

    func whitelisted_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt, slots: felt, proof_len: felt, proof: felt*
    ) -> (slots: felt) {
        let (leaf) = hash2{hash_ptr=pedersen_ptr}(account, slots);
        let (whitelist_merkle_root) = whitelist_merkle_root_.read();  // 0 by default if not write
        let (whitelisted) = MerkleTree.verify(
            leaf=leaf, merkle_root=whitelist_merkle_root, proof_len=proof_len, proof=proof
        );
        return (slots=slots * whitelisted);  // 0 if note whitelisted else 1 * slots
    }

    func claimed_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (slots: felt) {
        let (slots) = claimed_slots_.read(account);
        return (slots,);
    }

    //
    // Externals
    //

    func set_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        whitelist_merkle_root: felt
    ) {
        whitelist_merkle_root_.write(whitelist_merkle_root);
        return ();
    }

    func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        public_sale_open: felt
    ) {
        public_sale_open_.write(public_sale_open);
        return ();
    }

    func set_max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        max_buy_per_tx: felt
    ) {
        max_buy_per_tx_.write(max_buy_per_tx);
        return ();
    }

    func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unit_price: Uint256
    ) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableMinter: unit_price is not a valid Uint256") {
            uint256_check(unit_price);
        }

        unit_price_.write(unit_price);
        return ();
    }

    func decrease_reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(slots: Uint256) {
        alloc_locals;

        // [Check] Uint256 compliance
        with_attr error_message("CarbonableMinter: slots is not a valid Uint256") {
            uint256_check(slots);
        }

        // [Check] Enough reserved slots
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read();
        let (enough_slots) = uint256_le(slots, reserved_supply_for_mint);
        with_attr error_message("CarbonableMinter: not enough reserved slots") {
            assert enough_slots = TRUE;
        }

        // [Effect] Decrease the reserved supply
        let (new_reserved_supply_for_mint) = SafeUint256.sub_le(reserved_supply_for_mint, slots);
        reserved_supply_for_mint_.write(new_reserved_supply_for_mint);
        return ();
    }

    func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, quantity: felt
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Not zero address
        let (caller) = get_caller_address();
        with_attr error_message("CarbonableMinter: caller is the zero address") {
            assert_not_zero(caller);
        }

        // [Check] Enough NFTs available
        let quantity_uint256 = Uint256(quantity, 0);
        let (carbonable_project_address) = carbonable_project_address_.read();
        let (total_supply) = IERC721Enumerable.totalSupply(carbonable_project_address);
        let (supply_after_buy) = SafeUint256.add(total_supply, quantity_uint256);
        let (max_supply_for_mint) = max_supply_for_mint_.read();
        let (enough_left) = uint256_le(supply_after_buy, max_supply_for_mint);
        with_attr error_message("CarbonableMinter: not enough available NFTs") {
            assert enough_left = TRUE;
        }

        // [Check] Enough reserved NFTs available
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read();
        let (enough_reserved_left) = uint256_le(quantity_uint256, reserved_supply_for_mint);
        with_attr error_message("CarbonableMinter: not enough available reserved NFTs") {
            assert enough_reserved_left = TRUE;
        }

        // [Effect] Remove the minted quantity from the reserved supply
        let (new_reserved_supply_for_mint) = SafeUint256.sub_le(
            reserved_supply_for_mint, quantity_uint256
        );
        reserved_supply_for_mint_.write(new_reserved_supply_for_mint);

        // [Interaction] Mint
        let starting_index = total_supply;
        mint_iter(carbonable_project_address, to, starting_index, quantity_uint256);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (TRUE,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        success: felt
    ) {
        // [Interaction] ERC20 transfer
        let (caller) = get_caller_address();
        let (contract_address) = get_contract_address();
        let (payment_token_address) = payment_token_address_.read();
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

    func whitelist_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slots: felt, proof_len: felt, proof: felt*, quantity: felt
    ) -> (success: felt) {
        alloc_locals;

        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] Whitelisted sale is open
        let (is_whitelist_open) = whitelisted_sale_open();
        with_attr error_message("CarbonableMinter: whitelist sale is not open") {
            assert_not_zero(is_whitelist_open);
        }

        // [Check] Caller is whitelisted
        let (caller) = get_caller_address();
        let (slots) = whitelisted_slots(
            account=caller, slots=slots, proof_len=proof_len, proof=proof
        );
        with_attr error_message("CarbonableMinter: caller address is not whitelisted") {
            assert_not_zero(slots);
        }

        // [Check] Caller has available whitelisted slots
        let (claimed_slots) = claimed_slots_.read(caller);
        let available_slots = slots - claimed_slots;
        let enough_slots = is_le(quantity, available_slots);
        with_attr error_message("CarbonableMinter: not enough whitelisted slots available") {
            assert enough_slots = TRUE;
        }

        // [Effect] Update claimed slots
        let new_claimed_slots = claimed_slots + quantity;
        claimed_slots_.write(caller, new_claimed_slots);

        // [Interaction] Buy
        let (success) = buy(quantity);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success,);
    }

    func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) -> (success: felt) {
        // [Security] Start reetrancy guard
        ReentrancyGuard.start();

        // [Check] if at least whitelisted or public sale is open
        let (public_sale_open) = public_sale_open_.read();
        with_attr error_message("CarbonableMinter: public sale is not open") {
            assert_not_zero(public_sale_open);
        }

        // [Interaction] Buy
        let (success) = buy(quantity);

        // [Security] End reetrancy guard
        ReentrancyGuard.end();

        return (success,);
    }

    //
    // Internals
    //

    func buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) -> (
        success: felt
    ) {
        alloc_locals;

        // [Check] Not zero address
        let (caller) = get_caller_address();
        with_attr error_message("CarbonableMinter: caller is the zero address") {
            assert_not_zero(caller);
        }

        // [Check] Desired quantity is lower than maximum allowed per transaction
        let (max_buy_per_tx) = max_buy_per_tx_.read();
        let quantity_allowed = is_le(quantity, max_buy_per_tx);
        with_attr error_message("CarbonableMinter: quantity not allowed") {
            assert quantity_allowed = TRUE;
        }

        // [Check] Enough NFTs available
        let (carbonable_project_address) = carbonable_project_address_.read();
        let quantity_uint256 = Uint256(quantity, 0);
        let (total_supply) = IERC721Enumerable.totalSupply(carbonable_project_address);
        let (supply_after_buy) = SafeUint256.add(total_supply, quantity_uint256);
        let (max_supply_for_mint) = max_supply_for_mint_.read();
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read();
        let (available_supply_for_mint) = SafeUint256.sub_le(
            max_supply_for_mint, reserved_supply_for_mint
        );
        let (enough_left) = uint256_le(supply_after_buy, available_supply_for_mint);
        with_attr error_message("CarbonableMinter: not enough available NFTs") {
            assert enough_left = TRUE;
        }

        // [Interaction] ERC20 transfer
        let (unit_price) = unit_price_.read();
        let (amount) = SafeUint256.mul(quantity_uint256, unit_price);
        let (contract_address) = get_contract_address();
        let (payment_token_address) = payment_token_address_.read();
        let (transfer_success) = IERC20.transferFrom(
            payment_token_address, caller, contract_address, amount
        );

        // [Check] Transfer successful
        with_attr error_message("CarbonableMinter: transfer failed") {
            assert transfer_success = TRUE;
        }

        // [Interaction] Mint
        let starting_index = total_supply;
        mint_iter(carbonable_project_address, caller, starting_index, quantity_uint256);

        return (TRUE,);
    }

    // @notice Mint a number of NFTs to a recipient.
    // @param nft_contract_address the address of the NFT contract
    // @param to the address of the recipient
    // @param starting_index the starting index
    // @param quantity the quantity to mint
    func mint_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        nft_contract_address: felt, to: felt, starting_index: Uint256, quantity: Uint256
    ) {
        alloc_locals;

        // [Check] Stop condition
        let (no_more_left) = uint256_eq(quantity, Uint256(0, 0));
        if (no_more_left == TRUE) {
            return ();
        }

        // [Interaction] Mint
        let one = Uint256(1, 0);
        let (token_id) = SafeUint256.add(starting_index, one);
        ICarbonableProject.mint(nft_contract_address, to, token_id);

        // [Interaction] Call next mint
        let (new_quantity) = SafeUint256.sub_le(quantity, one);
        mint_iter(nft_contract_address, to, token_id, new_quantity);
        return ();
    }
}
