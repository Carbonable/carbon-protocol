// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from starkware.cairo.common.math import assert_not_zero, assert_not_equal

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from src.interfaces.minter import ICarbonableMinter
from src.interfaces.offseter import ICarbonableOffseter
from src.interfaces.project import ICarbonableProject
from src.interfaces.yielder import ICarbonableYielder
from src.interfaces.starkvest import IStarkVest

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local merkle_root;
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load, MerkleTree
        load("./tests/integrations/minter/config.yml", context)

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
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
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
            "payment_token_address": context.payment_token_contract,
            "public_sale_open": context.minter.public_sale_open,
            "max_buy_per_tx": context.minter.max_buy_per_tx,
            "unit_price_low": context.minter.unit_price,
            "unit_price_high": 0,
            "max_supply_for_mint_low": context.minter.max_supply_for_mint,
            "max_supply_for_mint_high": 0,
            "reserved_supply_for_mint_low": context.minter.reserved_supply_for_mint,
            "reserved_supply_for_mint_high": 0,
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
        }
        context.carbonable_minter_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_minter_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable Starkvest deployment
        context.carbonable_starkvest_class_hash = declare(contract=context.sources.starkvest).class_hash
        calldata = {
            "erc20_address": context.payment_token_contract,
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
        }
        context.carbonable_starkvest_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_starkvest_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable yielder deployment
        context.carbonable_yielder_class_hash = declare(contract=context.sources.yielder).class_hash
        calldata = {
            "carbonable_project_address": context.carbonable_project_contract,
            "starkvest_address": context.carbonable_starkvest_contract,
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
        }
        context.carbonable_yielder_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_yielder_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable offseter deployment
        context.carbonable_offseter_class_hash = declare(contract=context.sources.offseter).class_hash
        calldata = {
            "carbonable_project_address": context.carbonable_project_contract,
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
        }
        context.carbonable_offseter_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_offseter_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Build merkle tree
        recipients = [context.anyone_account_contract, context.admin_account_contract]
        slots = [5, 5]
        merkle_leaves = MerkleTree.get_leaves(recipients, slots)
        merkle_root = MerkleTree.generate_merkle_root(merkle_leaves)
        merkle_proofs = [
            MerkleTree.generate_merkle_proof(merkle_leaves, index)
            for index, _ in enumerate(recipients)
        ]

        # Externalize required variables
        context.whitelist = dict(
            merkle_root=merkle_root,
            merkle_proofs=merkle_proofs,
            slots=slots,
            recipients=recipients,
        )
        ids.merkle_root = merkle_root
    %}

    // Set minter and merkle root
    let (local admin_address) = admin_instance.get_address();
    let (local carbonable_minter) = carbonable_minter_instance.get_address();
    admin_instance.set_minter(admin_address);
    admin_instance.set_minter(carbonable_minter);
    admin_instance.set_whitelist_merkle_root(merkle_root);

    anyone_instance.transfer(admin_address, 500000);

    let (local carbonable_starkvest) = carbonable_starkvest_instance.get_address();
    let (local carbonable_yielder) = carbonable_yielder_instance.get_address();
    admin_instance.starkvest_transfer_ownership(carbonable_yielder);

    return ();
}

namespace carbonable_project_instance {
    // Internals

    func get_address() -> (carbonable_project_contract: felt) {
        tempvar carbonable_project_contract;
        %{ ids.carbonable_project_contract = context.carbonable_project_contract %}
        return (carbonable_project_contract,);
    }

    // Views

