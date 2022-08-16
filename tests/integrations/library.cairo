# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256

# OpenZeppelin dependencies
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.security.safemath import SafeUint256

# Project dependencies
from interfaces.minter import ICarbonableMinter
from interfaces.CarbonableProjectNFT import IERC721, IERC721_Enumerable, ICarbonableProjectNFT

namespace project_nft_instance:
    # Internals

    func deployed() -> (project_nft_contract : felt):
        tempvar project_nft_contract
        %{ ids.project_nft_contract = context.project_nft_contract %}
        return (project_nft_contract)
    end

    # Views

    func owner{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }() -> (owner : felt):
        let (owner : felt) = ICarbonableProjectNFT.owner(project_nft)
        return (owner)
    end

    func balanceOf{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }(owner : felt) -> (balance : Uint256):
        let (balance) = IERC721.balanceOf(project_nft, owner)
        return (balance)
    end

    func totalSupply{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }() -> (totalSupply : Uint256):
        let (total_supply) = IERC721_Enumerable.totalSupply(project_nft)
        return (total_supply)
    end

    # Externals

    func transferOwnership{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, project_nft : felt
    }(newOwner : felt, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProjectNFT.transferOwnership(project_nft, newOwner)
        %{ stop_prank() %}
        return ()
    end
end

namespace payment_token_instance:
    # Internals

    func deployed() -> (payment_token_contract : felt):
        tempvar payment_token_contract
        %{ ids.payment_token_contract = context.payment_token_contract %}
        return (payment_token_contract)
    end

    # Views

    func balanceOf{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, payment_token : felt
    }(account : felt) -> (balance : Uint256):
        let (balance) = IERC20.balanceOf(payment_token, account)
        return (balance)
    end

    func allowance{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, payment_token : felt
    }(owner : felt, spender : felt) -> (remaining : Uint256):
        let (remaining) = IERC20.allowance(payment_token, owner, spender)
        return (remaining)
    end

    # Externals

    func approve{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, payment_token : felt
    }(spender : felt, amount : Uint256, caller : felt) -> (success : felt):
        %{ stop_prank = start_prank(ids.caller, ids.payment_token) %}
        let (success) = IERC20.approve(payment_token, spender, amount)
        %{ stop_prank() %}
        return (success)
    end
end

namespace carbonable_minter_instance:
    # Internals

    func deployed() -> (carbonable_minter_contract : felt):
        tempvar carbonable_minter_contract
        %{ ids.carbonable_minter_contract = context.carbonable_minter_contract %}
        return (carbonable_minter_contract)
    end

    # Views

    func project_nft_address{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (project_nft_address : felt):
        let (project_nft_address) = ICarbonableMinter.project_nft_address(carbonable_minter)
        return (project_nft_address)
    end

    func payment_token_address{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (payment_token_address : felt):
        let (payment_token_address) = ICarbonableMinter.payment_token_address(carbonable_minter)
        return (payment_token_address)
    end

    func whitelisted_sale_open{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (whitelisted_sale_open : felt):
        let (whitelisted_sale_open) = ICarbonableMinter.whitelisted_sale_open(carbonable_minter)
        return (whitelisted_sale_open)
    end

    func public_sale_open{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (public_sale_open : felt):
        let (public_sale_open) = ICarbonableMinter.public_sale_open(carbonable_minter)
        return (public_sale_open)
    end

    func max_buy_per_tx{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (max_buy_per_tx : felt):
        let (max_buy_per_tx) = ICarbonableMinter.max_buy_per_tx(carbonable_minter)
        return (max_buy_per_tx)
    end

    func unit_price{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (unit_price : Uint256):
        let (unit_price) = ICarbonableMinter.unit_price(carbonable_minter)
        return (unit_price)
    end

    func max_supply_for_mint{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (max_supply_for_mint : Uint256):
        let (max_supply_for_mint) = ICarbonableMinter.max_supply_for_mint(carbonable_minter)
        return (max_supply_for_mint)
    end

    func reserved_supply_for_mint{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }() -> (reserved_supply_for_mint : Uint256):
        let (reserved_supply_for_mint) = ICarbonableMinter.reserved_supply_for_mint(
            carbonable_minter
        )
        return (reserved_supply_for_mint)
    end

    func whitelist{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(account : felt) -> (slots : felt):
        let (slots) = ICarbonableMinter.whitelist(carbonable_minter, account)
        return (slots)
    end

    # Externals

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

    func set_max_buy_per_tx{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(max_buy_per_tx : felt, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_max_buy_per_tx(carbonable_minter, max_buy_per_tx)
        %{ stop_prank() %}
        return ()
    end

    func set_unit_price{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(unit_price : Uint256, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_unit_price(carbonable_minter, unit_price)
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

    func airdrop{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_minter : felt
    }(to : felt, quantity : felt, caller : felt) -> (success : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.airdrop(carbonable_minter, to, quantity)
        %{ stop_prank() %}
        return (success)
    end
end

namespace admin_instance:
    # Internals

    func get_address() -> (address : felt):
        tempvar admin
        %{ ids.admin = context.ADMIN %}
        return (admin)
    end

    # Externals

    func set_whitelisted_sale_open{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(whitelisted_sale_open : felt):
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (caller) = admin_instance.get_address()
        with carbonable_minter:
            carbonable_minter_instance.set_whitelisted_sale_open(
                whitelisted_sale_open=whitelisted_sale_open, caller=caller
            )
            let (returned_whitelisted_sale_open) = carbonable_minter_instance.whitelisted_sale_open(
                )
            assert returned_whitelisted_sale_open = whitelisted_sale_open
        end
        return ()
    end

    func set_public_sale_open{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        public_sale_open : felt
    ):
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (caller) = admin_instance.get_address()
        with carbonable_minter:
            carbonable_minter_instance.set_public_sale_open(
                public_sale_open=public_sale_open, caller=caller
            )
            let (returned_public_sale_open) = carbonable_minter_instance.public_sale_open()
            assert returned_public_sale_open = public_sale_open
        end
        return ()
    end

    func set_max_buy_per_tx{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        max_buy_per_tx : felt
    ):
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (caller) = admin_instance.get_address()
        with carbonable_minter:
            carbonable_minter_instance.set_max_buy_per_tx(
                max_buy_per_tx=max_buy_per_tx, caller=caller
            )
            let (returned_max_buy_per_tx) = carbonable_minter_instance.max_buy_per_tx()
            assert returned_max_buy_per_tx = max_buy_per_tx
        end
        return ()
    end

    func set_unit_price{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        unit_price : Uint256
    ):
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (caller) = admin_instance.get_address()
        with carbonable_minter:
            carbonable_minter_instance.set_unit_price(unit_price=unit_price, caller=caller)
            let (returned_unit_price) = carbonable_minter_instance.unit_price()
            assert returned_unit_price = unit_price
        end
        return ()
    end

    func add_to_whitelist{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        account : felt, slots : felt
    ):
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (caller) = admin_instance.get_address()
        with carbonable_minter:
            let (success) = carbonable_minter_instance.add_to_whitelist(
                account=account, slots=slots, caller=caller
            )
            assert success = TRUE
            let (returned_slots) = carbonable_minter_instance.whitelist(account=account)
            assert returned_slots = slots
        end
        return ()
    end

    func transferOwnership{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        newOwner : felt
    ):
        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        with project_nft:
            project_nft_instance.transferOwnership(newOwner=newOwner, caller=caller)
            let (owner) = project_nft_instance.owner()
            assert owner = newOwner
        end
        return ()
    end

    func airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, quantity : felt
    ):
        alloc_locals
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let quantity_uint256 = Uint256(quantity, 0)

        # get user nft and payment token balances to check after buy
        with project_nft:
            let (initial_quantity) = project_nft_instance.balanceOf(owner=caller)
            let (intial_total_supply) = project_nft_instance.totalSupply()
        end

        # make the user to buy the quantity
        with carbonable_minter:
            let (initial_reserved_supply) = carbonable_minter_instance.reserved_supply_for_mint()
            let (success) = carbonable_minter_instance.airdrop(
                to=to, quantity=quantity, caller=caller
            )
            assert success = TRUE
            let (expected_reserved_supply) = SafeUint256.sub_le(
                initial_reserved_supply, quantity_uint256
            )
            let (returned_reserved_supply) = carbonable_minter_instance.reserved_supply_for_mint()
            assert expected_reserved_supply = returned_reserved_supply
        end

        # check total supply and user nft quantity after buy
        with project_nft:
            let (returned_total_supply) = project_nft_instance.totalSupply()
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            )
            assert expected_total_supply = quantity_uint256

            let (returned_quantity) = project_nft_instance.balanceOf(owner=caller)
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity)
            assert expected_quantity = quantity_uint256
        end

        return ()
    end
end

namespace anyone_instance:
    # Internals

    func get_address() -> (address : felt):
        tempvar anyone
        %{ ids.anyone = context.ANYONE %}
        return (anyone)
    end

    # Externals

    func approve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        quantity : felt
    ):
        alloc_locals
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (payment_token) = payment_token_instance.deployed()
        let (caller) = anyone_instance.get_address()
        with carbonable_minter:
            let (unit_price) = carbonable_minter_instance.unit_price()
            let (allowance) = SafeUint256.mul(Uint256(quantity, 0), unit_price)
        end
        with payment_token:
            let (success) = payment_token_instance.approve(
                spender=carbonable_minter, amount=allowance, caller=caller
            )
            assert success = TRUE
            let (returned_allowance) = payment_token_instance.allowance(
                owner=caller, spender=carbonable_minter
            )
            assert returned_allowance = allowance
        end
        return ()
    end

    func buy{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(quantity : felt):
        alloc_locals
        let (carbonable_minter) = carbonable_minter_instance.deployed()
        let (project_nft) = project_nft_instance.deployed()
        let (payment_token) = payment_token_instance.deployed()
        let (caller) = anyone_instance.get_address()

        # get user nft and payment token balances to check after buy
        with project_nft:
            let (initial_quantity) = project_nft_instance.balanceOf(owner=caller)
            let (intial_total_supply) = project_nft_instance.totalSupply()
        end
        with payment_token:
            let (initial_balance) = payment_token_instance.balanceOf(account=caller)
        end

        # make the user to buy the quantity
        with carbonable_minter:
            let (unit_price) = carbonable_minter_instance.unit_price()
            let (success) = carbonable_minter_instance.buy(quantity=quantity, caller=caller)
            assert success = TRUE
        end

        # check total supply and user nft quantity after buy
        with project_nft:
            let (returned_total_supply) = project_nft_instance.totalSupply()
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            )
            assert expected_total_supply = Uint256(quantity, 0)

            let (returned_quantity) = project_nft_instance.balanceOf(owner=caller)
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity)
            assert expected_quantity = Uint256(quantity, 0)
        end

        # check user payment token balance after buy
        with payment_token:
            let (returned_balance) = payment_token_instance.balanceOf(account=caller)
            let (expected_spend) = SafeUint256.sub_le(initial_balance, returned_balance)
            let (spend) = SafeUint256.mul(Uint256(quantity, 0), unit_price)
            assert expected_spend = spend
        end
        return ()
    end
end
