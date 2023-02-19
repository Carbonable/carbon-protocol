// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.mint.library import CarbonableMinter
from src.utils.access.library import CarbonableAccessControl

//
// Initializer
//

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated initializer that mainly stores the inputs.
// @dev unit_price, max_supply_for_mint and reserved_supply_for_mint must be valid Uint256.
// @param carbonable_project_address Address of the corresponding Carbonable project.
// @param payment_token_address Address of the ERC20 token that will be used during sales.
// @param public_sale_open 1 to open the public sale right after deployment, 0 otherwise.
// @param max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
// @param unit_price Price per token (based on ERC20 token defined as -payment_token_address-).
// @param max_supply_for_mint Max supply available whatever the way to mint.
// @param reserved_supply_for_mint Supply reserved to be airdropped.
// @param owner Owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt,
    payment_token_address: felt,
    public_sale_open: felt,
    max_buy_per_tx: felt,
    unit_price: Uint256,
    max_supply_for_mint: Uint256,
    reserved_supply_for_mint: Uint256,
    owner: felt,
) {
    CarbonableMinter.initializer(
        carbonable_project_address,
        payment_token_address,
        public_sale_open,
        max_buy_per_tx,
        unit_price,
        max_supply_for_mint,
        reserved_supply_for_mint,
    );
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
// @dev Only callable by the admin.
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
// @dev Only callable by the admin.
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

// @notice Return the owner address.
// @return owner Owner address.
@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev Only callable by the owner.
//   The new owner must not be the zero address.
// @param newOwner Address of the new owner.
@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

// @notice Renounce ownership.
// @dev Only callable by the owner.
@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

// @notice Set the Withdrawer.
// @dev Only callable by the owner.
// @param withdrawer Withdrawer address.
@external
func setWithdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    withdrawer: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_withdrawer(withdrawer);
    return ();
}

// @notice Get the Withdrawer.
// @return withdrawer Withdrawer address.
@view
func getWithdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    withdrawer: felt
) {
    return CarbonableAccessControl.get_withdrawer();
}

//
// Getters
//

// @notice Return the associated carbonable project.
// @return carbonable_project_address Address of the corresponding Carbonable project.
@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableMinter.carbonable_project_address();
}

// @notice Return the associated payment token.
// @return payment_token_address Address of the ERC20 token that will be used during sales.
@view
func getPaymentTokenAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    payment_token_address: felt
) {
    return CarbonableMinter.payment_token_address();
}

// @notice Return the max number of NFTs that can be purchased in a single tx.
// @return max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
@view
func isPreSaleOpen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    pre_sale_open: felt
) {
    return CarbonableMinter.pre_sale_open();
}

// @notice Return the public sale status.
// @return public_sale_open 1 if public sale is open, 0 otherwise.
@view
func isPublicSaleOpen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    public_sale_open: felt
) {
    return CarbonableMinter.public_sale_open();
}

// @notice Return the max number of NFTs that can be purchased in a single tx.
// @return max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
@view
func getMaxBuyPerTx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_buy_per_tx: felt
) {
    return CarbonableMinter.max_buy_per_tx();
}

// @notice Return the max number of NFTs that can be purchased in a single tx.
// @return max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
@view
func getUnitPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    unit_price: Uint256
) {
    return CarbonableMinter.unit_price();
}

// @notice Return the max number of NFTs that can be purchased in a single tx.
// @return max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
@view
func getReservedSupplyForMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (reserved_supply_for_mint: Uint256) {
    return CarbonableMinter.reserved_supply_for_mint();
}

// @notice Return the max number of NFTs that can be purchased in a single tx.
// @return max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
@view
func getMaxSupplyForMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_supply_for_mint: Uint256
) {
    return CarbonableMinter.max_supply_for_mint();
}

// @notice Return the max number of NFTs that can be purchased in a single tx.
// @return max_buy_per_tx Max number of NFTs that can be purchased in a single tx.
@view
func getWhitelistMerkleRoot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    whitelist_merkle_root: felt
) {
    return CarbonableMinter.whitelist_merkle_root();
}

// @notice Return the whitelist merkle root, 0 means it has not been set yet.
// @param account Address of the account to check.
// @param slots Number of slots to check.
// @param proof_len Length of the proof array.
// @param proof Merkle proof associated to the account and slots.
// @return slots 0 if not whitelisted, amount of slots otherwise.
@view
func getWhitelistedSlots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, slots: felt, proof_len: felt, proof: felt*
) -> (slots: felt) {
    return CarbonableMinter.whitelisted_slots(account, slots, proof_len, proof);
}