    func owner{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (owner: felt) {
        let (owner: felt) = ICarbonableProject.owner(carbonable_project);
        return (owner,);
    }

    func balanceOf{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(owner: felt) -> (balance: Uint256) {
        let (balance) = IERC721.balanceOf(carbonable_project, owner);
        return (balance,);
    }

    func ownerOf{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(tokenId: Uint256) -> (owner: felt) {
        let (owner) = IERC721.ownerOf(carbonable_project, tokenId);
        return (owner,);
    }

    func totalSupply{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (totalSupply: Uint256) {
        let (total_supply) = IERC721Enumerable.totalSupply(carbonable_project);
        return (total_supply,);
    }

    // Externals

    func set_minter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(minter: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_minter(carbonable_project, minter);
        %{ stop_prank() %}
        return ();
    }

    func approve{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(approved: felt, token_id: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        IERC721.approve(carbonable_project, approved, token_id);
        %{ stop_prank() %}
        return ();
    }

    func mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(to: felt, token_id: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.mint(carbonable_project, to, token_id);
        %{ stop_prank() %}
        return ();
    }
}

namespace carbonable_starkvest_instance {
    // Internals

    func get_address() -> (carbonable_starkvest_contract: felt) {
        tempvar carbonable_starkvest_contract;
        %{ ids.carbonable_starkvest_contract = context.carbonable_starkvest_contract %}
        return (carbonable_starkvest_contract,);
    }

    // Views

    func withdrawable_amount{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_starkvest: felt
    }(caller: felt) -> (releasable_amount: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_starkvest) %}
        let (releasable_amount) = IStarkVest.withdrawable_amount(carbonable_starkvest);
        %{ stop_prank() %}
        return (releasable_amount,);
    }

    func vesting_count{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_starkvest: felt
    }(caller: felt) -> (vesting_count: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_starkvest) %}
        let (vesting_count) = IStarkVest.vesting_count(carbonable_starkvest, caller);
        %{ stop_prank() %}
        return (vesting_count,);
    }

    func get_vesting_id{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_starkvest: felt
    }(vesting_index: felt, caller: felt) -> (vesting_id: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_starkvest) %}
        let (vesting_id) = IStarkVest.get_vesting_id(carbonable_starkvest, caller, vesting_index);
        %{ stop_prank() %}
        return (vesting_id,);
    }

    func releasable_amount{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_starkvest: felt
    }(vesting_id: felt, caller: felt) -> (releasable_amount: Uint256) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_starkvest) %}
        let (releasable_amount) = IStarkVest.releasable_amount(carbonable_starkvest, vesting_id);
        %{ stop_prank() %}
        return (releasable_amount=releasable_amount,);
    }

    // Externals

    func transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_starkvest: felt
    }(newOwner: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_starkvest) %}
        IStarkVest.transferOwnership(carbonable_starkvest, newOwner);
        %{ stop_prank() %}
        return ();
    }

    func create_vesting{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_starkvest: felt
    }(
        beneficiary: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        amount_total: Uint256,
        caller: felt,
    ) -> (vesting_id: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_starkvest) %}
        let (vesting_id) = IStarkVest.create_vesting(
            carbonable_starkvest,
            beneficiary,
            cliff_delta,
            start,
            duration,
            slice_period_seconds,
            revocable,
            amount_total,
        );
        %{ stop_prank() %}
        return (vesting_id,);
    }
}

namespace payment_token_instance {
    // Internals

    func get_address() -> (payment_token_contract: felt) {
        tempvar payment_token_contract;
        %{ ids.payment_token_contract = context.payment_token_contract %}
        return (payment_token_contract,);
    }

    // Views

    func balanceOf{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, payment_token: felt
    }(account: felt) -> (balance: Uint256) {
        let (balance) = IERC20.balanceOf(payment_token, account);
        return (balance,);
    }

    func allowance{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, payment_token: felt
    }(owner: felt, spender: felt) -> (remaining: Uint256) {
        let (remaining) = IERC20.allowance(payment_token, owner, spender);
        return (remaining,);
    }

    // Externals

    func approve{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, payment_token: felt
    }(spender: felt, amount: Uint256, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(ids.caller, ids.payment_token) %}
        let (success) = IERC20.approve(payment_token, spender, amount);
        %{ stop_prank() %}
        return (success,);
    }

    func transfer{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, payment_token: felt
    }(recipient: felt, amount: Uint256, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(ids.caller, ids.payment_token) %}
        let (success) = IERC20.transfer(payment_token, recipient, amount);
        %{ stop_prank() %}
        return (success,);
    }
}

namespace carbonable_minter_instance {
    // Internals

    func get_address() -> (carbonable_minter_contract: felt) {
        tempvar carbonable_minter_contract;
        %{ ids.carbonable_minter_contract = context.carbonable_minter_contract %}
        return (carbonable_minter_contract,);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableMinter.carbonable_project_address(
            carbonable_minter
        );
        return (carbonable_project_address,);
    }

    func payment_token_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (payment_token_address: felt) {
        let (payment_token_address) = ICarbonableMinter.payment_token_address(carbonable_minter);
        return (payment_token_address,);
    }

    func whitelisted_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (whitelisted_sale_open: felt) {
        let (whitelisted_sale_open) = ICarbonableMinter.whitelisted_sale_open(carbonable_minter);
        return (whitelisted_sale_open,);
    }

    func public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (public_sale_open: felt) {
        let (public_sale_open) = ICarbonableMinter.public_sale_open(carbonable_minter);
        return (public_sale_open,);
    }

    func max_buy_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (max_buy_per_tx: felt) {
        let (max_buy_per_tx) = ICarbonableMinter.max_buy_per_tx(carbonable_minter);
        return (max_buy_per_tx,);
    }

