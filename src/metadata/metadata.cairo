// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from src.metadata.library import CarbonableMetadata

// @notice Return the contract URI (OpenSea).
// @return uri_len The URI array length
// @return uri The URI characters
@view
func contractURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (uri_len: felt, uri: felt*) {
    let (uri_len, uri) = CarbonableMetadata.contract_uri();
    return (uri_len=uri_len, uri=uri);
}

// @notice Return the slot URI.
// @param slot The slot to query.
// @return uri_len The URI array length
// @return uri The URI characters
@view
func slotURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(slot: felt) -> (uri_len: felt, uri: felt*) {
    let (uri_len, uri) = CarbonableMetadata.slot_uri(slot=slot);
    return (uri_len=uri_len, uri=uri);
}

// @notice Return the token URI.
// @param slot The token slot.
// @param value The token value.
// @param decimals The token decimals.
// @return uri_len The URI array length
// @return uri The URI characters
@view
func tokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(slot: felt, value: felt, decimals: felt) -> (uri_len: felt, uri: felt*) {
    let (uri_len, uri) = CarbonableMetadata.token_uri(slot=slot, value=value, decimals=decimals);
    return (uri_len=uri_len, uri=uri);
}
