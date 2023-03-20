// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.libs.project import instance as carbonable_project_instance
from tests.integrations.libs.token import instance as payment_token_instance
from tests.integrations.libs.minter import instance as carbonable_minter_instance
from tests.integrations.libs.vester import instance as carbonable_vester_instance
from tests.integrations.libs.offseter import instance as carbonable_offseter_instance
from tests.integrations.libs.yielder import instance as carbonable_yielder_instance
from tests.integrations.libs.admin import instance as admin_instance
from tests.integrations.libs.anyone import instance as anyone_instance
from tests.integrations.libs.certifier import instance as certifier_instance
from tests.integrations.libs.snapshoter import instance as snapshoter_instance
from tests.integrations.libs.withdrawer import instance as withdrawer_instance

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local slot;
    local merkle_root;
    local ton_equivalent;
    local times_len;
    let (local times: felt*) = alloc();
    local absorptions_len;
    let (local absorptions: felt*) = alloc();
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load, MerkleTree
        load("./tests/integrations/config.yml", context)

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

        # Certifier account deployment
        context.certifier_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.certifier,
            },
        ).contract_address

        # Withdrawer account deployment
        context.withdrawer_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.withdrawer,
            },
        ).contract_address

        # Snapshoter account deployment
        context.snapshoter_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.snapshoter,
            },
        ).contract_address

        # Payment token deployment
        context.payment_token_contract = deploy_contract(
            contract=context.sources.token,
            constructor_args={
                "name": context.token.name,
                "symbol": context.token.symbol,
                "decimals": context.token.decimals,
                "initial_supply": context.token.initial_supply,
                "recipient": context.anyone_account_contract
            },
        ).contract_address

        # Carbonable project deployment
        context.carbonable_project_class_hash = declare(contract=context.sources.project).class_hash
        calldata = {
            "name": context.project.name,
            "symbol": context.project.symbol,
            "decimals": context.project.decimals,
            "receiver": context.admin_account_contract,
            "fee_numerator": context.project.fee_numerator,
            "fee_denominator": context.project.fee_denominator,
            "owner": context.admin_account_contract,
        }
        context.carbonable_project_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_project_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable minter deployment
        context.carbonable_minter_class_hash = declare(contract=context.sources.minter).class_hash
        calldata = {
            "carbonable_project_address": context.carbonable_project_contract,
            "carbonable_project_slot_low": context.project.slot,
            "carbonable_project_slot_high": 0,
            "payment_token_address": context.payment_token_contract,
            "public_sale_open": context.minter.public_sale_open,
            "max_value_per_tx": context.minter.max_value_per_tx,
            "min_value_per_tx": context.minter.min_value_per_tx,
            "max_value": context.minter.max_value,
            "unit_price": context.minter.unit_price,
            "reserved_value": context.minter.reserved_value,
            "owner": context.admin_account_contract,
        }
        context.carbonable_minter_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_minter_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable offseter deployment
        context.carbonable_offseter_class_hash = declare(contract=context.sources.offseter).class_hash
        calldata = {
            "carbonable_project_address": context.carbonable_project_contract,
            "carbonable_project_slot_low": context.project.slot,
            "carbonable_project_slot_high": 0,
            "min_claimable": context.absorption.ton_equivalent,
            "owner": context.admin_account_contract,
        }
        context.carbonable_offseter_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_offseter_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable vester deployment
        context.carbonable_vester_class_hash = declare(contract=context.sources.vester).class_hash
        calldata = {
            "erc20_address": context.payment_token_contract,
            "owner": context.admin_account_contract,
        }
        context.carbonable_vester_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_vester_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable yielder deployment
        context.carbonable_yielder_class_hash = declare(contract=context.sources.yielder).class_hash
        calldata = {
            "carbonable_project_address": context.carbonable_project_contract,
            "carbonable_project_slot_low": context.project.slot,
            "carbonable_project_slot_high": 0,
            "carbonable_offseter_address": context.carbonable_offseter_contract,
            "carbonable_vester_address": context.carbonable_vester_contract,
            "owner": context.admin_account_contract,
        }
        context.carbonable_yielder_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_yielder_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Build merkle tree
        recipients = [context.anyone_account_contract, context.admin_account_contract]
        allocations = [5, 5]
        merkle_leaves = MerkleTree.get_leaves(recipients, allocations)
        merkle_root = MerkleTree.generate_merkle_root(merkle_leaves)
        merkle_proofs = [
            MerkleTree.generate_merkle_proof(merkle_leaves, index)
            for index, _ in enumerate(recipients)
        ]

        # Externalize required variables
        ids.merkle_root = merkle_root
        context.whitelist = dict(
            merkle_root=merkle_root,
            merkle_proofs=merkle_proofs,
            allocations=allocations,
            recipients=recipients,
        )
        ids.ton_equivalent = context.absorption.ton_equivalent
        ids.times_len = len(context.absorption.times)
        for idx, time in enumerate(context.absorption.times):
            memory[ids.times + idx] = time
        ids.absorptions_len = len(context.absorption.values)
        for idx, value in enumerate(context.absorption.values):
            memory[ids.absorptions + idx] = value
        ids.slot = context.project.slot
    %}
    // Get protocol addresses
    let (local admin_address) = admin_instance.get_address();
    let (local certifier_address) = certifier_instance.get_address();
    let (local withdrawer_address) = withdrawer_instance.get_address();
    let (local snapshoter_address) = snapshoter_instance.get_address();
    let (local carbonable_minter) = carbonable_minter_instance.get_address();
    let (local carbonable_yielder) = carbonable_yielder_instance.get_address();

    // Setup Access control
    admin_instance.add_minter(slot, carbonable_minter);
    admin_instance.set_certifier(slot, certifier_address);
    admin_instance.set_withdrawer(withdrawer_address);
    admin_instance.set_snapshoter(snapshoter_address);
    admin_instance.add_vester(carbonable_yielder);

    // Set absorptions
    certifier_instance.set_absorptions(
        slot=slot,
        times_len=times_len,
        times=times,
        absorptions_len=absorptions_len,
        absorptions=absorptions,
        ton_equivalent=ton_equivalent,
    );

    // Set merkle root
    admin_instance.set_whitelist_merkle_root(merkle_root);

    // Set initial balances between users
    anyone_instance.transfer(admin_address, 500000);

    return ();
}
