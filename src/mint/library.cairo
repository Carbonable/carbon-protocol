# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.math_cmp import is_le, is_le_felt, is_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_le, uint256_eq
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

# Project dependencies
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.access.ownable.library import Ownable

# Local dependencies
from src.mint.merkletree import MerkleTree

@contract_interface
namespace IERC721Mintable:
    func mint(to : felt, token_id : Uint256):
    end
end

#
# Storage
#

# Address of the project NFT contract
@storage_var
func carbonable_project_address_() -> (res : felt):
end

# Address of the project NFT contract
@storage_var
func payment_token_address_() -> (res : felt):
end

# Whether or not the public sale is open
@storage_var
func public_sale_open_() -> (res : felt):
end

# Maximum number of NFTs possible to buy per transaction
@storage_var
func max_buy_per_tx_() -> (res : felt):
end

# NFT unit price (expressed in payment token address)
@storage_var
func unit_price_() -> (res : Uint256):
end

# Total supply
@storage_var
func max_supply_for_mint_() -> (res : Uint256):
end

# Reserved supply
@storage_var
func reserved_supply_for_mint_() -> (res : Uint256):
end

# Whitelist
@storage_var
func whitelist_merkle_root_() -> (whitelist_merkle_root : felt):
end

# Claimed slots
@storage_var
func claimed_slots_(account : felt) -> (slots : felt):
end

