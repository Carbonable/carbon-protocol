// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.alloc import alloc

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.badge.library import CarbonableBadgeMinter
from src.interfaces.badge import ICarbonableBadge

//
// Initializer
//

// @notice Initialize the contract with the owner address, the public key of the signer and the address of the badge contract.
// @dev Can only be called if there is no admin.
// @param signer_public_key Public key of the signer.
// @param carbonable_badge_contract_address Address of the badge contract.
// @param owner Owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    signer_key: felt, carbonable_badge_contract_address: felt, owner: felt
) {
    // Can only be called if there is no admin
    let (current_owner) = Ownable.owner();
    assert current_owner = 0;

    // Then if there is no admin, the proxy can initialize the contract
    CarbonableBadgeMinter.initializer(signer_key, carbonable_badge_contract_address);
    Ownable.initializer(owner);
    Proxy.initializer(owner);
    return ();
}

//
// Proxy administration
//

// @notice Return the current implementation hash.
// @return implementation Implementation class hash.
@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

// @notice Return the admin address.
// @return admin Admin address.
@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

// @notice Upgrade the contract to the new implementation.
// @dev Caller must be the admin.
// @param new_implementation New implementation class hash.
@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

// @notice Transfer admin rights to a new admin.
// @dev Caller must be the admin.
// @param new_admin Address of the new admin.
@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}

//
// Ownership administration
//

// @notice Return the contract owner.
// @return owner Owner address.
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev Caller must be the owner.
//   New owner cannot be the zero address.
// @param new_owner Address of the new owner.
@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

// @notice Renounce ownership.
// @dev Caller must be the owner.
@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

//
// Carbonable Badge Minter
//

// @notice Return the public key of the signer.
// @return signer_public_key Public key of the signer.
@view
func getSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    signer_public_key: felt
) {
    return CarbonableBadgeMinter.getSignerPublicKey();
}

// @notice Return the address of the badge contract.
// @return badge_contract_address Address of the badge contract.
@view
func getBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    badge_contract_address: felt
) {
    return CarbonableBadgeMinter.getBadgeContractAddress();
}

// @notice Mint a badge to the caller of the specified type if the signature is valid, on the badge contract.
// @param signature Server signature made from the pedersen hash of the caller address and the badge type.
// @param badge_type Badge type.
@external
func claim{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}(signature: (felt, felt), badge_type: felt) -> () {
    let (caller_address) = get_caller_address();
    CarbonableBadgeMinter.assert_valid_signature((caller_address, badge_type), signature);
    CarbonableBadgeMinter.claim(badge_type);
    return ();
}

// @notice Set the public key of the signer for mintBadge transactions.
// @dev Caller must be the owner.
// @param new_signer_public_key The new public key.
@external
func setSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_signer_public_key: felt
) -> () {
    Ownable.assert_only_owner();
    CarbonableBadgeMinter.setSignerPublicKey(new_signer_public_key);
    return ();
}

// @notice Set the address of the badge contract.
// @dev Caller must be the owner.
// @param new_badge_contract_address The new badge contract address.
@external
func setBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_badge_contract_address: felt
) -> () {
    Ownable.assert_only_owner();
    CarbonableBadgeMinter.setBadgeContractAddress(new_badge_contract_address);
    return ();
}

// @notice Transfer ownership of the badge contract to a new owner.
// @dev Caller must be the owner.
// @param newOwner Address of the new owner.
@external
func transferBadgeContractOwnership{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(newOwner: felt) {
    Ownable.assert_only_owner();
    CarbonableBadgeMinter.transferBadgeContractOwnership(newOwner);
    return ();
}
