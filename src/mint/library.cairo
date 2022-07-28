# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (mint/library.cairo)

%lang starknet
# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_mul, uint256_le, uint256_eq
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.math_cmp import is_le

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

from openzeppelin.security.safemath import SafeUint256
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.token.erc721.interfaces.IERC721 import IERC721
from openzeppelin.token.erc721_enumerable.interfaces.IERC721_Enumerable import IERC721_Enumerable

from openzeppelin.access.ownable import Ownable

@contract_interface
namespace IERC721Mintable:
    func mint(to : felt, token_id : Uint256):
    end
end

# ------
# STORAGE
# ------

# Address of the project NFT contract
@storage_var
func project_nft_address_() -> (res : felt):
end

# Address of the project NFT contract
@storage_var
func payment_token_address_() -> (res : felt):
end

# Whether or not the whitelisted sale is open
@storage_var
func whitelisted_sale_open_() -> (res : felt):
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

# Whitelist
@storage_var
func whitelist_(account : felt) -> (res : felt):
end

namespace CarbonableMinter:
    # -----
    # VIEWS
    # -----

    func project_nft_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (project_nft_address : felt):
        let (project_nft_address) = project_nft_address_.read()
        return (project_nft_address)
    end

    func payment_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (payment_token_address : felt):
        let (payment_token_address) = payment_token_address_.read()
        return (payment_token_address)
    end

    func whitelisted_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (whitelisted_sale_open : felt):
        let (whitelisted_sale_open) = whitelisted_sale_open_.read()
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

    func whitelist{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        account : felt
    ) -> (slots : felt):
        let (slots) = whitelist_.read(account)
        return (slots)
    end

    # ------
    # CONSTRUCTOR
    # ------

    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt,
        project_nft_address : felt,
        payment_token_address : felt,
        whitelisted_sale_open : felt,
        public_sale_open : felt,
        max_buy_per_tx : felt,
        unit_price : Uint256,
        max_supply_for_mint : Uint256,
    ):
        Ownable.initializer(owner)
        project_nft_address_.write(project_nft_address)
        payment_token_address_.write(payment_token_address)
        whitelisted_sale_open_.write(whitelisted_sale_open)
        public_sale_open_.write(public_sale_open)
        max_buy_per_tx_.write(max_buy_per_tx)
        unit_price_.write(unit_price)
        max_supply_for_mint_.write(max_supply_for_mint)
        return ()
    end

    # ------------------
    # EXTERNAL FUNCTIONS
    # ------------------

    func set_whitelisted_sale_open{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(whitelisted_sale_open : felt):
        # Access control check
        Ownable.assert_only_owner()
        whitelisted_sale_open_.write(whitelisted_sale_open)
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

    func add_to_whitelist{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        account : felt, slots : felt
    ) -> (success : felt):
        # Access control check
        Ownable.assert_only_owner()
        whitelist_.write(account, slots)
        return (TRUE)
    end

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
        let (project_nft_address) = project_nft_address_.read()
        let (unit_price) = unit_price_.read()
        let (payment_token_address) = payment_token_address_.read()
        let (whitelisted_sale_open) = whitelisted_sale_open_.read()
        let (public_sale_open) = public_sale_open_.read()
        let (whitelisted_slots) = whitelist_.read(caller)
        let (max_buy_per_tx) = max_buy_per_tx_.read()

        # Compute variables required to check business logic rules
        let (enough_slots) = is_le(quantity, whitelisted_slots)
        let at_least_one_sale_type_open = (whitelisted_sale_open + public_sale_open)

        # Check if at least whitelisted or public sale is open
        with_attr error_message("CarbonableMinter: mint is not open"):
            assert_not_zero(at_least_one_sale_type_open)
        end

        # Check if account has available whitelisted slots if public sale is not open
        if public_sale_open == FALSE:
            with_attr error_message("CarbonableMinter: no whitelisted slot available"):
                assert enough_slots = TRUE
            end
        end

        # Check that desired quantity is lower than maximum allowed per transaction
        let (quantity_allowed) = is_le(quantity, max_buy_per_tx)
        with_attr error_message("CarbonableMinter: quantity not allowed"):
            assert quantity_allowed = TRUE
        end

        # Check if enough NFTs available
        let (total_supply) = IERC721_Enumerable.totalSupply(project_nft_address)
        let (supply_after_buy) = SafeUint256.add(total_supply, quantity_uint256)
        let (max_supply_for_mint) = max_supply_for_mint_.read()
        let (enough_left) = uint256_le(supply_after_buy, max_supply_for_mint)
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

        # TODO: do the actual NFT mint
        let starting_index = total_supply
        mint_n(project_nft_address, caller, starting_index, quantity_uint256)
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
