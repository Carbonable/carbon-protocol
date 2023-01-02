// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// badge dependencies
from cairopen.string.ASCII import StringCodec
from openzeppelin.security.safemath.library import SafeUint256
from bal7hazar.token.erc1155.IERC1155 import IERC1155
from bal7hazar.token.erc1155.IERC1155MetadataURI import IERC1155MetadataURI

// Local dependencies
from src.interfaces.badge import ICarbonableBadge
from tests.library import assert_string

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    local badge_contract_address: felt;
    local badge_minter_contract_address: felt;

    %{
        # Load the config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/badge/minter/config.yml", context)

        # Admin account deployment
        context.admin_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.admin,
            },
        ).contract_address

        # Anyone account deployment
        context.anyone_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.anyone,
            },
        ).contract_address

        # Deploy the badge contract
        context.badge.contract_address = deploy_contract(
            contract=context.sources.badge,
            constructor_args={
                "uri": [1],
                "name": 1,
                "owner": context.admin_account_contract
            },
        ).contract_address

        # Deploy the minter contract
        context.badge_minter.class_hash = declare(
            contract=context.sources.badge_minter
        ).class_hash
        context.badge_minter.contract_address = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.badge_minter.class_hash,
                "selector": context.selector.initializer,
                "calldata": {
                    "owner": context.admin_account_contract,
                    "signer_key": context.badge_minter.public_key,
                    "carbonable_badge_contract_address": context.badge.contract_address,
                    "proxy_admin": 0
                }.values()
            },
        ).contract_address
    %}

    // Transfer ownership of the badge contract to the minter contract
    %{ 
        stop_prank_callable = start_prank(context.admin_account_contract, target_contract_address=context.badge.contract_address)
        ids.badge_contract_address = context.badge.contract_address
        ids.badge_minter_contract_address = context.badge_minter.contract_address
    %}
    ICarbonableBadge.transferOwnership(badge_contract_address, badge_minter_contract_address);
    %{ stop_prank_callable() %}

    return ();
}