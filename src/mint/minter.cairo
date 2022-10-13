// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable

// Local dependencies
from src.mint.library import CarbonableMinter

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt,
    carbonable_project_address: felt,
    payment_token_address: felt,
    public_sale_open: felt,
    max_buy_per_tx: felt,
    unit_price: Uint256,
    max_supply_for_mint: Uint256,
    reserved_supply_for_mint: Uint256,
) {
    // Desc:
    //   Initialize the contract with the given parameters -
    //   This constructor uses a dedicated initializer that mainly stores the inputs
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   owner(felt): Owner address
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    //   payment_token_address(felt): Address of the ERC20 token that will be used during sales
    //   public_sale_open(felt): 1 to open the public sale right after deployment, 0 otherwise
    //   max_buy_per_tx(felt): Max number of NFTs that can be purchased in a single tx
    //   unit_price(Uint256): Price per token (based on ERC20 token defined as -payment_token_address-)
    //   max_supply_for_mint(Uint256): Max supply available whatever the way to mint
    //   reserved_supply_for_mint(Uint256): Supply reserved to be airdropped
    // Returns:
    //   None
    // Raises:
    //   unit_price: unit_price is not a valid Uint256
    //   max_supply_for_mint: max_supply_for_mint is not a valid Uint256
    //   reserved_supply_for_mint: reserved_supply_for_mint is not a valid Uint256
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
    return ();
}

//
// Getters
//

@view
func carbonable_project_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    // Desc:
    //   Return the associated carbonable project
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    return CarbonableMinter.carbonable_project_address();
}

@view
func payment_token_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    payment_token_address: felt
) {
    // Desc:
    //   Return the associated payment token
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   payment_token_address(felt): Address of the ERC20 token that will be used during sales
    return CarbonableMinter.payment_token_address();
}

@view
func whitelisted_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    whitelisted_sale_open: felt
) {
    // Desc:
    //   Return the whitelisted sale status
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   whitelisted_sale_open(felt): 1 if presale is open, 0 otherwise
    return CarbonableMinter.whitelisted_sale_open();
}

@view
func public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    public_sale_open: felt
) {
    // Desc:
    //   Return the public sale status
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   public_sale_open(felt): 1 if public sale is open, 0 otherwise
    return CarbonableMinter.public_sale_open();
}

@view
func max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_buy_per_tx: felt
) {
    // Desc:
    //   Return the max amount that can be purchased in a single tx
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   max_buy_per_tx(felt): Max amount per tx
    return CarbonableMinter.max_buy_per_tx();
}

@view
func unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    unit_price: Uint256
) {
    // Desc:
    //   Return the unit price per token
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   unit_price(Uint256): Unit price
    return CarbonableMinter.unit_price();
}

@view
func reserved_supply_for_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (reserved_supply_for_mint: Uint256) {
    // Desc:
    //   Return the reserved supply available for airdrops
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   reserved_supply_for_mint(Uint256): Reserved supply
    return CarbonableMinter.reserved_supply_for_mint();
}

@view
func max_supply_for_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    max_supply_for_mint: Uint256
) {
    // Desc:
    //   Return the max supply available
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   max_supply_for_mint(Uint256): Max supply
    return CarbonableMinter.max_supply_for_mint();
}

@view
func whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    whitelist_merkle_root: felt
) {
    // Desc:
    //   Return the whitelist merkle root, 0 means it has not been set yet
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   whitelist_merkle_root(felt): The merkle root
    return CarbonableMinter.whitelist_merkle_root();
}

@view
func whitelisted_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, slots: felt, proof_len: felt, proof: felt*
) -> (slots: felt) {
    // Desc:
    //   Return the whitelist merkle root, 0 means it has not been set yet
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   account(felt): Account associated to slots
    //   slots(felt): Associated slots recorded in the merkle root
    //   proof_len(felt): proof array length
    //   proof(felt): Merkle proof associated to the account and slots
    // Returns:
    //   slots(felt): 0 if not whitelisted, amount of slots otherwise
    return CarbonableMinter.whitelisted_slots(account, slots, proof_len, proof);
}

