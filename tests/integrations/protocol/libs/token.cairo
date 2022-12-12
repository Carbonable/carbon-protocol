// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20

//
// Functions
//

namespace instance {
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
