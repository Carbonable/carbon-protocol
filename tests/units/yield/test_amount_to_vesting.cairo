// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_contract_address

// Local dependencies
from tests.units.yield.library import setup, prepare, CarbonableYielder

// unites are in Wei
const TOTAL_AMOUNT_LOW = 100000000000000;  // 0.0001 ETH
const TOTAL_AMOUNT_HIGH = 24663812000000000000000;  // 24663.812 ETH
const TOKEN_TOTAL_DEPOSITED = 42;
const TOKEN_TOTAL_DEPOSITED_HIGH = 761234;

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_high_amount_to_vest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let zero = Uint256(low=0, high=0);
    let one = Uint256(low=1, high=0);

    // [Expected] amount = 32399777203855844 Wei => 0.032399777203855844 ETH
    let total_amount = TOTAL_AMOUNT_HIGH;
    let token_total_deposited = Uint256(low=TOKEN_TOTAL_DEPOSITED_HIGH, high=0);

    let address_token_amount = 1;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=32399777203855844, high=0);
    assert amount = result_expected;

    // [Expected] amount = 129599108815423378 Wei => 0.129599108815423378 ETH
    let address_token_amount = 4;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=129599108815423378, high=0);
    assert amount = result_expected;

    // [Expected] amount = 1295991088154233783 Wei => 1.295991088154233783 ETH
    let address_token_amount = 40;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=1295991088154233783, high=0);
    assert amount = result_expected;

    // [Expected] amount = 18902872414936799985287 Wei => 18902.872414936799985287 ETH
    let address_token_amount = 583426;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=18902872414936799985287, high=0);
    assert amount = result_expected;

    return ();
}

@external
func test_low_amount_to_vest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let zero = Uint256(low=0, high=0);
    let one = Uint256(low=1, high=0);

    // [Expected] amount = 2380952380952 Wei => 0.000002380952380952 ETH
    let total_amount = TOTAL_AMOUNT_LOW;
    let token_total_deposited = Uint256(low=TOKEN_TOTAL_DEPOSITED, high=0);

    let address_token_amount = 1;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=2380952380952, high=0);
    assert amount = result_expected;

    // [Expected] amount = 9523809523809 Wei => 0.000009523809523809 ETH
    let address_token_amount = 4;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=9523809523809, high=0);
    assert amount = result_expected;

    // [Expected] amount = 95238095238095 Wei => 0.000095238095238095 ETH
    let address_token_amount = 40;

    let (amount) = CarbonableYielder._amount_to_vest(
        token_total_deposited=token_total_deposited,
        total_amount=total_amount,
        address_token_amount=address_token_amount,
    );
    let result_expected = Uint256(low=95238095238095, high=0);
    assert amount = result_expected;

    return ();
}