    func unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (unit_price: Uint256) {
        let (unit_price) = ICarbonableMinter.unit_price(carbonable_minter);
        return (unit_price,);
    }

    func max_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (max_supply_for_mint: Uint256) {
        let (max_supply_for_mint) = ICarbonableMinter.max_supply_for_mint(carbonable_minter);
        return (max_supply_for_mint,);
    }

    func reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (reserved_supply_for_mint: Uint256) {
        let (reserved_supply_for_mint) = ICarbonableMinter.reserved_supply_for_mint(
            carbonable_minter
        );
        return (reserved_supply_for_mint,);
    }

    func whitelist_merkle_root{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (whitelist_merkle_root: felt) {
        let (whitelist_merkle_root) = ICarbonableMinter.whitelist_merkle_root(carbonable_minter);
        return (whitelist_merkle_root,);
    }

    func whitelisted_slots{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(account: felt, slots: felt, proof_len: felt, proof: felt*) -> (slots: felt) {
        let (slots) = ICarbonableMinter.whitelisted_slots(
            carbonable_minter, account, slots, proof_len, proof
        );
        return (slots,);
    }

    func claimed_slots{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(account: felt) -> (slots: felt) {
        let (slots) = ICarbonableMinter.claimed_slots(carbonable_minter, account);
        return (slots=slots,);
    }

    func sold_out{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }() -> (status: felt) {
        let (status) = ICarbonableMinter.sold_out(carbonable_minter);
        return (status=status,);
    }

    // Externals

    func decrease_reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(slots: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.decrease_reserved_supply_for_mint(carbonable_minter, slots);
        %{ stop_prank() %}
        return ();
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.withdraw(carbonable_minter);
        %{ stop_prank() %}
        return (success,);
    }

    func set_whitelist_merkle_root{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(whitelist_merkle_root: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_whitelist_merkle_root(carbonable_minter, whitelist_merkle_root);
        %{ stop_prank() %}
        return ();
    }

    func set_public_sale_open{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(public_sale_open: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_public_sale_open(carbonable_minter, public_sale_open);
        %{ stop_prank() %}
        return ();
    }

    func set_max_buy_per_tx{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(max_buy_per_tx: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_max_buy_per_tx(carbonable_minter, max_buy_per_tx);
        %{ stop_prank() %}
        return ();
    }

    func set_unit_price{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(unit_price: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        ICarbonableMinter.set_unit_price(carbonable_minter, unit_price);
        %{ stop_prank() %}
        return ();
    }

    func whitelist_buy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(slots: felt, proof_len: felt, proof: felt*, quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.whitelist_buy(
            carbonable_minter, slots, proof_len, proof, quantity
        );
        %{ stop_prank() %}
        return (success,);
    }

    func public_buy{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.public_buy(carbonable_minter, quantity);
        %{ stop_prank() %}
        return (success,);
    }

    func airdrop{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_minter: felt
    }(to: felt, quantity: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_minter) %}
        let (success) = ICarbonableMinter.airdrop(carbonable_minter, to, quantity);
        %{ stop_prank() %}
        return (success,);
    }
}

namespace carbonable_offseter_instance {
    // Internals

    func get_address() -> (carbonable_offseter_contract: felt) {
        tempvar carbonable_offseter_contract;
        %{ ids.carbonable_offseter_contract = context.carbonable_offseter_contract %}
        return (carbonable_offseter_contract=carbonable_offseter_contract,);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableOffseter.carbonable_project_address(
            carbonable_offseter
        );
        return (carbonable_project_address=carbonable_project_address,);
    }

    func is_locked{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (status: felt) {
        let (status) = ICarbonableOffseter.is_locked(carbonable_offseter);
        return (status=status,);
    }

    func total_offsetable{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (total_offsetable: Uint256) {
        let (total_offsetable) = ICarbonableOffseter.total_offsetable(
            contract_address=carbonable_offseter, address=address
        );
        return (total_offsetable=total_offsetable,);
    }

    func total_offseted{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (total_offseted: Uint256) {
        let (total_offseted) = ICarbonableOffseter.total_offseted(
            contract_address=carbonable_offseter, address=address
        );
        return (total_offseted=total_offseted,);
    }

    func total_locked{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (balance: Uint256) {
        let (balance) = ICarbonableOffseter.total_locked(carbonable_offseter);
        return (balance=balance,);
    }

    func balance_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (balance: felt) {
        let (balance) = ICarbonableOffseter.balance_of(carbonable_offseter, address);
        return (balance=balance,);
    }

    func registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256) -> (address: felt) {
        let (address) = ICarbonableOffseter.registred_owner_of(carbonable_offseter, token_id);
        return (address=address,);
    }

    // Externals

    func offset{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.offset(contract_address=carbonable_offseter);
        %{ stop_prank() %}
        return (success=success,);
    }

    func snapshot{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.snapshot(contract_address=carbonable_offseter);
        %{ stop_prank() %}
        return (success=success,);
    }

    func start_period{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(unlocked_duration: felt, period_duration: felt, absorption: felt, caller: felt) -> (
        success: felt
    ) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.start_period(
            carbonable_offseter, unlocked_duration, period_duration, absorption
        );
        %{ stop_prank() %}
        return (success=success,);
    }

    func stop_period{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.stop_period(carbonable_offseter);
        %{ stop_prank() %}
        return (success=success,);
    }

    func deposit{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256, caller: felt, carbonable_project: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_offseter, target_contract_address=ids.carbonable_project) %}
        let (success) = ICarbonableOffseter.deposit(carbonable_offseter, token_id);
        %{ stop_prank_offseter() %}
        %{ stop_prank_project() %}
        return (success=success,);
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256, caller: felt, carbonable_project: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_offseter, target_contract_address=ids.carbonable_project) %}
        let (success) = ICarbonableOffseter.withdraw(carbonable_offseter, token_id);
        %{ stop_prank_offseter() %}
        %{ stop_prank_project() %}
        return (success=success,);
    }
}

namespace carbonable_yielder_instance {
    // Internals

    func get_address() -> (carbonable_yielder_contract: felt) {
        tempvar carbonable_yielder_contract;
        %{ ids.carbonable_yielder_contract = context.carbonable_yielder_contract %}
        return (carbonable_yielder_contract=carbonable_yielder_contract,);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableYielder.carbonable_project_address(
            carbonable_yielder
        );
        return (carbonable_project_address=carbonable_project_address,);
    }

    func is_locked{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (status: felt) {
        let (status) = ICarbonableYielder.is_locked(carbonable_yielder);
        return (status=status,);
    }

    func total_locked{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }() -> (balance: Uint256) {
        let (balance) = ICarbonableYielder.total_locked(carbonable_yielder);
        return (balance=balance,);
    }

    func shares_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(address: felt, precision: felt) -> (shares: Uint256) {
        let (shares) = ICarbonableYielder.shares_of(carbonable_yielder, address, precision);
        return (shares=shares,);
    }

    func registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256) -> (address: felt) {
        let (address) = ICarbonableYielder.registred_owner_of(carbonable_yielder, token_id);
        return (address=address,);
    }

    // Externals

    func start_period{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(unlocked_duration: felt, period_duration: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (success) = ICarbonableYielder.start_period(
            carbonable_yielder, unlocked_duration, period_duration
        );
        %{ stop_prank() %}
        return (success=success,);
    }

    func stop_period{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        let (success) = ICarbonableYielder.stop_period(carbonable_yielder);
        %{ stop_prank() %}
        return (success=success,);
    }

    func deposit{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256, caller: felt, carbonable_project: felt) -> (success: felt) {
        %{ stop_prank_yielder = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_yielder, target_contract_address=ids.carbonable_project) %}
        let (success) = ICarbonableYielder.deposit(carbonable_yielder, token_id);
        %{ stop_prank_yielder() %}
        %{ stop_prank_project() %}
        return (success=success,);
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(token_id: Uint256, caller: felt, carbonable_project: felt) -> (success: felt) {
        %{ stop_prank_yielder = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_yielder, target_contract_address=ids.carbonable_project) %}
        let (success) = ICarbonableYielder.withdraw(carbonable_yielder, token_id);
        %{ stop_prank_yielder() %}
        %{ stop_prank_project() %}
        return (success=success,);
    }

    func create_vestings{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_yielder: felt
    }(
        caller: felt,
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
        carbonable_project: felt,
        carbonable_starkvest: felt,
    ) -> (success: felt) {
        %{ stop_prank_yielder = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_yielder) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_yielder, target_contract_address=ids.carbonable_project) %}
        %{ stop_prank_starkves = start_prank(caller_address=ids.carbonable_yielder, target_contract_address=ids.carbonable_starkvest) %}

        let (success) = ICarbonableYielder.create_vestings(
            carbonable_yielder,
            total_amount,
            cliff_delta,
            start,
            duration,
            slice_period_seconds,
            revocable,
        );

        %{ stop_prank_yielder() %}
        %{ stop_prank_project() %}
        %{ stop_prank_starkves() %}
        return (success=success,);
    }
}

namespace admin_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.admin_account_contract %}
        return (address,);
    }

    // Token

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: felt
    ) {
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        let amount_uint256 = Uint256(low=amount, high=0);
        with payment_token {
            let (success) = payment_token_instance.transfer(
                recipient=recipient, amount=amount_uint256, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    // Starkvest

    func starkvest_transfer_ownership{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(newOwner: felt) {
        let (carbonable_starkvest) = carbonable_starkvest_instance.get_address();
        let (caller) = get_address();
        with carbonable_starkvest {
            carbonable_starkvest_instance.transfer_ownership(newOwner=newOwner, caller=caller);
        }
        return ();
    }

    func create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (carbonable_starkvest) = carbonable_starkvest_instance.get_address();
        let (caller) = get_address();

        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.create_vestings(
                caller=caller,
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                carbonable_project=carbonable_project,
                carbonable_starkvest=carbonable_starkvest,
            );
            assert success = TRUE;
        }
        return ();
    }

    // Project

    func owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (owner: felt) {
        let (carbonable_project) = carbonable_project_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
        }
        return (owner=owner,);
    }

    func project_approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.approve(
                approved=approved, token_id=token_id_uint256, caller=caller
            );
        }
        return ();
    }

    // Minter

    func sold_out{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        with carbonable_minter {
            let (status) = carbonable_minter_instance.sold_out();
        }
        return (status=status,);
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        with payment_token {
            let (initial_balance) = payment_token_instance.balanceOf(account=caller);
            let (contract_balance) = payment_token_instance.balanceOf(account=carbonable_minter);
        }
        with carbonable_minter {
            let (success) = carbonable_minter_instance.withdraw(caller=caller);
            assert success = TRUE;
        }
        with payment_token {
            let (returned_balance) = payment_token_instance.balanceOf(account=caller);
            let (expected_balance) = SafeUint256.add(initial_balance, contract_balance);
            assert returned_balance = expected_balance;
        }
        return ();
    }

    func set_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        whitelist_merkle_root: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_whitelist_merkle_root(
                whitelist_merkle_root=whitelist_merkle_root, caller=caller
            );
            let (returned_whitelist_merkle_root) = carbonable_minter_instance.whitelist_merkle_root(
                );
            assert returned_whitelist_merkle_root = whitelist_merkle_root;
        }
        return ();
    }

    func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        public_sale_open: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_public_sale_open(
                public_sale_open=public_sale_open, caller=caller
            );
            let (returned_public_sale_open) = carbonable_minter_instance.public_sale_open();
            assert returned_public_sale_open = public_sale_open;
        }
        return ();
    }

    func set_max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        max_buy_per_tx: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_max_buy_per_tx(
                max_buy_per_tx=max_buy_per_tx, caller=caller
            );
            let (returned_max_buy_per_tx) = carbonable_minter_instance.max_buy_per_tx();
            assert returned_max_buy_per_tx = max_buy_per_tx;
        }
        return ();
    }

    func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unit_price: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        let unit_price_uint256 = Uint256(unit_price, 0);
        with carbonable_minter {
            carbonable_minter_instance.set_unit_price(unit_price=unit_price_uint256, caller=caller);
            let (returned_unit_price) = carbonable_minter_instance.unit_price();
            assert returned_unit_price = unit_price_uint256;
        }
        return ();
    }

    func decrease_reserved_supply_for_mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(slots: felt) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        let slots_uint256 = Uint256(slots, 0);
        with carbonable_minter {
            let (initial_supply) = carbonable_minter_instance.reserved_supply_for_mint();
            carbonable_minter_instance.decrease_reserved_supply_for_mint(
                slots=slots_uint256, caller=caller
            );
            let (returned_supply) = carbonable_minter_instance.reserved_supply_for_mint();
            let (expected_supply) = SafeUint256.sub_le(initial_supply, slots_uint256);
            assert returned_supply = expected_supply;
        }
        return ();
    }

    func set_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(minter: felt) {
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        with carbonable_project {
            carbonable_project_instance.set_minter(minter=minter, caller=caller);
        }
        return ();
    }

    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.mint(to=to, token_id=token_id_uint256, caller=caller);
        }
        return ();
    }

    func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, quantity: felt
    ) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let quantity_uint256 = Uint256(quantity, 0);

        // get user nft and payment token balances to check after buy
        with carbonable_project {
            let (initial_quantity) = carbonable_project_instance.balanceOf(owner=to);
            let (intial_total_supply) = carbonable_project_instance.totalSupply();
        }

        // make the user to buy the quantity
        with carbonable_minter {
            let (initial_reserved_supply) = carbonable_minter_instance.reserved_supply_for_mint();
            let (success) = carbonable_minter_instance.airdrop(
                to=to, quantity=quantity, caller=caller
            );
            assert success = TRUE;
            let (expected_reserved_supply) = SafeUint256.sub_le(
                initial_reserved_supply, quantity_uint256
            );
            let (returned_reserved_supply) = carbonable_minter_instance.reserved_supply_for_mint();
            assert expected_reserved_supply = returned_reserved_supply;
        }

        // check total supply and user nft quantity after buy
        with carbonable_project {
            let (returned_total_supply) = carbonable_project_instance.totalSupply();
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            );
            assert expected_total_supply = quantity_uint256;

            let (returned_quantity) = carbonable_project_instance.balanceOf(owner=to);
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity);
            assert expected_quantity = quantity_uint256;
        }

        return ();
    }

    // Offseter

    func offseter_is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (status) = carbonable_offseter_instance.is_locked();
        }
        return (status=status,);
    }

    func total_offsetable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (total_offsetable: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (total_offsetable) = carbonable_offseter_instance.total_offsetable(address=address);
        }
        return (total_offsetable=total_offsetable.low,);
    }

    func total_offseted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (total_offseted: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (total_offseted) = carbonable_offseter_instance.total_offseted(address=address);
        }
        return (total_offseted=total_offseted.low,);
    }

    func offseter_total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (balance: Uint256) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.total_locked();
        }
        return (balance=balance,);
    }

    func offseter_balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (balance: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.balance_of(address=address);
        }
        return (balance=balance,);
    }

    func offseter_registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_offseter {
            let (address) = carbonable_offseter_instance.registred_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address,);
    }

    func offset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.offset(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.snapshot(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func offseter_start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt, absorption: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.start_period(
                unlocked_duration=unlocked_duration,
                period_duration=period_duration,
                absorption=absorption,
                caller=caller,
            );
            assert success = TRUE;
        }
        return ();
    }

    func offseter_stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.stop_period(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func offseter_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.deposit(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        return ();
    }

    func offseter_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.withdraw(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }

    // Yielder

    func yielder_is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (status) = carbonable_yielder_instance.is_locked();
        }
        return (status=status,);
    }

    func yielder_total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (balance: Uint256) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (balance) = carbonable_yielder_instance.total_locked();
        }
        return (balance=balance,);
    }

    func yielder_shares_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt, precision: felt
    ) -> (shares: Uint256) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (shares) = carbonable_yielder_instance.shares_of(
                address=address, precision=precision
            );
        }
        return (shares=shares,);
    }

    func yielder_registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (address: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_yielder {
            let (address) = carbonable_yielder_instance.registred_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address,);
    }

    func yielder_start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (caller) = get_address();
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.start_period(
                unlocked_duration=unlocked_duration, period_duration=period_duration, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    func yielder_stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (caller) = get_address();
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.stop_period(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func yielder_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.deposit(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_yielder;
        }
        return ();
    }

    func yielder_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_yielder;
        }
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.withdraw(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }
}

