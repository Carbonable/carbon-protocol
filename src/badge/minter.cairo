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

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    signer_key: felt, carbonable_badge_contract_address: felt, owner: felt
) {
    // Desc:
    //   Initialize the contract with the owner address, the public key of the signer and the address of the badge contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   signer_public_key(felt): Public key of the signer
    //   carbonable_badge_contract_address(felt): Address of the badge contract
    //   owner(felt): Owner and Admin address
    // Returns:
    //   None

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

@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    // Desc:
    //   Return the current implementation hash
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   implementation(felt): Implementation class hash
    return Proxy.get_implementation_hash();
}

@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    // Desc:
    //   Return the admin address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   admin(felt): The admin address
    return Proxy.get_admin();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    // Desc:
    //   Upgrade the contract to the new implementation
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_implementation(felt): New implementation class hash
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the admin
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    // Desc:
    //   Transfer admin rights to a new admin
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_admin(felt): Address of the new admin
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the admin
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}

//
// Ownership administration
//

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    // Desc:
    //   Return the contract owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   owner(felt): The owner address
    return Ownable.owner();
}

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    // Desc:
    //   Transfer ownership to a new owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   newOwner(felt): Address of the new owner
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    //   newOwner: new owner is the zero address
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Desc:
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.renounce_ownership();
    return ();
}

//
// Carbonable Badge Minter
//

@view
func getSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    signer_public_key: felt
) {
    // Desc:
    //   Return the public key of the signer
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   signer_public_key(felt): The public key
    return CarbonableBadgeMinter.getSignerPublicKey();
}

@view
func getBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    badge_contract_address: felt
) {
    // Desc:
    //   Return the address of the badge contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   badge_contract_address(felt): The address of the badge contract
    return CarbonableBadgeMinter.getBadgeContractAddress();
}

@external
func claim{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}(signature: (felt, felt), badge_type: felt) -> () {
    // Desc:
    //   Mint a badge to the caller of the specified type if the signature is valid, on the badge contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    //   ecdsa_ptr(SignatureBuiltin*)
    // Explicit args:
    //   signature(felt, felt): server signature made from the pedersen hash of the caller address and the badge type
    //   badge_type(felt): badge type
    // Returns:
    //   None
    let (caller_address) = get_caller_address();
    CarbonableBadgeMinter.assert_valid_signature((caller_address, badge_type), signature);
    CarbonableBadgeMinter.claim(badge_type);
    return ();
}

@external
func setSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_signer_public_key: felt
) -> () {
    // Desc:
    //   Set the public key of the signer for mintBadge transactions
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_signer_public_key(felt): The new public key
    // Returns:
    //   None
    Ownable.assert_only_owner();
    CarbonableBadgeMinter.setSignerPublicKey(new_signer_public_key);
    return ();
}

@external
func setBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_badge_contract_address: felt
) -> () {
    // Desc:
    //   Set the address of the badge contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_badge_contract_address(felt): The new badge contract address
    // Returns:
    //   None
    Ownable.assert_only_owner();
    CarbonableBadgeMinter.setBadgeContractAddress(new_badge_contract_address);
    return ();
}

@external
func transferBadgeContractOwnership{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(newOwner: felt) {
    // Desc:
    //   Transfer ownership of the badge contract to a new owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   newOwner(felt): Address of the new owner
    // Returns:
    //   None
    Ownable.assert_only_owner();
    CarbonableBadgeMinter.transferBadgeContractOwnership(newOwner);
    return ();
}
