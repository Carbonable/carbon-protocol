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

@event
func Locked(token_id: Uint256) {
    // Desc:
    //   Emit event when a token id is locked for transfer
    // Explicit args:
    //   token_id(Uint256): Token id
}

@event
func Unlocked(token_id: Uint256) {
    // Desc:
    //   Emit event when a token id is unlocked for transfer
    // Explicit args:
    //   token_id(Uint256): Token id
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

    func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(uri_len: felt, uri: felt*, name: felt) {
        // Desc:
        //   Initialize the contract with the given uri and name
        // Implicit args:
        //   syscall_ptr(felt*)
        //   pedersen_ptr(HashBuiltin*)
        //   bitwise_ptr(BitwiseBuiltin*)
        //   range_check_ptr
        // Explicit args:
        //   uri_len(felt): uri array length
        //   uri(felt*): uri characters as a felt array
        //   name(felt): name of the badge collection
        // Returns:
        //   None
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

    func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(signer_public_key: felt, badge_contract_address: felt) {
        // Desc:
        //   Initialize the contract with the given signer public key and badge contract address.
        // Implicit args:
        //   syscall_ptr(felt*)
        //   pedersen_ptr(HashBuiltin*)
        //   range_check_ptr
        // Explicit args:
        //   signer_public_key(felt)
        //   badge_contract_address(felt)
        // Returns:
        //   None
        CarbonablebadgeMinter_signer_public_key.write(signer_public_key);
        CarbonablebadgeMinter_badge_contract_address.write(badge_contract_address);
        return ();
    }

    //
    // Getters
    //

    func getSignerPublicKey{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (signer_public_key: felt) {
        // Desc:
        //   Return the public key of the signer
        // Implicit args:
        //   syscall_ptr(felt*)
        //   pedersen_ptr(HashBuiltin*)
        //   range_check_ptr
        // Returns:
        //   signer_public_key(felt): The public key
        let (signer_public_key: felt) = CarbonablebadgeMinter_signer_public_key.read();
        return (signer_public_key,);
    }

    func getBadgeContractAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (badge_contract_address: felt) {
        // Desc:
        //   Return the address of the badge contract
        // Implicit args:
        //   syscall_ptr(felt*)
        //   pedersen_ptr(HashBuiltin*)
        //   range_check_ptr
        // Returns:
        //   badge_contract_address(felt): The address of the badge contract
        let (badge_contract_address: felt) = CarbonablebadgeMinter_badge_contract_address.read();
        return (badge_contract_address,);
    }

    //
    // Externals
    //

    func claim{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*}(
        badge_type : felt,
    ) -> () {
        // Desc:
        //   Claim a badge of the given type.
        // Implicit args:
        //   syscall_ptr(felt*)
        //   pedersen_ptr(HashBuiltin*)
        //   range_check_ptr
        //   ecdsa_ptr(SignatureBuiltin*)
        // Explicit args:
        //   badge_type(felt)
        // Returns:
        //   None
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
        CarbonablebadgeMinter_signer_public_key.write(new_signer_public_key);
        return ();
    }

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
        CarbonablebadgeMinter_badge_contract_address.write(new_badge_contract_address);
        return ();
    }


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