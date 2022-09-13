# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

# badge dependencies
from cairopen.string.ASCII import StringCodec
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc1155.IERC1155 import IERC1155
from openzeppelin.token.erc1155.IERC1155MetadataURI import IERC1155MetadataURI

# Local dependencies
from interfaces.badge import ICarbonableBadge
from tests.library import assert_string

#
# Functions
#

func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/badge/config.yml", context)

        # ERC-721 deployment
        context.carbonable_badge_contract = deploy_contract(
            context.sources.badge,
            {
                "uri": [char for char in context.badge.uri],
                "name": context.badge.name,
                "owner": context.signers.admin,
                "owner": context.signers.admin,
            },
        ).contract_address
    %}

    return ()
end

namespace carbonable_badge_instance:
    #
    # Internals
    #

    func deployed() -> (carbonable_badge_contract : felt):
        tempvar carbonable_badge_contract
        %{ ids.carbonable_badge_contract = context.carbonable_badge_contract %}
        return (carbonable_badge_contract)
    end

    #
    # Getters
    #

    func uri{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        carbonable_badge : felt,
    }(id : Uint256) -> (uri_len : felt, uri : felt*):
        alloc_locals
        let (len, array) = ICarbonableBadge.uri(carbonable_badge, id)
        return (len, array)
    end

    func owner{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }() -> (owner : felt):
        alloc_locals
        let (owner) = ICarbonableBadge.owner(carbonable_badge)
        return (owner)
    end

    func balanceOf{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(account : felt, id : Uint256) -> (balance : Uint256):
        alloc_locals
        let (balance) = IERC1155.balanceOf(carbonable_badge, account, id)
        return (balance)
    end

    func balanceOfBatch{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(accounts_len : felt, accounts : felt*, ids_len : felt, ids : Uint256*) -> (
        balances_len : felt, balances : Uint256*
    ):
        alloc_locals
        let (balances_len, balances) = IERC1155.balanceOfBatch(
            carbonable_badge, accounts_len, accounts, ids_len, ids
        )
        return (balances_len, balances)
    end

    func isApprovedForAll{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(account : felt, operator : felt) -> (isApproved : felt):
        alloc_locals
        let (is_approved) = IERC1155.isApprovedForAll(carbonable_badge, account, operator)
        return (is_approved)
    end

    func name{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }() -> (name : felt):
        alloc_locals
        let (name) = ICarbonableBadge.name(carbonable_badge)
        return (name)
    end

    #
    # Externals
    #

    func setURI{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        carbonable_badge : felt,
    }(uri_len : felt, uri : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        ICarbonableBadge.setURI(carbonable_badge, uri_len, uri)
        %{ stop_prank() %}
        return ()
    end

    func setLocked{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(id : Uint256, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        ICarbonableBadge.setLocked(carbonable_badge, id)
        %{ stop_prank() %}
        return ()
    end

    func setUnlocked{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(id : Uint256, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        ICarbonableBadge.setUnlocked(carbonable_badge, id)
        %{ stop_prank() %}
        return ()
    end

    func setApprovalForAll{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(operator : felt, approved : felt, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        IERC1155.setApprovalForAll(carbonable_badge, operator, approved)
        %{ stop_prank() %}
        return ()
    end

    func safeTransferFrom{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(
        from_ : felt,
        to : felt,
        id : Uint256,
        amount : Uint256,
        data_len : felt,
        data : felt*,
        caller : felt,
    ):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        IERC1155.safeTransferFrom(carbonable_badge, from_, to, id, amount, data_len, data)
        %{ stop_prank() %}
        return ()
    end

    func safeBatchTransferFrom{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(
        from_ : felt,
        to : felt,
        ids_len : felt,
        ids : Uint256*,
        amounts_len : felt,
        amounts : Uint256*,
        data_len : felt,
        data : felt*,
        caller : felt,
    ):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        IERC1155.safeBatchTransferFrom(
            carbonable_badge, from_, to, ids_len, ids, amounts_len, amounts, data_len, data
        )
        %{ stop_prank() %}
        return ()
    end

    func mint{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(to : felt, id : Uint256, amount : Uint256, data_len : felt, data : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        ICarbonableBadge.mint(carbonable_badge, to, id, amount, data_len, data)
        %{ stop_prank() %}
        return ()
    end

    func mintBatch{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, carbonable_badge : felt
    }(
        to : felt,
        ids_len : felt,
        ids : Uint256*,
        amounts_len : felt,
        amounts : Uint256*,
        data_len : felt,
        data : felt*,
        caller : felt,
    ):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_badge) %}
        ICarbonableBadge.mintBatch(
            carbonable_badge, to, ids_len, ids, amounts_len, amounts, data_len, data
        )
        %{ stop_prank() %}
        return ()
    end
end

namespace admin_instance:
    # Internals

    func get_address() -> (address : felt):
        tempvar admin
        %{ ids.admin = context.signers.admin %}
        return (admin)
    end

    # Externals

    func mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, id : felt, amount : felt
    ):
        alloc_locals

        let (carbonable_badge) = carbonable_badge_instance.deployed()
        let (caller) = admin_instance.get_address()
        let id_uint256 = Uint256(id, 0)
        let amount_uint256 = Uint256(amount, 0)
        let (local data : felt*) = alloc()
        assert data[0] = 0
        let data_len = 1

        with carbonable_badge:
            let (initial_balance) = carbonable_badge_instance.balanceOf(account=to, id=id_uint256)
            %{ stop_mock = mock_call(ids.caller, "supportsInterface", [1]) %}
            carbonable_badge_instance.mint(
                to=to,
                id=id_uint256,
                amount=amount_uint256,
                data_len=data_len,
                data=data,
                caller=caller,
            )
            %{ stop_mock() %}
            let (expected_balance) = SafeUint256.add(initial_balance, amount_uint256)
            let (returned_balance) = carbonable_badge_instance.balanceOf(account=to, id=id_uint256)
            assert returned_balance = expected_balance
        end

        return ()
    end
end

namespace anyone_instance:
    # Internals

    func get_address() -> (address : felt):
        tempvar anyone
        %{ ids.anyone = context.signers.anyone %}
        return (anyone)
    end

    # Externals

    func mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        to : felt, id : felt, amount : felt
    ):
        alloc_locals

        let (carbonable_badge) = carbonable_badge_instance.deployed()
        let (caller) = anyone_instance.get_address()
        let id_uint256 = Uint256(id, 0)
        let amount_uint256 = Uint256(amount, 0)
        let (local data : felt*) = alloc()
        assert data[0] = 0
        let data_len = 1

        with carbonable_badge:
            let (initial_balance) = carbonable_badge_instance.balanceOf(account=to, id=id_uint256)
            %{ stop_mock = mock_call(ids.caller, "supportsInterface", [1]) %}
            carbonable_badge_instance.mint(
                to=to,
                id=id_uint256,
                amount=amount_uint256,
                data_len=data_len,
                data=data,
                caller=caller,
            )
            %{ stop_mock() %}
            let (expected_balance) = SafeUint256.add(initial_balance, amount_uint256)
            let (returned_balance) = carbonable_badge_instance.balanceOf(account=to, id=id_uint256)
            assert returned_balance = expected_balance
        end

        return ()
    end
end
