// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.offset.library import CarbonableOffseter
from src.utils.access.library import CarbonableAccessControl
from src.yield.library import CarbonableYielder

//
// Initializer
//

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated initializer that mainly stores the inputs.
// @param carbonable_project_address The address of the Carbonable project.
// @param carbonable_project_slot The slot of the Carbonable project.
// @param carbonable_offseter_address The address of the Carbonable offseter.
// @param payment_token_address The address of the ERC20 token that will be used for rewards.
// @param owner The owner and Admin address.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt,
    carbonable_project_slot: Uint256,
    carbonable_offseter_address: felt,
    payment_token_address: felt,
    owner: felt,
) {
    CarbonableOffseter.initializer(carbonable_project_address, carbonable_project_slot);
    CarbonableYielder.initializer(
        carbonable_offseter_address=carbonable_offseter_address,
        payment_token_address=payment_token_address,
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
// @dev This function is only callable by the admin.
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
// @dev This function is only callable by the admin.
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
// @dev This function is only callable by the owner.
//   The new owner can be the zero address.
// @param new_owner The address of the new owner.
@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

// @notice Renounce ownership.
// @dev This function is only callable by the owner.
@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

// @notice Get the snapshoter.
// @return snapshoter The address of the snapshoter.
@view
func getSnapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    snapshoter: felt
) {
    return CarbonableAccessControl.get_snapshoter();
}

// @notice Set the snapshoter.
// @dev This function is only callable by the owner.
// @param snapshoter The address of the snapshoter.
@external
func setSnapshoter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    snapshoter: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_snapshoter(snapshoter);
    return ();
}

// @notice Get the provisioner.
// @return provisioner The address of the provisioner.
@view
func getProvisioner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    provisioner: felt
) {
    return CarbonableAccessControl.get_provisioner();
}

// @notice Set the provisioner.
// @dev This function is only callable by the owner.
// @param provisioner The address of the provisioner.
@external
func setProvisioner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    provisioner: felt
) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_provisioner(provisioner);
    return ();
}

//
// ERC165
//

// @notice Return the ability status to support the provided interface (EIP 165).
// @param interfaceId Interface id.
// @return success TRUE if supported else FALSE.
@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

//
// Getters
//

// @notice Return the associated carbonable project address.
// @return carbonable_project_address The address of the corresponding Carbonable project.
@view
func getCarbonableProjectAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_address: felt) {
    return CarbonableOffseter.carbonable_project_address();
}

// @notice Return the associated carbonable project slot.
// @return carbonable_project_slot The slot of the corresponding Carbonable project.
@view
func getCarbonableProjectSlot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_project_slot: Uint256) {
    return CarbonableOffseter.carbonable_project_slot();
}

// @notice Return the associated carbonable offseter.
// @return carbonable_offseter_address The address of the corresponding Carbonable offseter.
@view
func getCarbonableOffseterAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) -> (carbonable_offseter_address: felt) {
    return CarbonableYielder.carbonable_offseter_address();
}

// @notice Return the associated payment token.
// @return payment_token_address The address of the ERC20 token that will be used for rewards.
@view
func getPaymentTokenAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    payment_token_address: felt
) {
    return CarbonableYielder.payment_token_address();
}

// @notice Return the total value deposited balance of the project.
// @return value The total value deposited.
@view
func getTotalDeposited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    value: Uint256
) {
    return CarbonableOffseter.total_deposited();
}

// @notice Return the total absorption of the project.
// @return total_absorption The total absorption.
@view
func getTotalAbsorption{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_absorption: felt
) {
    return CarbonableOffseter.total_absorption();
}

// @notice Return the total provisioned of the yielder.
// @return total_provisioned The total provisioned.
@view
func getTotalProvisioned{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    total_provisioned: felt
) {
    return CarbonableYielder.total_provisioned();
}

// @notice Return the total deposited value of the provided address.
// @param address The address to query.
// @return value The total value.
@view
func getDepositedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (value: Uint256) {
    return CarbonableOffseter.deposited_of(address=address);
}

// @notice Return the total absorption of the provided address.
// @param address The address to query.
// @return absorption The total absorption.
@view
func getAbsorptionOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (absorption: felt) {
    return CarbonableOffseter.absorption_of(address=address);
}

// @notice Return the total claimable balance of the provided address.
// @param address The address to query.
// @return claimable The total claimable.
@view
func getClaimableOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (claimable: felt) {
    return CarbonableYielder.claimable_of(address=address);
}

// @notice Return the total claimed balance of the provided address.
// @param address The address to query.
// @return claimed The total claimed.
@view
func getClaimedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (claimed: felt) {
    return CarbonableYielder.claimed_of(address=address);
}

// @notice Return the associated carbonable vester.
// @return time The last snapshot time.
@view
func getSnapshotedTime{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    time: felt
) {
    return CarbonableYielder.snapshoted_time();
}

// @notice Return the snapshoted absorption of the provided address.
// @param address The address of the user.
// @return absorption The snapshoted absorption.
@view
func getSnapshotedOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (absorption: felt) {
    return CarbonableYielder.snapshoted_of(address=address);
}

//
// Externals
//

// @notice Deposit tokens to the project.
// @dev Token id must be owned by the caller.
// @param token_id The token id.
// @param value The value to transfer.
// @return success The success status.
@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, value: Uint256
) -> (success: felt) {
    return CarbonableOffseter.deposit(token_id=token_id, value=value);
}

// @notice Withdraw the specified value to a new token.
// @param value The value to withdraw.
// @return success The success status.
@external
func withdrawTo{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    value: Uint256
) -> (success: felt) {
    return CarbonableOffseter.withdraw_to(value=value);
}

// @notice Withdraw the specified value into the specified token.
// @dev Token id must be owned by the caller.
// @param token_id The token id.
// @param value The value to withdraw.
// @return success The success status.
@external
func withdrawToToken{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256, value: Uint256
) -> (success: felt) {
    return CarbonableOffseter.withdraw_to_token(token_id=token_id, value=value);
}

// @notice Claim the claimable amount of ERC-20.
// @return success The success status.
@external
func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (success: felt) {
    return CarbonableYielder.claim();
}

// @notice Snapshot the current state of claimable and claimed per user.
// @dev The caller must have the SNAPSHOTER_ROLE role.
// @return success The success status.
@external
func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    CarbonableAccessControl.assert_only_snapshoter();
    return CarbonableYielder.snapshot();
}

// @notice Provision the yielder with the amount or ERC-20 value of carbon credits sold for
//   the snapshoted period.
// @dev Snapshot must have been executed before.
//   The caller must have the PROVISIONER_ROLE role.
// @param amount The amount of ERC-20.
// @return success The success status.
@external
func provision{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: felt) -> (
    success: felt
) {
    CarbonableAccessControl.assert_only_provisioner();
    return CarbonableYielder.provision(amount=amount);
}
