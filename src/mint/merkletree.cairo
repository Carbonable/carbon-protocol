// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math_cmp import is_le_felt

namespace MerkleTree {
    //##
    // Verify that leaf belongs to merkle tree.
    // ref: https://github.com/ncitron/cairo-merkle-distributor/blob/master/contracts/merkle.cairo
    // @param leaf
    // @param proof_len
    // @param proof
    //##
    func verify{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        leaf: felt, merkle_root: felt, proof_len: felt, proof: felt*
    ) -> (res: felt) {
        alloc_locals;

        let (calc_root) = calculate_root(leaf, proof_len, proof);
        // check if calculated root is equal to expected
        if (calc_root == merkle_root) {
            return (1,);
        }
        return (0,);
    }

    //##
    // Calculates the merkle root of a given proof
    // ref: https://github.com/ncitron/cairo-merkle-distributor/blob/master/contracts/merkle.cairo
    // @param curr
    // @param proof_len
    // @param proof
    //##
    func calculate_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        curr: felt, proof_len: felt, proof: felt*
    ) -> (res: felt) {
        alloc_locals;

        if (proof_len == 0) {
            return (curr,);
        }

        local node;
        local proof_elem = [proof];
        let le = is_le_felt(curr, proof_elem);

        if (le == 1) {
            let (n) = hash2{hash_ptr=pedersen_ptr}(curr, proof_elem);
            node = n;
        } else {
            let (n) = hash2{hash_ptr=pedersen_ptr}(proof_elem, curr);
            node = n;
        }

        let (res) = calculate_root(node, proof_len - 1, proof + 1);
        return (res,);
    }
}
