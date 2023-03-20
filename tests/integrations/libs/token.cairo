// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20

// Local dependencies
from src.utils.type.library import _felt_to_uint, _uint_to_felt

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (contract_address: felt) {
        tempvar contract_address;
        %{ ids.contract_address = context.payment_token_contract %}
        return (contract_address,);
    }

    // Views

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (balance: felt) {
        let (contract_address) = instance.get_address();
        let (balance_u256) = IERC20.balanceOf(contract_address=contract_address, account=account);
        let (balance) = _uint_to_felt(balance_u256);
        return (balance,);
    }

    func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt, spender: felt
    ) -> (remaining: felt) {
        let (contract_address) = instance.get_address();
        let (remaining_u256) = IERC20.allowance(
            contract_address=contract_address, owner=owner, spender=spender
        );
        let (remaining) = _uint_to_felt(remaining_u256);
        return (remaining,);
    }

    // Externals

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        spender: felt, amount: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (amount_u256) = _felt_to_uint(amount);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = IERC20.approve(
            contract_address=contract_address, spender=spender, amount=amount_u256
        );
        %{ stop_prank() %}
        return (success,);
    }

    func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, caller: felt}(
        recipient: felt, amount: felt
    ) -> (success: felt) {
        let (contract_address) = instance.get_address();
        let (amount_u256) = _felt_to_uint(amount);
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.contract_address) %}
        let (success) = IERC20.transfer(
            contract_address=contract_address, recipient=recipient, amount=amount_u256
        );
        %{ stop_prank() %}
        return (success,);
    }
}