namespace CarbonableMinter:
    #
    # Constructor
    #

    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt,
        carbonable_project_address : felt,
        payment_token_address : felt,
        public_sale_open : felt,
        max_buy_per_tx : felt,
        unit_price : Uint256,
        max_supply_for_mint : Uint256,
        reserved_supply_for_mint : Uint256,
    ):
        Ownable.initializer(owner)
        carbonable_project_address_.write(carbonable_project_address)
        payment_token_address_.write(payment_token_address)
        public_sale_open_.write(public_sale_open)
        max_buy_per_tx_.write(max_buy_per_tx)
        unit_price_.write(unit_price)
        max_supply_for_mint_.write(max_supply_for_mint)
        reserved_supply_for_mint_.write(reserved_supply_for_mint)
        return ()
    end

    #
    # Getters
    #

    func carbonable_project_address{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address : felt):
        let (carbonable_project_address) = carbonable_project_address_.read()
        return (carbonable_project_address)
    end

    func payment_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address : felt):
        let (payment_token_address) = payment_token_address_.read()
        return (payment_token_address)
    end

    func whitelisted_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (whitelisted_sale_open : felt):
        let (whitelist_merkle_root) = whitelist_merkle_root_.read()
        let (whitelisted_sale_open) = is_not_zero(whitelist_merkle_root)
        return (whitelisted_sale_open)
    end

    func public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        public_sale_open : felt
    ):
        let (public_sale_open) = public_sale_open_.read()
        return (public_sale_open)
    end

    func max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        max_buy_per_tx : felt
    ):
        let (max_buy_per_tx) = max_buy_per_tx_.read()
        return (max_buy_per_tx)
    end

    func unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        unit_price : Uint256
    ):
        let (unit_price) = unit_price_.read()
        return (unit_price)
    end

    func max_supply_for_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (max_supply_for_mint : Uint256):
        let (max_supply_for_mint) = max_supply_for_mint_.read()
        return (max_supply_for_mint)
    end

    func reserved_supply_for_mint{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }() -> (reserved_supply_for_mint : Uint256):
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read()
        return (reserved_supply_for_mint)
    end

    func whitelist_merkle_root{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (whitelist_merkle_root : felt):
        let (whitelist_merkle_root) = whitelist_merkle_root_.read()
        return (whitelist_merkle_root)
    end

    func whitelisted_slots{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        account : felt, slots : felt, proof_len : felt, proof : felt*
    ) -> (slots : felt):
        let (leaf) = hash2{hash_ptr=pedersen_ptr}(account, slots)
        let (whitelist_merkle_root) = whitelist_merkle_root_.read()  # 0 by default if not write
        let (whitelisted) = MerkleTree.verify(
            leaf=leaf, merkle_root=whitelist_merkle_root, proof_len=proof_len, proof=proof
        )
        return (slots=slots * whitelisted)  # 0 if note whitelisted else 1 * slots
    end

    func claimed_slots{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        account : felt
    ) -> (slots : felt):
        let (slots) = claimed_slots_.read(account)
        return (slots)
    end

    #
    # Externals
    #

    func set_whitelist_merkle_root{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(whitelist_merkle_root : felt):
        # Access control check
        Ownable.assert_only_owner()
        whitelist_merkle_root_.write(whitelist_merkle_root)
        return ()
    end

    func set_public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        public_sale_open : felt
    ):
        # Access control check
        Ownable.assert_only_owner()
        public_sale_open_.write(public_sale_open)
        return ()
    end

    func set_max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        max_buy_per_tx : felt
    ):
        # Access control check
        Ownable.assert_only_owner()
        max_buy_per_tx_.write(max_buy_per_tx)
        return ()
    end

    func set_unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        unit_price : Uint256
    ):
        # Access control check
        Ownable.assert_only_owner()
        unit_price_.write(unit_price)
        return ()
    end

    func decrease_reserved_supply_for_mint{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(slots : Uint256):
        alloc_locals

        # Access control check
        Ownable.assert_only_owner()
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read()
        let (enough_slots) = uint256_le(slots, reserved_supply_for_mint)
        with_attr error_message("CarbonableMinter: not enough reserved slots"):
            assert enough_slots = TRUE
        end
        let (new_reserved_supply_for_mint) = SafeUint256.sub_le(reserved_supply_for_mint, slots)
        reserved_supply_for_mint_.write(new_reserved_supply_for_mint)
        return ()
    end

    func airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, quantity : felt
    ) -> (success : felt):
        alloc_locals
        # Access control check
        Ownable.assert_only_owner()

        # Get variables through system calls
        let (caller) = get_caller_address()
        let (contract_address) = get_contract_address()

        let quantity_uint256 = Uint256(quantity, 0)

        # Check preconditions
        with_attr error_message("CarbonableMinter: caller is the zero address"):
            assert_not_zero(caller)
        end

        # Get storage variables
        let (carbonable_project_address) = carbonable_project_address_.read()

        # Check if enough NFTs available
        let (total_supply) = IERC721Enumerable.totalSupply(carbonable_project_address)
        let (supply_after_buy) = SafeUint256.add(total_supply, quantity_uint256)
        let (max_supply_for_mint) = max_supply_for_mint_.read()
        let (enough_left) = uint256_le(supply_after_buy, max_supply_for_mint)
        with_attr error_message("CarbonableMinter: not enough available NFTs"):
            assert enough_left = TRUE
        end

        # Check if enough reserved NFTs available
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read()
        let (enough_reserved_left) = uint256_le(quantity_uint256, reserved_supply_for_mint)
        with_attr error_message("CarbonableMinter: not enough available reserved NFTs"):
            assert enough_reserved_left = TRUE
        end

        # Do the actual NFT mint
        let starting_index = total_supply
        mint_n(carbonable_project_address, to, starting_index, quantity_uint256)

        # Remove the minted quantity from the reserved supply
        let (new_reserved_supply_for_mint) = SafeUint256.sub_le(
            reserved_supply_for_mint, quantity_uint256
        )
        reserved_supply_for_mint_.write(new_reserved_supply_for_mint)

        # Success
        return (TRUE)
    end

    func withdraw{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        success : felt
    ):
        # Access control check
        Ownable.assert_only_owner()

        # Get storage variables
        let (caller) = get_caller_address()
        let (contract_address) = get_contract_address()
        let (payment_token_address) = payment_token_address_.read()

        # Do ERC20 transfer
        let (balance) = IERC20.balanceOf(
            contract_address=payment_token_address, account=contract_address
        )
        let (success) = transfer(
            token_address=payment_token_address, recipient=caller, amount=balance
        )

        return (success)
    end

    func transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        token_address : felt, recipient : felt, amount : Uint256
    ) -> (success : felt):
        # Access control check
        Ownable.assert_only_owner()

        # Do ERC20 transfer
        let (transfer_success) = IERC20.transfer(
            contract_address=token_address, recipient=recipient, amount=amount
        )
        with_attr error_message("CarbonableMinter: transfer failed"):
            assert transfer_success = TRUE
        end

        return (TRUE)
    end

    func whitelist_buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        slots : felt, proof_len : felt, proof : felt*, quantity : felt
    ) -> (success : felt):
        alloc_locals

        # Get variables through system calls
        let (caller) = get_caller_address()

        # Check if at least whitelisted or public sale is open
        let (is_whitelist_open) = whitelisted_sale_open()
        with_attr error_message("CarbonableMinter: whitelist sale is not open"):
            assert_not_zero(is_whitelist_open)
        end

        # Check if account is whitelisted
        let (slots) = whitelisted_slots(
            account=caller, slots=slots, proof_len=proof_len, proof=proof
        )
        with_attr error_message("CarbonableMinter: caller address is not whitelisted"):
            assert_not_zero(slots)
        end

        # Retrieve slots already claimed
        let (claimed_slots) = claimed_slots_.read(caller)
        let available_slots = slots - claimed_slots

        # Check if account has available whitelisted slots
        let (enough_slots) = is_le(quantity, available_slots)
        with_attr error_message("CarbonableMinter: not enough whitelisted slots available"):
            assert enough_slots = TRUE
        end

        # Buy NFTs
        let (success) = buy(quantity)

        # Update claimed slots
        let new_claimed_slots = claimed_slots + quantity
        claimed_slots_.write(caller, new_claimed_slots)

        return (success)
    end

    func public_buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        quantity : felt
    ) -> (success : felt):
        # Check if at least whitelisted or public sale is open
        let (public_sale_open) = public_sale_open_.read()
        with_attr error_message("CarbonableMinter: public sale is not open"):
            assert_not_zero(public_sale_open)
        end

        let (success) = buy(quantity)
        return (success)
    end

    #
    # Internals
    #

    func buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        quantity : felt
    ) -> (success : felt):
        alloc_locals
        # Get variables through system calls
        let (caller) = get_caller_address()
        let (contract_address) = get_contract_address()

        let quantity_uint256 = Uint256(quantity, 0)

        # Check preconditions
        with_attr error_message("CarbonableMinter: caller is the zero address"):
            assert_not_zero(caller)
        end

        # Get storage variables
        let (carbonable_project_address) = carbonable_project_address_.read()
        let (unit_price) = unit_price_.read()
        let (payment_token_address) = payment_token_address_.read()
        let (max_buy_per_tx) = max_buy_per_tx_.read()

        # Check that desired quantity is lower than maximum allowed per transaction
        let (quantity_allowed) = is_le(quantity, max_buy_per_tx)
        with_attr error_message("CarbonableMinter: quantity not allowed"):
            assert quantity_allowed = TRUE
        end

        # Check if enough NFTs available
        let (total_supply) = IERC721Enumerable.totalSupply(carbonable_project_address)
        let (supply_after_buy) = SafeUint256.add(total_supply, quantity_uint256)
        let (max_supply_for_mint) = max_supply_for_mint_.read()
        let (reserved_supply_for_mint) = reserved_supply_for_mint_.read()
        let (available_supply_for_mint) = SafeUint256.sub_le(
            max_supply_for_mint, reserved_supply_for_mint
        )
        let (enough_left) = uint256_le(supply_after_buy, available_supply_for_mint)
        with_attr error_message("CarbonableMinter: not enough available NFTs"):
            assert enough_left = TRUE
        end

        # Compute mint price
        let (amount) = SafeUint256.mul(quantity_uint256, unit_price)

        # Do ERC20 transfer
        let (transfer_success) = IERC20.transferFrom(
            payment_token_address, caller, contract_address, amount
        )
        with_attr error_message("CarbonableMinter: transfer failed"):
            assert transfer_success = TRUE
        end

        # Do the actual NFT mint
        let starting_index = total_supply
        mint_n(carbonable_project_address, caller, starting_index, quantity_uint256)
        # Success
        return (TRUE)
    end

    ###
    # Mint a number of NFTs to a recipient.
    # @param nft_contract_address the address of the NFT contract
    # @param to the address of the recipient
    # @param starting_index the starting index
    # @param quantity the quantity to mint
    ###
    func mint_n{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        nft_contract_address : felt, to : felt, starting_index : Uint256, quantity : Uint256
    ):
        alloc_locals
        let (no_more_left) = uint256_eq(quantity, Uint256(0, 0))
        if no_more_left == TRUE:
            return ()
        end
        let one = Uint256(1, 0)
        let (token_id) = SafeUint256.add(starting_index, one)
        # Mint
        IERC721Mintable.mint(nft_contract_address, to, token_id)

        let (new_quantity) = SafeUint256.sub_le(quantity, one)
        mint_n(nft_contract_address, to, token_id, new_quantity)
        return ()
    end
end
