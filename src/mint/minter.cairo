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
// @dev unit_price, max_value and reserved_value must be valid Uint256.
// @param carbonable_project_address The adress of the corresponding Carbonable project.
// @param payment_token_address The address of the ERC20 token that will be used during sales.
// @param public_sale_open TRUE to open the public sale right after deployment, FALSE otherwise.
// @param max_value_per_tx The max number of NFTs that can be purchased in a single tx.
// @param min_value_per_tx The max number of NFTs that can be purchased in a single tx.
// @param max_value The max value available whatever the way to mint.
// @param unit_price The price per token (based on ERC20 token defined as -payment_token_address-).
// @param reserved_value The value reserved to be airdropped.
// @param owner The owner and admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt,
    carbonable_project_slot: Uint256,
    payment_token_address: felt,
    public_sale_open: felt,
    max_value_per_tx: felt,
    min_value_per_tx: felt,
    max_value: felt,
    unit_price: felt,
    reserved_value: felt,
    owner: felt,
) {
    CarbonableMinter.initializer(
        carbonable_project_address,
        carbonable_project_slot,
        payment_token_address,
        public_sale_open,
        max_value_per_tx,
        min_value_per_tx,
        max_value,
        unit_price,
        reserved_value,
    );
    Ownable.initializer(owner);
    Proxy.initializer(owner);
    return ();
}

//
// Proxy administration
//

// @notice Return the current implementation hash.
// @return implementation The implementation class hash.
@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

// @notice Return the admin address.
// @return admin The admin address.
@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

// @notice Upgrade the contract to the new implementation.
// @dev Only callable by the admin.
// @param new_implementation The new implementation class hash.
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
// @param new_admin The address of the new admin.
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
// @return owner The owner address.
@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// @notice Transfer ownership to a new owner.
// @dev Only callable by the owner.
//   The new owner must not be the zero address.
// @param newOwner The address of the new owner.
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
// @param withdrawer The withdrawer address.
@external
func setWithdrawer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    withdrawer: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_withdrawer(withdrawer);
    return ();
}

// @notice Get the Withdrawer.
// @return withdrawer The withdrawer address.
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
// @return carbonable_project_address The address of the corresponding Carbonable project.
@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableMinter.carbonable_project_address();
}

// @notice Return the associated payment token.
// @return payment_token_address The address of the ERC20 token that will be used during sales.
@view
func getPaymentTokenAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    payment_token_address: felt
) {
    return CarbonableMinter.payment_token_address();
}

// @notice Return the pre sale status.
// @return pre_sale_open TRUE if presale is open, FALSE otherwise.
@view
func isPreSaleOpen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    pre_sale_open: felt
) {
    return CarbonableMinter.pre_sale_open();
}

// @notice Return the public sale status.
// @return public_sale_open TRUE if public sale is open, FALSE otherwise.
@view
func isPublicSaleOpen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    public_sale_open: felt
) {
    return CarbonableMinter.public_sale_open();
}

// @notice Return the max value that can be purchased in a single tx.
// @return max_value_per_tx The max value that can be purchased in a single tx.
@view
func getMaxValuePerTx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_value_per_tx: felt
) {
    return CarbonableMinter.max_value_per_tx();
}

// @notice Return the min value that can be purchased in a single tx.
// @return min_value_per_tx The max value that can be purchased in a single tx.
@view
func getMinValuePerTx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    min_value_per_tx: felt
) {
    return CarbonableMinter.min_value_per_tx();
}

// @notice Return the unit price per token.
// @return unit_price The unit price per token.
@view
func getUnitPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    unit_price: felt
) {
    return CarbonableMinter.unit_price();
}

// @notice Return the reserved value available for airdrops.
// @return reserved_value The reserved value available for airdrops.
@view
func getReservedValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    reserved_value: felt
) {
    return CarbonableMinter.reserved_value();
}

// @notice Return the max value available.
// @return max_value The max value.
@view
func getMaxValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_value: felt
) {
    return CarbonableMinter.max_value();
}

// @notice Return the whitelist merkle root, 0 means it has not been set yet.
// @return whitelist_merkle_root The merkle root.
@view
func getWhitelistMerkleRoot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    whitelist_merkle_root: felt
) {
    return CarbonableMinter.whitelist_merkle_root();
}

// @notice Return the whitelist allocation for a given account.
// @param account The address of the account to check.
// @param allocation The allocation to check.
// @param proof_len The length of the proof array.
// @param proof The merkle proof associated to the account and allocation.
// @return allocation 0 if not whitelisted, value otherwise.
@view
func getWhitelistAllocation{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, allocation: felt, proof_len: felt, proof: felt*
) -> (allocation: felt) {
    return CarbonableMinter.whitelist_allocation(account, allocation, proof_len, proof);
}