namespace anyone_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar address;
        %{ ids.address = context.anyone_account_contract %}
        return (address,);
    }

    func get_slots() -> (slots: felt) {
        let (address) = get_address();
        tempvar slots;
        %{
            index = context.whitelist["recipients"].index(ids.address)
            ids.slots = context.whitelist["slots"][index]
        %}
        return (slots,);
    }

    func get_proof_len() -> (proof_len: felt) {
        let (address) = get_address();
        tempvar proof_len;
        %{
            index = context.whitelist["recipients"].index(ids.address)
            ids.proof_len = len(context.whitelist["merkle_proofs"][index])
        %}
        return (proof_len,);
    }

    func get_proof() -> (proof: felt*) {
        alloc_locals;
        let (address) = get_address();
        let (local proof: felt*) = alloc();
        %{
            index = context.whitelist["recipients"].index(ids.address)
            merkle_proof = context.whitelist["merkle_proofs"][index]
            for idx, node in enumerate(merkle_proof):
                memory[ids.proof + idx] = node
        %}
        return (proof,);
    }

    // Project

    func project_approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.approve(
                approved=approved, token_id=token_id_uint256, caller=caller
            );
        }
        return ();
    }

    // Token

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            let (unit_price) = carbonable_minter_instance.unit_price();
            let (allowance) = SafeUint256.mul(Uint256(quantity, 0), unit_price);
        }
        with payment_token {
            let (success) = payment_token_instance.approve(
                spender=carbonable_minter, amount=allowance, caller=caller
            );
            assert success = TRUE;
            let (returned_allowance) = payment_token_instance.allowance(
                owner=caller, spender=carbonable_minter
            );
            assert returned_allowance = allowance;
        }
        return ();
    }

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: felt
    ) {
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        let amount_uint256 = Uint256(low=amount, high=0);
        with payment_token {
            let (success) = payment_token_instance.transfer(
                recipient=recipient, amount=amount_uint256, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    // Minter

    func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        public_sale_open: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_public_sale_open(
                public_sale_open=public_sale_open, caller=caller
            );
            let (returned_public_sale_open) = carbonable_minter_instance.public_sale_open();
            assert returned_public_sale_open = public_sale_open;
        }
        return ();
    }

    func set_max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        max_buy_per_tx: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        with carbonable_minter {
            carbonable_minter_instance.set_max_buy_per_tx(
                max_buy_per_tx=max_buy_per_tx, caller=caller
            );
            let (returned_max_buy_per_tx) = carbonable_minter_instance.max_buy_per_tx();
            assert returned_max_buy_per_tx = max_buy_per_tx;
        }
        return ();
    }

    func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unit_price: felt
    ) {
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (caller) = get_address();
        let unit_price_uint256 = Uint256(unit_price, 0);
        with carbonable_minter {
            carbonable_minter_instance.set_unit_price(unit_price=unit_price_uint256, caller=caller);
            let (returned_unit_price) = carbonable_minter_instance.unit_price();
            assert returned_unit_price = unit_price_uint256;
        }
        return ();
    }

    func whitelist_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();
        let (slots) = get_slots();
        let (proof_len) = get_proof_len();
        let (proof) = get_proof();

        // get user nft and payment token balances to check after buy
        with carbonable_project {
            let (initial_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (intial_total_supply) = carbonable_project_instance.totalSupply();
        }
        with payment_token {
            let (initial_balance) = payment_token_instance.balanceOf(account=caller);
        }

        // make the user to buy the quantity
        with carbonable_minter {
            let (whitelist_merkle_root) = carbonable_minter_instance.whitelist_merkle_root();
            let (unit_price) = carbonable_minter_instance.unit_price();
            let (success) = carbonable_minter_instance.whitelist_buy(
                slots=slots, proof_len=proof_len, proof=proof, quantity=quantity, caller=caller
            );
            assert success = TRUE;
        }

        // check total supply and user nft quantity after buy
        with carbonable_project {
            let (returned_total_supply) = carbonable_project_instance.totalSupply();
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            );
            assert expected_total_supply = Uint256(quantity, 0);

            let (returned_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity);
            assert expected_quantity = Uint256(quantity, 0);
        }

        // check user payment token balance after buy
        with payment_token {
            let (returned_balance) = payment_token_instance.balanceOf(account=caller);
            let (expected_spend) = SafeUint256.sub_le(initial_balance, returned_balance);
            let (spend) = SafeUint256.mul(Uint256(quantity, 0), unit_price);
            assert expected_spend = spend;
        }
        return ();
    }

    func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        quantity: felt
    ) {
        alloc_locals;
        let (carbonable_minter) = carbonable_minter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (payment_token) = payment_token_instance.get_address();
        let (caller) = get_address();

        // get user nft and payment token balances to check after buy
        with carbonable_project {
            let (initial_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (intial_total_supply) = carbonable_project_instance.totalSupply();
        }
        with payment_token {
            let (initial_balance) = payment_token_instance.balanceOf(account=caller);
        }

        // make the user to buy the quantity
        with carbonable_minter {
            let (unit_price) = carbonable_minter_instance.unit_price();
            let (success) = carbonable_minter_instance.public_buy(quantity=quantity, caller=caller);
            assert success = TRUE;
        }

        // check total supply and user nft quantity after buy
        with carbonable_project {
            let (returned_total_supply) = carbonable_project_instance.totalSupply();
            let (expected_total_supply) = SafeUint256.sub_le(
                returned_total_supply, intial_total_supply
            );
            assert expected_total_supply = Uint256(quantity, 0);

            let (returned_quantity) = carbonable_project_instance.balanceOf(owner=caller);
            let (expected_quantity) = SafeUint256.sub_le(returned_quantity, initial_quantity);
            assert expected_quantity = Uint256(quantity, 0);
        }

        // check user payment token balance after buy
        with payment_token {
            let (returned_balance) = payment_token_instance.balanceOf(account=caller);
            let (expected_spend) = SafeUint256.sub_le(initial_balance, returned_balance);
            let (spend) = SafeUint256.mul(Uint256(quantity, 0), unit_price);
            assert expected_spend = spend;
        }
        return ();
    }

    // Offseter

    func offseter_is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (status) = carbonable_offseter_instance.is_locked();
        }
        return (status=status,);
    }

    func total_offsetable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (total_offsetable: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (total_offsetable) = carbonable_offseter_instance.total_offsetable(address=address);
        }
        return (total_offsetable=total_offsetable.low,);
    }

    func total_offseted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (total_offseted: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (total_offseted) = carbonable_offseter_instance.total_offseted(address=address);
        }
        return (total_offseted=total_offseted.low,);
    }

    func offseter_total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (balance: Uint256) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.total_locked();
        }
        return (balance=balance,);
    }

    func offseter_balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (balance: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.balance_of(address=address);
        }
        return (balance=balance,);
    }

    func offseter_registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_offseter {
            let (address) = carbonable_offseter_instance.registred_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address,);
    }

    func offset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.offset(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.snapshot(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func offseter_start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt, absorption: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.start_period(
                unlocked_duration=unlocked_duration,
                period_duration=period_duration,
                absorption=absorption,
                caller=caller,
            );
            assert success = TRUE;
        }
        return ();
    }

    func offseter_stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.stop_period(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func offseter_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.deposit(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        return ();
    }

    func offseter_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.withdraw(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }

    // Yielder

    func yielder_is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (status) = carbonable_yielder_instance.is_locked();
        }
        return (status=status,);
    }

    func yielder_total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (balance: Uint256) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (balance) = carbonable_yielder_instance.total_locked();
        }
        return (balance=balance,);
    }

    func yielder_shares_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt, precision: felt
    ) -> (shares: Uint256) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        with carbonable_yielder {
            let (shares) = carbonable_yielder_instance.shares_of(
                address=address, precision=precision
            );
        }
        return (shares=shares,);
    }

    func yielder_registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }(token_id: felt) -> (address: felt) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_yielder {
            let (address) = carbonable_yielder_instance.registred_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address,);
    }

    func yielder_start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (caller) = get_address();
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.start_period(
                unlocked_duration=unlocked_duration, period_duration=period_duration, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    func yielder_stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (caller) = get_address();
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.stop_period(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func yielder_deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.deposit(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_yielder;
        }
        return ();
    }

    func yielder_withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_yielder;
        }
        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.withdraw(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }

    func create_vestings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        total_amount: felt,
        cliff_delta: felt,
        start: felt,
        duration: felt,
        slice_period_seconds: felt,
        revocable: felt,
    ) {
        let (carbonable_yielder) = carbonable_yielder_instance.get_address();
        let (carbonable_project) = carbonable_project_instance.get_address();
        let (carbonable_starkvest) = carbonable_starkvest_instance.get_address();
        let (caller) = get_address();

        with carbonable_yielder {
            let (success) = carbonable_yielder_instance.create_vestings(
                caller=caller,
                total_amount=total_amount,
                cliff_delta=cliff_delta,
                start=start,
                duration=duration,
                slice_period_seconds=slice_period_seconds,
                revocable=revocable,
                carbonable_project=carbonable_project,
                carbonable_starkvest=carbonable_starkvest,
            );
            assert success = TRUE;
        }
        return ();
    }

    func get_vesting_id{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        vesting_id: felt
    ) {
        alloc_locals;
        let zero = Uint256(low=0, high=0);
        let (carbonable_starkvest) = carbonable_starkvest_instance.get_address();
        let (caller) = get_address();

        with carbonable_starkvest {
            let (vesting_count) = carbonable_starkvest_instance.vesting_count(caller);
            assert_not_equal(vesting_count, 0);

            let (vesting_id) = carbonable_starkvest_instance.get_vesting_id(
                vesting_count - 1, caller
            );
            assert_not_equal(vesting_id, 0);
        }
        return (vesting_id=vesting_id,);
    }

    func releasable_amount{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        vesting_id: felt
    ) -> (releasable_amount: Uint256) {
        alloc_locals;
        let zero = Uint256(low=0, high=0);
        let (carbonable_starkvest) = carbonable_starkvest_instance.get_address();
        let (caller) = get_address();

        with carbonable_starkvest {
            let (releasable_amount) = carbonable_starkvest_instance.releasable_amount(
                vesting_id, caller
            );
            let (is_zero) = uint256_eq(releasable_amount, zero);
            with_attr error_message("Testing: releasable amount cannot be zero") {
                assert is_zero = FALSE;
            }
        }

        return (releasable_amount=releasable_amount,);
    }
}
