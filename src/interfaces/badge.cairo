// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ICarbonableBadge {
    //
    // Proxy administration
    //

    func getImplementationHash() -> (implementation: felt) {
    }

    func getAdmin() -> (admin: felt) {
    }

    func upgrade(new_implementation: felt) {
    }

    func setAdmin(new_admin: felt) {
    }

    //
    // Ownership administration
    //

    func owner() -> (owner: felt) {
    }

    func transferOwnership(newOwner: felt) {
    }

    func renounceOwnership() {
    }

    //
    // ERC-1155
    //

    func supportsInterface(interfaceId: felt) -> (success: felt) {
    }

    func uri(id: Uint256) -> (uri_len: felt, uri: felt*) {
    }

    func contractURI() -> (uri_len: felt, uri: felt*) {
    }

    func balanceOf(account: felt, id: Uint256) -> (balance: Uint256) {
    }

    func balanceOfBatch(accounts_len: felt, accounts: felt*, ids_len: felt, ids: Uint256*) -> (
        balances_len: felt, balances: Uint256*
    ) {
    }

    func isApprovedForAll(account: felt, operator: felt) -> (isApproved: felt) {
    }

    func setURI(uri_len: felt, uri: felt*) {
    }

    func setApprovalForAll(operator: felt, approved: felt) {
    }

    func safeTransferFrom(
        from_: felt, to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*
    ) {
    }

    func safeBatchTransferFrom(
        from_: felt,
        to: felt,
        ids_len: felt,
        ids: Uint256*,
        amounts_len: felt,
        amounts: Uint256*,
        data_len: felt,
        data: felt*,
    ) {
    }

    func mint(to: felt, id: Uint256, amount: Uint256, data_len: felt, data: felt*) {
    }

    func mintBatch(
        to: felt,
        ids_len: felt,
        ids: Uint256*,
        amounts_len: felt,
        amounts: Uint256*,
        data_len: felt,
        data: felt*,
    ) {
    }

    func burn(from_: felt, id: Uint256, amount: Uint256) {
    }

    func burnBatch(
        from_: felt, ids_len: felt, ids: Uint256*, amounts_len: felt, amounts: Uint256*
    ) {
    }

    //
    // Carbonable Badge
    //

    func name() -> (name: felt) {
    }

    func locked(id: Uint256) -> (is_locked: felt) {
    }

    func setLocked(id: Uint256) {
    }

    func setUnlocked(id: Uint256) {
    }
}
