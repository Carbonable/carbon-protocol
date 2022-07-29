# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_block_timestamp

# OpenZeppelin dependencies
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20

# Project dependencies
from interfaces.minter import ICarbonableMinter

# Shared context
const ADMIN = 'carbonable-admin'
const USER_1 = 'user-1'

# CarbonableProjectNFT context
const NFT_NAME = 'Carbonable ERC-721 Test'
const NFT_SYMBOL = 'CET'

# CarbonableMint
const PAYMENT_TOKEN_ADDRESS = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
const WHITELISTED_SALE_OPEN = FALSE
const PUBLIC_SALE_OPEN = TRUE
const MAX_BUY_PER_TX = 5
const UNIT_PRICE = 10
const MAX_SUPPLY_FOR_MINT = 10


@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_contract
    tempvar carbonable_minter_contract
    # hex address defined here to be felt-typed (const doesn't type it well)
    tempvar payment_token_address : felt = PAYMENT_TOKEN_ADDRESS
    %{
        ids.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": ids.NFT_NAME,
                "symbol": ids.NFT_SYMBOL,
                "owner": ids.ADMIN,
            },
        ).contract_address 
        context.project_nft_contract = ids.project_nft_contract

        ids.carbonable_minter_contract = deploy_contract(
            "./src/mint/minter.cairo",
            {
                "owner": ids.ADMIN,
                "project_nft_address": ids.project_nft_contract,
                "payment_token_address": ids.payment_token_address,
                "whitelisted_sale_open": ids.WHITELISTED_SALE_OPEN,
                "public_sale_open": ids.PUBLIC_SALE_OPEN,
                "max_buy_per_tx": ids.MAX_BUY_PER_TX,
                "unit_price": ids.UNIT_PRICE,
                "max_supply_for_mint": ids.MAX_SUPPLY_FOR_MINT,
            },
        ).contract_address 
        context.carbonable_minter_contract = ids.carbonable_minter_contract
    %}

    %{ stop_pranks = [start_prank(ids.ADMIN, contract) for contract in [ids.project_nft_contract, ids.carbonable_minter_contract] ] %}
    # Setup contracts with admin account
    %{ [stop_prank() for stop_prank in stop_pranks] %}

    return ()
end

@view
func test_e2e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Get ERC721 token deployed contract instance
    let (nft) = project_nft_instance.deployed()
    # Get Carbonable Minter deployed contract instance
    let (carbonable_minter) = carbonable_minter_instance.deployed()

    with carbonable_minter:
        # Buy 2 NFTs
        let quantity = 2
        %{ expect_revert("UNINITIALIZED_CONTRACT") %}
        let (success) = ICarbonableMinter.buy(carbonable_minter, quantity)
        assert success = TRUE
    end

    return ()
end

namespace carbonable_minter_instance:
    func deployed() -> (carbonable_minter_contract : felt):
        tempvar carbonable_minter_contract
        %{ ids.carbonable_minter_contract = context.carbonable_minter_contract %}
        return (carbonable_minter_contract)
    end

    func buy(quantity : felt) -> (success : felt):
        %{ stop_prank = start_prank(ids.ADMIN, ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.buy(quantity)
        %{ stop_prank() %}
        return (success)
    end
end

namespace project_nft_instance:
    func deployed() -> (project_nft_contract : felt):
        tempvar project_nft_contract
        %{ ids.project_nft_contract = context.project_nft_contract %}
        return (project_nft_contract)
    end
end