// @notice Return the slots already minted by an account using whitelist slots.
// @param account Address of the account to check.
// @return slots Amount of claimed slots.
@view
func getClaimedSlots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (slots: felt) {
    return CarbonableMinter.claimed_slots(account);
}

// @notice Return the sold out status.
// @return status 1 if sold out else 0.
@view
func isSoldOut{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    status: felt
) {
    return CarbonableMinter.sold_out();
}

// @notice Return the total value of the project.
// @return total_value Total value expressed in payment token units.
@view
func getTotalValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_value: Uint256
) {
    return CarbonableMinter.total_value();
}

//
// Externals
//

// @notice Set the payment token address.
// @dev Only callable by the contract owner.
// @param payment_token_address Address of the payment token.
@external
func setWhitelistMerkleRoot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    whitelist_merkle_root: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_whitelist_merkle_root(whitelist_merkle_root);
}

// @notice Set a new public sale status (1 to open, 0 otherwise).
// @dev Only callable by the contract owner.
// @param public_sale_open Public sale status.
@external
func setPublicSaleOpen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    public_sale_open: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_public_sale_open(public_sale_open);
}

// @notice Set a new max amount per tx during purchase.
// @dev Only callable by the contract owner.
// @param max_buy_per_tx Max amount per tx.
@external
func setMaxBuyPerTx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    max_buy_per_tx: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_max_buy_per_tx(max_buy_per_tx);
}

// @notice Set a new unit price per token.
// @dev Only callable by the contract owner.
// @param unit_price Unit price.
@external
func setUnitPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    unit_price: Uint256
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_unit_price(unit_price);
}

// @notice Decrease the reserved supply for airdrops by the providing amount of slots.
// @dev Only callable by the contract owner.
// @param slots Amount of slots to substract to the reserved supply.
@external
func decreaseReservedSupplyForMint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slots: Uint256
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.decrease_reserved_supply_for_mint(slots);
}

// @notice Increase the reserved supply for airdrops by the providing amount of slots.
// @dev Only callable by the contract owner.
//   The caller can't be the zero address.
//   Their must be enough available NFTs regarding max supply.
//   Their must be enough available reserved NFTs regarding reserved supply.
// @param slots Amount of slots to add to the reserved supply.
// @return success 1 if it succeeded, 0 otherwise.
@external
func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, quantity: felt
) -> (success: felt) {
    Ownable.assert_only_owner();
    return CarbonableMinter.airdrop(to, quantity);
}

// @notice Transfer the smart contract balance to the contract owner.
// @dev The caller must have the WITHDRAWER_ROLE role.
//   The transfer must succeed.
// @return success 1 if it succeeded, 0 otherwise.
@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    CarbonableAccessControl.assert_only_withdrawer();
    return CarbonableMinter.withdraw();
}

// @notice Transfer an amount of tokens specified by -token_address- to -recipient-.
// @dev The caller must be the contract owner.
//   The amount must be a valid Uint256.
//   The transfer must succeed.
// @param token_address Token address to transfer.
// @param recipient Address to receive tokens.
// @param amount Amount of token to transfer.
// @return success 1 if it succeeded, 0 otherwise.
@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_address: felt, recipient: felt, amount: Uint256
) -> (success: felt) {
    Ownable.assert_only_owner();
    return CarbonableMinter.transfer(token_address, recipient, amount);
}

// @notice Purchase -quantity- tokens while proving the caller is part of the merkle tree while pre sale is open.
// @dev The pre sale must be open.
//   The caller must be part of the merkle tree.
//   The quantity must be a valid Uint256.
//   The quantity must be less than or equal to the max buy per tx.
//   The quantity must be less than or equal to the available supply.
//   The quantity must be less than or equal to the available reserved supply.
//   The transfer must succeed.
// @param slots Associated slots recorded in the merkle root.
// @param proof_len Proof array length.
// @param proof Merkle proof associated to the account and slots.
// @param quantity Quantity of tokens to buy.
// @return success 1 if it succeeded, 0 otherwise.
@external
func preBuy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slots: felt, proof_len: felt, proof: felt*, quantity: felt
) -> (success: felt) {
    return CarbonableMinter.pre_buy(slots, proof_len, proof, quantity);
}

// @notice Purchase -quantity- tokens while public sale is open.
// @dev The public sale must be open.
//   The caller can't be the zero address.
//   The quantity must be a valid Uint256.
//   The quantity must be less than or equal to the max buy per tx.
//   The quantity must be less than or equal to the available supply.
//   The quantity must be less than or equal to the available reserved supply.
//   The transfer must succeed.
// @param quantity Quantity of tokens to buy.
// @return success 1 if it succeeded, 0 otherwise.
@external
func publicBuy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(quantity: felt) -> (
    success: felt
) {
    return CarbonableMinter.public_buy(quantity);
}
