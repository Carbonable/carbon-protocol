// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_decrease_reserved_supply_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to decrease the reserved supply by 2
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current NFT reserved supply: 5
    alloc_locals;

    // prepare minter instance
    let reserved_supply = Uint256(5, 0);
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=reserved_supply,
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    let slots = Uint256(2, 0);
    let (expected_slots) = SafeUint256.sub_le(reserved_supply, slots);
    CarbonableMinter.decrease_reserved_supply_for_mint(slots=slots);
    let (returned_supply) = CarbonableMinter.reserved_supply_for_mint();
    assert returned_supply = expected_slots;
    %{ stop() %}
    return ();
}

@external
func test_decrease_reserved_supply_revert_over_decreased{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to decrease the reserved supply by 6
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current NFT reserved supply: 5
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(5, 0),
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    let slots = Uint256(6, 0);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough reserved slots") %}
    CarbonableMinter.decrease_reserved_supply_for_mint(slots=slots);
    %{ stop() %}
    return ();
}

@external
func test_decrease_reserved_supply_revert_invalid_slots{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: admin
    // Wants to decrease the reserved supply by 6
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // current NFT reserved supply: 5
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(5, 0),
    );

    // run scenario
    %{ stop=start_prank(context.signers.admin) %}
    let slots = Uint256(6, -1);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: slots is not a valid Uint256") %}
    CarbonableMinter.decrease_reserved_supply_for_mint(slots=slots);
    %{ stop() %}
    return ();
}
