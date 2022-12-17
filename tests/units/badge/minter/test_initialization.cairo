// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero

// Local dependencies
from src.badge.minter import owner, initializer, getSignerPublicKey, getBadgeContractAddress

@external
func test_initialization{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;


    initializer(0x123, 0x41, 0x4);

    let (contract_owner) = owner();
    assert contract_owner = 0x123;

    let (signer_public_key) = getSignerPublicKey();
    assert signer_public_key = 0x41;

    let (badge_contract_address) = getBadgeContractAddress();
    assert badge_contract_address = 0x4;


    return ();
}