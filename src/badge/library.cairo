// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, SignatureBuiltin, HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_check
from starkware.cairo.common.signature import verify_ecdsa_signature
from starkware.cairo.common.hash import hash2
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.alloc import alloc

// Project dependencies
from cairopen.string.ASCII import StringCodec
from cairopen.string.utils import StringUtil
from openzeppelin.introspection.erc165.library import ERC165

// Local dependencies
from src.utils.metadata.library import Metadata
from src.interfaces.badge import ICarbonableBadge

const IERC5192_ID = 0xb45a3c0e;

//
// Events
//

// @notice Emitted when a token id is locked for transfer.
// @param token_id The token id that was locked.
@event
func Locked(token_id: Uint256) {
}

// @notice Emitted when a token id is unlocked for transfer.
// @param token_id The token id that was unlocked.
@event
func Unlocked(token_id: Uint256) {
}

//
// Storage
//

@storage_var
func CarbonableBadge_unlocked(id: Uint256) -> (unlocked: felt) {
}

@storage_var
func CarbonableBadge_name() -> (name: felt) {
}

@storage_var
func CarbonablebadgeMinter_signer_public_key() -> (signer_public_key: felt) {
}

@storage_var
func CarbonablebadgeMinter_badge_contract_address() -> (badge_contract_address: felt) {
}

namespace CarbonableBadge {
    //
    // Initializer
    //

    // @notice Initializes the contract with the given uri and name.
    // @param uri_len uri array length.
    // @param uri uri characters as a felt array.
    // @param name name of the badge collection.
    func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len: felt, uri: felt*, name: felt) {
        Metadata.set_uri(uri_len, uri);
        ERC165.register_interface(IERC5192_ID);
        CarbonableBadge_name.write(name);
        return ();
    }

    //
    // Getters
    //

    func uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(id: Uint256) -> (uri_len: felt, uri: felt*) {
        let (uri_len: felt, uri: felt*) = Metadata.token_uri(id);
        return (uri_len=uri_len, uri=uri);
    }

    func contract_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }() -> (uri_len: felt, uri: felt*) {
        let (uri_len: felt, uri: felt*) = Metadata.contract_uri();
        return (uri_len=uri_len, uri=uri);
    }

    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
        let (name) = CarbonableBadge_name.read();
        return (name,);
    }

    func locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id: Uint256) -> (
        is_locked: felt
    ) {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableBadge: id is not a valid Uint256") {
            uint256_check(id);
        }

        let (is_unlocked) = CarbonableBadge_unlocked.read(id);
        return (1 - is_unlocked,);
    }

    //
    // Externals
    //

    func set_uri{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len: felt, uri: felt*) {
        Metadata.set_uri(uri_len, uri);
        return ();
    }

    func set_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        id: Uint256
    ) -> () {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableBadge: id is not a valid Uint256") {
            uint256_check(id);
        }

        CarbonableBadge_unlocked.write(id, FALSE);
        Locked.emit(id);

        return ();
    }

    func set_unlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        id: Uint256
    ) -> () {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableBadge: id is not a valid Uint256") {
            uint256_check(id);
        }

        CarbonableBadge_unlocked.write(id, TRUE);
        Unlocked.emit(id);

        return ();
    }

    //
    // Internals
    //

    func assert_unlocked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        id: Uint256
    ) -> () {
        // [Check] Uint256 compliance
        with_attr error_message("CarbonableBadge: id is not a valid Uint256") {
            uint256_check(id);
        }

        // [Check] Token is unlocked
        let (is_locked) = locked(id);
        with_attr error_message("CarbonableBadge: transfer is locked") {
            assert is_locked = FALSE;
        }
        return ();
    }

    func assert_unlocked_batch{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ids_len: felt, ids: Uint256*
    ) -> () {
        _assert_unlocked_iter(ids_len=ids_len, ids=ids);
        return ();
    }

    func _assert_unlocked_iter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ids_len: felt, ids: Uint256*
    ) -> () {
        // [Check] Stop criteria
        if (ids_len == 0) {
            return ();
        }

        // [Check] Token is unlocked
        assert_unlocked([ids]);
        _assert_unlocked_iter(ids_len=ids_len - 1, ids=ids + 1);

        return ();
    }
}

namespace CarbonableBadgeMinter {
    //
    // Initializer
    //

    // @notice Initialize the contract with the given signer public key and badge contract address.
    // @param signer_public_key The signer public key.
    // @param badge_contract_address The badge contract address.
    func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(signer_public_key: felt, badge_contract_address: felt) {
        CarbonablebadgeMinter_signer_public_key.write(signer_public_key);
        CarbonablebadgeMinter_badge_contract_address.write(badge_contract_address);
        return ();
    }

    //
    // Getters
    //

    // @notice Return the public key of the signer.
    // @return signer_public_key The signer public key.
    func getSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (signer_public_key: felt) {
        let (signer_public_key: felt) = CarbonablebadgeMinter_signer_public_key.read();
        return (signer_public_key,);
    }

    // @notice Return the address of the badge contract.
    // @return badge_contract_address The badge contract address.
    func getBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (badge_contract_address: felt) {
        let (badge_contract_address: felt) = CarbonablebadgeMinter_badge_contract_address.read();
        return (badge_contract_address,);
    }

    //
    // Externals
    //

    // @notice Claim a badge of the given type.
    // @param badge_type The badge type.
    func claim{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*}(
        badge_type : felt,
    ) -> () {
        alloc_locals;

        let (caller_address) = get_caller_address();
        let (badge_contract_address) = CarbonablebadgeMinter_badge_contract_address.read();

        // Check if the NFT hasn't already been minted
        let (balance) = ICarbonableBadge.balanceOf(badge_contract_address, caller_address, Uint256(badge_type, 0));
        assert balance = Uint256(0, 0);

        let (data) = alloc();
        
        ICarbonableBadge.mint(badge_contract_address, caller_address, Uint256(badge_type, 0), Uint256(1, 0), 0, data);
        return ();
    }

    // @notice Set the public key of the signer for mintBadge transactions.
    // @param new_signer_public_key The new signer public key.
    func setSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_signer_public_key: felt
    ) -> () {
        CarbonablebadgeMinter_signer_public_key.write(new_signer_public_key);
        return ();
    }

    // @notice Set the address of the badge contract.
    // @param new_badge_contract_address The new badge contract address.
    func setBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        new_badge_contract_address: felt
    ) -> () {
        CarbonablebadgeMinter_badge_contract_address.write(new_badge_contract_address);
        return ();
    }

    // @notice Transfer ownership of the badge contract to a new owner.
    // @param newOwner The address of the new owner.
    func transferBadgeContractOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        newOwner: felt
    ) {
        let (badge_contract_address) = CarbonablebadgeMinter_badge_contract_address.read();
        ICarbonableBadge.transferOwnership(badge_contract_address, newOwner);
        return ();
    }

    //
    // Internals
    //

    func assert_valid_signature{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*}(
        message: (felt, felt),
        signature: (felt, felt),
    ) {
        let (signer_public_key) = CarbonablebadgeMinter_signer_public_key.read();
        let (messageHash) = hash2{hash_ptr=pedersen_ptr}(message[0], message[1]);
        // [Check] Signature is valid
        with_attr error_message("CarbonableBadge: invalid signature") {
            verify_ecdsa_signature(messageHash, signer_public_key, signature[0], signature[1]);
        }
        return ();
    }
}