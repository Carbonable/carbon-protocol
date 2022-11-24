// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from interfaces.minter import ICarbonableMinter
from interfaces.project import ICarbonableProject
from tests.integrations.protocol.library import (
    carbonable_project_instance,
    payment_token_instance,
    carbonable_minter_instance,
)

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
        from tests import load
        load("./tests/integrations/minter/config.yml", context)

        # Carbonable project deployment
        context.carbonable_project_class_hash = declare(contract=context.sources.project).class_hash
        calldata = {
            "name": context.project.name,
            "symbol": context.project.symbol,
            "owner": context.signers.admin,
            "proxy_admin": context.signers.admin,
        }
        context.carbonable_project_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_project_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Payment token deployment
        context.payment_token_contract = deploy_contract(
            contract=context.sources.token,
            constructor_args={
                "name": context.token.name,
                "symbol": context.token.symbol,
                "decimals": context.token.decimals,
                "initial_supply": context.token.initial_supply,
                "recipient": context.signers.anyone
            },
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
            "owner": context.signers.admin,
            "proxy_admin": context.signers.admin,
        }
        context.carbonable_minter_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_minter_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Externalize required variables
        ids.merkle_root = context.whitelist.merkle_root
    %}

    // Set minter and merkle root
    let (local carbonable_minter) = carbonable_minter_instance.get_address();
    admin_instance.set_minter(carbonable_minter);
    admin_instance.set_whitelist_merkle_root(merkle_root);

    return ();
}

namespace admin_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar admin;
        %{ ids.admin = context.signers.admin %}
        return (admin,);
    }

    // Externals

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
}

namespace anyone_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar anyone;
        %{ ids.anyone = context.signers.anyone %}
        return (anyone,);
    }

    func get_slots() -> (slots: felt) {
        tempvar slots;
        %{ ids.slots = context.whitelist.slots %}
        return (slots,);
    }

    func get_proof_len() -> (proof_len: felt) {
        tempvar proof_len;
        %{ ids.proof_len = context.whitelist.merkle_proof_len %}
        return (proof_len,);
    }

    func get_proof() -> (proof: felt*) {
        alloc_locals;
        let (local proof: felt*) = alloc();
        %{
            for index, node in enumerate(context.whitelist.merkle_proof):
                memory[ids.proof + index] = node
        %}
        return (proof,);
    }

    // Externals

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
}
