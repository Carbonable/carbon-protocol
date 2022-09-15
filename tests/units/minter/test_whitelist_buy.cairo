// SPDX-License-Identifier: MIT
// Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

// Project dependencies
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Given a deployed user contracts
    // And an admin with address 1000
    // And an anyone with address 1001
    // Given a deployed project nft contact
    // Given a deployed payment token contact
    // Given a deployed minter contact
    // And owned by admin
    // And a whitelist sale close
    // And a public sale close
    // And a max buy per tx set to 5
    // And an unit price set to 10
    // And a max supply set to 10
    // And a reserved supply set to 0
    return setup();
}

@external
func test_whitelist_buy_nominal_case{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // Given a deployed project nft contact
    // And a total supply of 5 nfts
    // And the mint function succeeds
    // Given a deployed payment token contact
    // And the transferFrom function succeeds
    // Given a whitelist merkle tree
    // And an allocation of 5 whitelist slots to anyone
    // When admin set up the whitelist merkle tree
    // And anyone makes 2 whitelist buy
    // Then no failed transactions expected
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // admin sets whitelist merkle root
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    %{ stop() %}

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [5, 0]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mint", []) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    let (success) = CarbonableMinter.whitelist_buy(
        slots=context.whitelist.slots,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
        quantity=2,
    );
    assert success = TRUE;
    %{ stop() %}
    return ();
}

@external
func test_buy_user_whitelisted_but_not_enough_slots{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: anyone
    // Wants to buy 6 NFTs
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // Is user whitelisted: YES (but not enough slots)
    // current NFT totalSupply: 5
    // current NFT reserved supply: 0
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // admin sets whitelist merkle root
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    %{ stop() %}

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [3, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough whitelisted slots available") %}
    CarbonableMinter.whitelist_buy(
        slots=context.whitelist.slots,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
        quantity=6,
    );
    %{ stop() %}
    return ();
}

@external
func test_buy_user_whitelisted_but_not_enough_slots_after_claim{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: anyone
    // Wants to buy 5 NFTs and then 1 NFT
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // Is user whitelisted: YES (but not enough slots for second buy)
    // current NFT totalSupply: 3
    // current NFT reserved supply: 0
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // admin sets whitelist merkle root
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(context.whitelist.merkle_root);
    %{ stop() %}

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}

    // Mock
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [3, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ mock_call(context.mocks.carbonable_project_address, "mint", []) %}

    // First buy
    // Call whitelist_buy
    CarbonableMinter.whitelist_buy(
        slots=context.whitelist.slots,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
        quantity=5,
    );

    // Expect error
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough whitelisted slots available") %}

    // Second buy
    // Call whitelist_buy
    CarbonableMinter.whitelist_buy(
        slots=context.whitelist.slots,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
        quantity=1,
    );
    %{ stop() %}
    return ();
}

@external
func test_buy_revert_not_whitelisted{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // User: anyone
    // Wants to buy 2 NFTs
    // Whitelisted sale: OPEN
    // Public sale: CLOSED
    // Is user whitelisted: NO
    // current NFT totalSupply: 5
    // current NFT reserved supply: 0
    // has enough funds: YES
    alloc_locals;

    // prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    );

    // admin sets whitelist merkle root
    %{ stop=start_prank(context.signers.admin) %}
    CarbonableMinter.set_whitelist_merkle_root(123);
    %{ stop() %}

    // run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    %{ mock_call(context.mocks.carbonable_project_address, "totalSupply", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transferFrom", [1]) %}
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: caller address is not whitelisted") %}
    CarbonableMinter.whitelist_buy(
        slots=context.whitelist.slots,
        proof_len=context.whitelist.merkle_proof_len,
        proof=context.whitelist.merkle_proof,
        quantity=2,
    );
    %{ stop() %}
    return ();
}
