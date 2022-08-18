# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (minter.cairo)

%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableMinter:
    ###
    # Compute and return releasable amount of tokens for a vesting.
    # @param vesting_id the vesting identifier
    # @return the amount of releasable tokens
    ###
    func project_nft_address() -> (project_nft_address : felt):
    end

    func payment_token_address() -> (payment_token_address : felt):
    end

    func whitelisted_sale_open() -> (whitelisted_sale_open : felt):
    end

    func public_sale_open() -> (public_sale_open : felt):
    end

    func max_buy_per_tx() -> (max_buy_per_tx : felt):
    end

    func unit_price() -> (unit_price : Uint256):
    end

    func max_supply_for_mint() -> (max_supply_for_mint : Uint256):
    end

    func reserved_supply_for_mint() -> (reserved_supply_for_mint : Uint256):
    end

    func whitelist_merkle_root() -> (whitelist_merkle_root : felt):
    end

    ###
    # Get the reserved slots number of the specified address.
    # @param account the specified account
    # @param slots the expected slots
    # @param proof_len the len of proof array
    # @param proof the proof array
    # @return the number of reserved slots
    ###
    func whitelisted_slots(account : felt, slots : felt, proof_len : felt, proof : felt*) -> (
        slots : felt
    ):
    end

    func set_whitelist_merkle_root(whitelist_merkle_root : felt):
    end

    func set_public_sale_open(public_sale_open : felt):
    end

    func set_max_buy_per_tx(max_buy_per_tx : felt):
    end

    func set_unit_price(unit_price : Uint256):
    end

    func decrease_reserved_supply_for_mint(slots : Uint256):
    end

    func airdrop(to : felt, quantity : felt) -> (success : felt):
    end

    func withdraw() -> (success : felt):
    end

    func transfer(token_address : felt, recipient : felt, amount : Uint256) -> (success : felt):
    end

    func whitelist_buy(slots : felt, proof_len : felt, proof : felt*, quantity : felt) -> (
        success : felt
    ):
    end

    func public_buy(quantity : felt) -> (success : felt):
    end
end