// @notice Return the value already minted by an account of the whitelist allocation.
// @param account The address of the account to check.
// @return value The value already claimed.
@view
func getClaimedValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (value: felt) {
    return CarbonableMinter.claimed_value(account);
}

// @notice Return the sold out status.
// @return status TRUE if sold out else FALSE.
@view
func isSoldOut{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    status: felt
) {
    return CarbonableMinter.sold_out();
}

// @notice Return the project slot where tokens will be minted.
// @return slot The project slot.
@view
func getCarbonableProjectSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (slot: Uint256) {
    return CarbonableMinter.carbonable_project_slot();
}

//
// Externals
//

// @notice Set the payment token address.
// @dev Only callable by the contract owner.
// @param payment_token_address The address of the payment token.
@external
func setWhitelistMerkleRoot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    whitelist_merkle_root: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_whitelist_merkle_root(whitelist_merkle_root);
}

// @notice Set a new public sale status (1 to open, 0 otherwise).
// @dev Only callable by the contract owner.
// @param public_sale_open The public sale status.
@external
func setPublicSaleOpen{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    public_sale_open: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_public_sale_open(public_sale_open);
}

// @notice Set a new max value per tx during purchase.
// @dev Only callable by the contract owner.
// @param max_value_per_tx The max value per tx.
@external
func setMaxValuePerTx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    max_value_per_tx: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_max_value_per_tx(max_value_per_tx);
}

// @notice Set a new min value per tx during purchase.
// @dev Only callable by the contract owner.
// @param min_value_per_tx The min value per tx.
@external
func setMinValuePerTx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    min_value_per_tx: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_min_value_per_tx(min_value_per_tx);
}

// @notice Set a new unit price per token.
// @dev Only callable by the contract owner.
// @param unit_price The unit price.
@external
func setUnitPrice{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    unit_price: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.set_unit_price(unit_price);
}

// @notice Decrease the reserved value for airdrops by the given value.
// @dev Only callable by the contract owner.
// @param value The value to substract to the reserved value.
@external
func decreaseReservedValue{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: felt
) {
    Ownable.assert_only_owner();
    return CarbonableMinter.decrease_reserved_value(value);
}

// @notice Increase the reserved value for airdrops by the given value.
// @dev Only callable by the contract owner.
//   The caller can't be the zero address.
//   The value must be less than or equal to the available reserved value.
//   The value must be less than or equal to the available value.
// @param value The value to add to the reserved value.
// @return success TRUE if it succeeded, FALSE otherwise.
@external
func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, value: felt
) -> (success: felt) {
    Ownable.assert_only_owner();
    return CarbonableMinter.airdrop(to, value);
}

// @notice Transfer the smart contract balance to the contract owner.
// @dev The caller must have the WITHDRAWER_ROLE role.
//   The transfer must succeed.
// @return success TRUE if it succeeded, FALSE otherwise.
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
// @param token_address The token address to transfer.
// @param recipient The address to receive tokens.
// @param amount The amount of token to transfer.
// @return success TRUE if it succeeded, FALSE otherwise.
@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_address: felt, recipient: felt, amount: Uint256
) -> (success: felt) {
    Ownable.assert_only_owner();
    return CarbonableMinter.transfer(token_address, recipient, amount);
}

// @notice Purchase -value- while proving the caller is part of the merkle tree during pre-sale.
// @dev The pre-sale must be open.
//   The caller must be part of the merkle tree.
//   The value must be not null.
//   The value must be less than or equal to the max buy per tx.
//   The value must be less than or equal to the remaining whitelisted value.
//   The value must be less than or equal to the available value.
//   The transfer must succeed.
// @param allocation The associated value recorded in the merkle root.
// @param proof_len The proof array length.
// @param proof The merkle proof associated to the account and allocation.
// @param value The token value to buy.
// @param force A boolean allowing to spend less than desired in case of low supply left.
// @return success TRUE if it succeeded, FALSE otherwise.
@external
func preBuy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    allocation: felt, proof_len: felt, proof: felt*, value: felt, force: felt
) -> (success: felt) {
    return CarbonableMinter.pre_buy(allocation, proof_len, proof, value, force);
}

// @notice Purchase -value- while public sale is open.
// @dev The public sale must be open.
//   The caller can't be the zero address.
//   The value must be not null.
//   The value must be less than or equal to the max value per tx.
//   The value must be less than or equal to the available value.
//   The transfer must succeed.
// @param value The value to buy.
// @param force A boolean allowing to spend less than desired in case of low supply left.
// @return success TRUE if it succeeded, FALSE otherwise.
@external
func publicBuy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: felt, force: felt
) -> (success: felt) {
    return CarbonableMinter.public_buy(value, force);
}
