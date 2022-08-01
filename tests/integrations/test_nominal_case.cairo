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
const ANYONE = 1001

# CarbonableProjectNFT
const NFT_NAME = 'Carbonable ERC-721 Test'
const NFT_SYMBOL = 'CET'

# Payment token
const TOKEN_NAME = 'StableCoinToken'
const TOKEN_SYMBOL = 'SCT'
const TOKEN_DECIMALS = 6
const TOKEN_INITIAL_SUPPLY = 1000000

# CarbonableMint
const WHITELISTED_SALE_OPEN = TRUE
const PUBLIC_SALE_OPEN = FALSE
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
                "recipient": ids.ANYONE
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

    let (project_nft) = project_nft_instance.deployed()
    let (payment_token) = payment_token_instance.deployed()
    let (carbonable_minter) = carbonable_minter_instance.deployed()
    let (admin) = metadata.admin()

    with project_nft:
        project_nft_instance.transferOwnership(carbonable_minter, caller=admin)
        let (owner) = project_nft_instance.owner()
        assert owner = carbonable_minter
    end

    return ()
end

@view
func test_e2e_whitelist_on{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    # User: ANYONE
    # - wants to buy 6 NFTs (5 whitelist, 1 public)
    # - whitelisted: TRUE
    # - has enough funds: YES
    #
    # INITIAL STATE
    # ---
    # WHITELISTED_SALE_OPEN = TRUE
    # PUBLIC_SALE_OPEN = FALSE
    # MAX_BUY_PER_TX = 5
    # UNIT_PRICE = 10
    # MAX_SUPPLY_FOR_MINT = 10
    alloc_locals
    let (project_nft) = project_nft_instance.deployed()
    let (payment_token) = payment_token_instance.deployed()
    let (carbonable_minter) = carbonable_minter_instance.deployed()
    let (admin) = metadata.admin()
    let (anyone) = metadata.anyone()

    let whitelist_sale_quantity = 5
    let public_sale_quantity = 1
    let expected_nft_balance = Uint256(6, 0)

    # Admin set-up the minter contract and get the nft unit price
    with carbonable_minter:
        carbonable_minter_instance.add_to_whitelist(anyone, 5, caller=admin)
        let (unit_price) = carbonable_minter_instance.unit_price()
    end

    # Compute the amount of payment_token required for the whitelist sale
    let (whitelist_sale_amount) = SafeUint256.mul(Uint256(whitelist_sale_quantity, 0), unit_price)

    # Anyone approves the exact spend and buy nfts
    with payment_token:
        let (initial_token_balance) = payment_token_instance.balanceOf(anyone)
        let (success) = payment_token_instance.approve(
            carbonable_minter, whitelist_sale_amount, caller=anyone
        )
        assert success = TRUE
    end
    with carbonable_minter:
        let (success) = carbonable_minter_instance.buy(whitelist_sale_quantity, caller=anyone)
        assert success = TRUE
    end

    # Admin turn the whitelist sale off and enable the public sale
    with carbonable_minter:
        carbonable_minter_instance.set_whitelisted_sale_open(FALSE, caller=admin)
        carbonable_minter_instance.set_public_sale_open(TRUE, caller=admin)
    end

    # Compute the amount of payment_token required for the public sale
    let (public_sale_amount) = SafeUint256.mul(Uint256(public_sale_quantity, 0), unit_price)

    # Anyone approves the exact spend and buy nfts
    with payment_token:
        let (success) = payment_token_instance.approve(
            carbonable_minter, public_sale_amount, caller=anyone
        )
        assert success = TRUE
    end
    with carbonable_minter:
        let (success) = carbonable_minter_instance.buy(public_sale_quantity, caller=anyone)
        assert success = TRUE
    end

    # Check the user final nfts balance
    with project_nft:
        let (nft_balance) = project_nft_instance.balanceOf(anyone)
        assert nft_balance = expected_nft_balance
    end

    # Check the user final token balance
    with payment_token:
        let (token_balance) = payment_token_instance.balanceOf(anyone)
        let (delta) = SafeUint256.add(whitelist_sale_amount, public_sale_amount)
        let (expected_token_balance) = SafeUint256.sub_le(initial_token_balance, delta)
        assert token_balance = expected_token_balance
    end

    return ()
end

@view
func test_e2e_whitelist_off{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    # User: ANYONE
    # - wants to buy 6 NFTs (1 whitelist, 5 public)
    # - whitelisted: FALSE
    # - has enough funds: YES
    #
    # INITIAL STATE
    # ---
    # WHITELISTED_SALE_OPEN = TRUE
    # PUBLIC_SALE_OPEN = FALSE
    # MAX_BUY_PER_TX = 5
    # UNIT_PRICE = 10
    # MAX_SUPPLY_FOR_MINT = 10
    alloc_locals
    let (project_nft) = project_nft_instance.deployed()
    let (payment_token) = payment_token_instance.deployed()
    let (carbonable_minter) = carbonable_minter_instance.deployed()
    let (admin) = metadata.admin()
    let (anyone) = metadata.anyone()

    let whitelist_sale_quantity = 1
    let public_sale_quantity = 5
    let expected_nft_balance = Uint256(5, 0)

    # Get the nft unit price
    with carbonable_minter:
        let (unit_price) = carbonable_minter_instance.unit_price()
    end

    # Compute the amount of payment_token required for the whitelist sale
    let (whitelist_sale_amount) = SafeUint256.mul(Uint256(whitelist_sale_quantity, 0), unit_price)

    # Anyone approves the exact spend and buy nfts
    with payment_token:
        let (initial_token_balance) = payment_token_instance.balanceOf(anyone)
        let (success) = payment_token_instance.approve(
            carbonable_minter, whitelist_sale_amount, caller=anyone
        )
        assert success = TRUE
    end

    with carbonable_minter:
        %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: no whitelisted slot available") %}
        let (success) = carbonable_minter_instance.buy(whitelist_sale_quantity, caller=anyone)
        assert success = FALSE
    end

    # Admin turn the whitelist sale off and enable the public sale
    with carbonable_minter:
        carbonable_minter_instance.set_whitelisted_sale_open(FALSE, caller=admin)
        carbonable_minter_instance.set_public_sale_open(TRUE, caller=admin)
    end

    # Compute the amount of payment_token required for the public sale
    let (public_sale_amount) = SafeUint256.mul(Uint256(public_sale_quantity, 0), unit_price)

    # Anyone approves the exact spend and buy nfts
    with payment_token:
        let (success) = payment_token_instance.approve(
            carbonable_minter, public_sale_amount, caller=anyone
        )
        assert success = TRUE
    end
    with carbonable_minter:
        let (success) = carbonable_minter_instance.buy(public_sale_quantity, caller=anyone)
        assert success = TRUE
    end

    # Check the user final nfts balance
    with project_nft:
        let (nft_balance) = project_nft_instance.balanceOf(anyone)
        assert nft_balance = expected_nft_balance
    end

    # Check the user final token balance
    with payment_token:
        let (token_balance) = payment_token_instance.balanceOf(anyone)
        let (expected_token_balance) = SafeUint256.sub_le(initial_token_balance, public_sale_amount)
        assert token_balance = expected_token_balance
    end

    return ()
end

namespace metadata:
    func admin() -> (admin : felt):
        tempvar admin
        %{ ids.admin = ids.ADMIN %}
        return (admin)
    end

    func anyone() -> (user : felt):
        tempvar anyone
        %{ ids.anyone = ids.ANYONE %}
        return (anyone)
    end
end

namespace project_nft_instance:
    func deployed() -> (project_nft_contract : felt):
        tempvar project_nft_contract
        %{ ids.project_nft_contract = context.project_nft_contract %}
        return (project_nft_contract)
    end

    func transferOwnership{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }(newOwner : felt, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
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

    func balanceOf{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }(owner : felt) -> (balance : Uint256):
        let (balance) = IERC20.balanceOf(project_nft, owner)
        return (balance)
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
    }(spender : felt, amount : Uint256, caller : felt) -> (success : felt):
        %{ stop_prank = start_prank(ids.caller, ids.payment_token) %}
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

    func unit_price{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (unit_price : Uint256):
        let (unit_price) = ICarbonableMinter.unit_price(carbonable_minter)
        return (unit_price)
    end

    func set_whitelisted_sale_open{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(whitelisted_sale_open : felt, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_whitelisted_sale_open(carbonable_minter, whitelisted_sale_open)
        %{ stop_prank() %}
        return ()
    end

    func set_public_sale_open{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(public_sale_open : felt, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_public_sale_open(carbonable_minter, public_sale_open)
        %{ stop_prank() %}
        return ()
    end

    func add_to_whitelist{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(account : felt, slots : felt, caller : felt) -> (success : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.add_to_whitelist(carbonable_minter, account, slots)
        %{ stop_prank() %}
        return (success)
    end

    func buy{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(quantity : felt, caller : felt) -> (success : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.buy(carbonable_minter, quantity)
        %{ stop_prank() %}
        return (success)
    end
end