@view
func claimed_slots{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (slots: felt) {
    // Desc:
    //   Return the slots already minted by an account using whitelist slots
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   account(felt): Account address
    // Returns:
    //   slots(felt): amount of claimed slots
    return CarbonableMinter.claimed_slots(account);
}

//
// Externals
//

@external
func set_whitelist_merkle_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    whitelist_merkle_root: felt
) {
    // Desc:
    //   Set a new merkle root, providing a not null merkle root opens the whitelist sale
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   whitelist_merkle_root(felt): New merkle root
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    return CarbonableMinter.set_whitelist_merkle_root(whitelist_merkle_root);
}

@external
func set_public_sale_open{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    public_sale_open: felt
) {
    // Desc:
    //   Set a new public sale status (1 to open, 0 otherwise)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   public_sale_open(felt): Public sale status
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    return CarbonableMinter.set_public_sale_open(public_sale_open);
}

@external
func set_max_buy_per_tx{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    max_buy_per_tx: felt
) {
    // Desc:
    //   Set a new max amount per tx during purchase
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   max_buy_per_tx(felt): Max amount per tx
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    return CarbonableMinter.set_max_buy_per_tx(max_buy_per_tx);
}

@external
func set_unit_price{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    unit_price: Uint256
) {
    // Desc:
    //   Set a new unit price per token
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   unit_price(Uint256): Unit price
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    return CarbonableMinter.set_unit_price(unit_price);
}

@external
func decrease_reserved_supply_for_mint{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}(slots: Uint256) {
    // Desc:
    //   Decrease the reserved supply for airdrops by the providing amount of slots
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   slots(Uint256): Amount of slots to substract to the reserved supply
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    return CarbonableMinter.decrease_reserved_supply_for_mint(slots);
}

@external
func airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, quantity: felt
) -> (success: felt) {
    // Desc:
    //   Decrease the reserved supply for airdrops by the providing amount of slots
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   slots(Uint256): Amount of slots to substract to the reserved supply
    // Returns:
    //   success(felt): 1 if it succeeded, 0 otherwise
    // Raises:
    //   caller: caller is not the contract owner
    //   caller: caller is the zero address
    //   quantity: not enough available NFTs regarding max supply
    //   quantity: not enough available reserved NFTs regarding reserved supply
    Ownable.assert_only_owner();
    return CarbonableMinter.airdrop(to, quantity);
}

@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    // Desc:
    //   Transfer the smart contract balance to the contract owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   success(felt): 1 if it succeeded, 0 otherwise
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.assert_only_owner();
    return CarbonableMinter.withdraw();
}

@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_address: felt, recipient: felt, amount: Uint256
) -> (success: felt) {
    // Desc:
    //   Transfer an amount of tokens specified by -token_address- to -recipient-
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_address(felt): Token address to transfer
    //   recipient(felt): Address to receive tokens
    //   amount(Uint256): Amount of token to transfer
    // Returns:
    //   success(felt): 1 if it succeeded, 0 otherwise
    // Raises:
    //   caller: caller is not the contract owner
    //   transfer: transfer fails
    Ownable.assert_only_owner();
    return CarbonableMinter.transfer(token_address, recipient, amount);
}

@external
func whitelist_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    slots: felt, proof_len: felt, proof: felt*, quantity: felt
) -> (success: felt) {
    // Desc:
    //   Purchase -quantity- tokens while proving the caller is part of the merkle tree while whitelist sale is open
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   slots(felt): Associated slots recorded in the merkle root
    //   proof_len(felt): proof array length
    //   proof(felt): Merkle proof associated to the account and slots
    //   quantity(felt): Quantity of tokens to buy
    // Returns:
    //   success(felt): 1 if it succeeded, 0 otherwise
    // Raises:
    //   contract: whitelist sale is not open
    //   caller: caller address is not whitelisted
    //   caller: caller is the zero address
    //   quantity: not enough whitelisted slots available
    //   quantity: quantity not allowed
    //   quantity: not enough available NFTs
    //   transfer: transfer failed
    return CarbonableMinter.whitelist_buy(slots, proof_len, proof, quantity);
}

@external
func public_buy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    quantity: felt
) -> (success: felt) {
    // Desc:
    //   Purchase -quantity- tokens while public sale is open
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   quantity(felt): Quantity of tokens to buy
    // Returns:
    //   success(felt): 1 if it succeeded, 0 otherwise
    // Raises:
    //   contract: public sale is not open
    //   caller: caller is the zero address
    //   quantity: quantity not allowed
    //   quantity: not enough available NFTs
    //   transfer: transfer failed
    return CarbonableMinter.public_buy(quantity);
}
