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
from openzeppelin.security.safemath import SafeUint256

# Project dependencies
from interfaces.minter import ICarbonableMinter
from interfaces.CarbonableProjectNFT import ICarbonableProjectNFT

# Context
const ADMIN = 1000
const ANYONE_1 = 1001

# CarbonableProjectNFT
const NFT_NAME = 'Carbonable ERC-721 Test'
const NFT_SYMBOL = 'CET'

# Payment token
const TOKEN_NAME = 'StableCoinToken'
const TOKEN_SYMBOL = 'SCT'
const TOKEN_DECIMALS = 6
const TOKEN_INITIAL_SUPPLY = 1000000

# CarbonableMint
const WHITELISTED_SALE_OPEN = FALSE
const PUBLIC_SALE_OPEN = TRUE
const MAX_BUY_PER_TX = 5
const UNIT_PRICE = 10
const MAX_SUPPLY_FOR_MINT = 10

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_contract
    tempvar payment_token_contract
    tempvar carbonable_minter_contract
    %{
        # ERC-721 deployment
        ids.project_nft_contract = deploy_contract(
            "./src/nft/project/CarbonableProjectNFT.cairo",
            {
                "name": ids.NFT_NAME,
                "symbol": ids.NFT_SYMBOL,
                "owner": ids.ADMIN,
            },
        ).contract_address 
        context.project_nft_contract = ids.project_nft_contract

        # ERC-20 deployment
        ids.payment_token_contract = deploy_contract(
            "./tests/mocks/token/erc20.cairo",
            {
                "name": ids.TOKEN_NAME,
                "symbol": ids.TOKEN_SYMBOL,
                "decimals": ids.TOKEN_DECIMALS,
                "initial_supply": ids.TOKEN_INITIAL_SUPPLY,
                "recipient": ids.ANYONE_1
            },
        ).contract_address 
        context.payment_token_contract = ids.payment_token_contract

        # Minter deployment
        ids.carbonable_minter_contract = deploy_contract(
            "./src/mint/minter.cairo",
            {
                "owner": ids.ADMIN,
                "project_nft_address": ids.project_nft_contract,
                "payment_token_address": ids.payment_token_contract,
                "whitelisted_sale_open": ids.WHITELISTED_SALE_OPEN,
                "public_sale_open": ids.PUBLIC_SALE_OPEN,
                "max_buy_per_tx": ids.MAX_BUY_PER_TX,
                "unit_price": ids.UNIT_PRICE,
                "max_supply_for_mint": ids.MAX_SUPPLY_FOR_MINT,
            },
        ).contract_address 
        context.carbonable_minter_contract = ids.carbonable_minter_contract
    %}

    return ()
end

@view
func test_e2e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    # Get ERC721 token deployed contract instance
    let (project_nft) = project_nft_instance.deployed()
    %{ print(f"project_nft contract address: {ids.project_nft}") %}
    # Get ERC20 token deployed contract instance
    let (payment_token) = payment_token_instance.deployed()
    %{ print(f"payment_token contract address: {ids.payment_token}") %}
    # Get Carbonable Minter deployed contract instance
    let (carbonable_minter) = carbonable_minter_instance.deployed()
    %{ print(f"carbonable_minter contract address: {ids.carbonable_minter}") %}

    with project_nft:
        %{ expect_events({"name": "OwnershipTransferred", "data": [ids.ADMIN, ids.carbonable_minter]}) %}
        project_nft_instance.transferOwnership(carbonable_minter)
        let (owner) = project_nft_instance.owner()
        assert owner = carbonable_minter
    end

    with payment_token:
        let (user_balance) = payment_token_instance.balanceOf(ANYONE_1)
        assert user_balance = Uint256(1000000, 0)

        %{ expect_events({"name": "Approval", "data": [ids.ANYONE_1, ids.carbonable_minter, 20, 0]}) %}
        let (success) = payment_token_instance.approve(carbonable_minter, Uint256(20, 0))
        assert success = TRUE

        let (allowance) = payment_token_instance.allowance(ANYONE_1, carbonable_minter)
        assert allowance = Uint256(20, 0)
    end

    with carbonable_minter:
        # Buy 2 NFTs
        let quantity = 2
        let (success) = carbonable_minter_instance.buy(quantity)
        assert success = TRUE
    end

    return ()
end

namespace project_nft_instance:
    func deployed() -> (project_nft_contract : felt):
        tempvar project_nft_contract
        %{ ids.project_nft_contract = context.project_nft_contract %}
        return (project_nft_contract)
    end

    func transferOwnership{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }(newOwner : felt):
        %{ stop_prank = start_prank(caller_address=ids.ADMIN, target_contract_address=ids.project_nft) %}
        ICarbonableProjectNFT.transferOwnership(project_nft, newOwner)
        %{ stop_prank() %}
        return ()
    end

    func owner{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }() -> (owner : felt):
        let (owner : felt) = ICarbonableProjectNFT.owner(project_nft)
        return (owner)
    end
end

namespace payment_token_instance:
    func deployed() -> (payment_token_contract : felt):
        tempvar payment_token_contract
        %{ ids.payment_token_contract = context.payment_token_contract %}
        return (payment_token_contract)
    end

    func balanceOf{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, payment_token : felt
    }(account : felt) -> (balance : Uint256):
        let (balance) = IERC20.balanceOf(payment_token, account)
        return (balance)
    end

    func approve{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, payment_token : felt
    }(spender : felt, amount : Uint256) -> (success : felt):
        %{ stop_prank = start_prank(ids.ANYONE_1, ids.payment_token) %}
        let (success) = IERC20.approve(payment_token, spender, amount)
        %{ stop_prank() %}
        return (success)
    end

    func allowance{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, payment_token : felt
    }(owner : felt, spender : felt) -> (remaining : Uint256):
        let (remaining) = IERC20.allowance(payment_token, owner, spender)
        return (remaining)
    end
end

namespace carbonable_minter_instance:
    func deployed() -> (carbonable_minter_contract : felt):
        tempvar carbonable_minter_contract
        %{ ids.carbonable_minter_contract = context.carbonable_minter_contract %}
        return (carbonable_minter_contract)
    end

    func buy{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(quantity : felt) -> (success : felt):
        %{ stop_prank = start_prank(caller_address=ids.ANYONE_1, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.buy(carbonable_minter, quantity)
        %{ stop_prank() %}
        return (success)
    end
end
