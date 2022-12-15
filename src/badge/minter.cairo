// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.alloc import alloc

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.upgrades.library import Proxy
from bal7hazar.token.erc1155.library import ERC1155

// Local dependencies
from src.badge.library import CarbonableBadge
from src.badge.Ibadge import IBadgeContract

//
// Storage
//

@storage_var
func signer_public_key() -> (signer_public_key: felt) {
}

@storage_var
func badge_contract_address() -> (badge_contract_address: felt) {
}

//
// Constructor
//

@constructor
func constructor{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(owner: felt) {
    // Desc:
    //   Initialize the contract with the owner address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   owner(felt): Owner address
    // Returns:
    //   None
    alloc_locals;

    ERC1155.initializer(0);
    Ownable.initializer(owner);
    return ();
}

//
// Getters
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
    let (owner: felt) = Ownable.owner();
    return (owner,);
}

//
// Externals
//

@external
func claim{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*}(
    signature : (felt, felt),
    badge_type : felt,
) -> () {
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
    alloc_locals;
    let (caller_address) = get_caller_address();

    // Check if the NFT hasn't already been minted
    let (balance) = ERC1155.balance_of(caller_address, Uint256(badge_type, 0));
    assert balance = Uint256(0, 0);

    // Check if the signature is valid
    let (public_key) = signer_public_key.read();
    CarbonableBadge.assert_valid_signature((caller_address, badge_type), public_key, signature);

    let (data) = alloc();

    let (contract_address) = badge_contract_address.read();
    
    IBadgeContract.mint(contract_address, caller_address, Uint256(badge_type, 0), Uint256(1, 0), 1, data);
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
    alloc_locals;
    Ownable.assert_only_owner();
    signer_public_key.write(new_signer_public_key);
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
    alloc_locals;
    Ownable.assert_only_owner();
    badge_contract_address.write(new_badge_contract_address);
    return ();
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
    Ownable.renounce_ownership();
    return ();
}

@external
func transferBadgeContractOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
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
    let (contract_address) = badge_contract_address.read();
    IBadgeContract.transferOwnership(contract_address, newOwner);
    return ();
}

//
// UPGRADABILITY
//

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    // Desc:
    //   Upgrade the implementation of the proxy
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   new_implementation(felt): Address of the new implementation
    // Returns:
    //   None
    Ownable.assert_only_owner();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}