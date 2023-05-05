// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256, uint256_check
from starkware.cairo.common.memcpy import memcpy

from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

from src.interfaces.metadata import ICarbonableMetadata

@storage_var
func CarbonableMetadata_implementation() -> (implementation: felt) {
}

@storage_var
func CarbonableMetadata_slot_implementation(slot: Uint256) -> (implementation: felt) {
}

namespace CarbonableMetadata {
    func get_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        implementation: felt
    ) {
        return CarbonableMetadata_implementation.read();
    }

    func get_slot_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (implementation: felt) {
        Assert.u256(slot);
        return CarbonableMetadata_slot_implementation.read(slot);
    }

    func set_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        implementation: felt
    ) {
        with_attr error_message("Metadata: implementation hash cannot be zero") {
            assert_not_zero(implementation);
        }

        CarbonableMetadata_implementation.write(implementation);
        return ();
    }

    func set_slot_implementation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256, implementation: felt
    ) {
        Assert.u256(slot);
        with_attr error_message("Metadata: implementation hash cannot be zero") {
            assert_not_zero(implementation);
        }

        CarbonableMetadata_slot_implementation.write(slot, implementation);
        return ();
    }

    func contract_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        uri_len: felt, uri: felt*
    ) {
        alloc_locals;

        let (class_hash) = get_implementation();
        let (local array: felt*) = alloc();

        // [Check] Metadata implementation set
        if (class_hash == 0) {
            return (uri_len=0, uri=array);
        }

        let (uri_len: felt, uri: felt*) = ICarbonableMetadata.library_call_contractURI(
            class_hash=class_hash
        );

        return (uri_len=uri_len, uri=uri);
    }

    func slot_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        // [Check] Uint256 compliance
        Assert.u256(slot);

        let (class_hash) = CarbonableMetadata.get_implementation();
        let (local array: felt*) = alloc();

        // [Check] Metadata implementation set
        if (class_hash == 0) {
            return (uri_len=0, uri=array);
        }

        let (uri_len: felt, uri: felt*) = ICarbonableMetadata.library_call_slotURI(
            class_hash=class_hash, slot=slot
        );

        return (uri_len=uri_len, uri=uri);
    }

    func token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (uri_len: felt, uri: felt*) {
        alloc_locals;

        // [Check] Uint256 compliance
        Assert.u256(token_id);

        let (class_hash) = CarbonableMetadata.get_implementation();
        let (local array: felt*) = alloc();

        // [Check] Metadata implementation set
        if (class_hash == 0) {
            return (uri_len=0, uri=array);
        }

        let (uri_len: felt, uri: felt*) = ICarbonableMetadata.library_call_tokenURI(
            class_hash=class_hash, tokenId=token_id
        );

        return (uri_len=uri_len, uri=uri);
    }
}

// Assert helpers
namespace Assert {
    func u256{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(value: Uint256) {
        with_attr error_message("CarbonableMetadata: value is not a valid Uint256") {
            uint256_check(value);
        }
        return ();
    }
}
