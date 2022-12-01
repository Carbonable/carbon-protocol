// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.offset.library import CarbonableOffseter

//
// Initializer
//

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    carbonable_project_address: felt, owner: felt, proxy_admin: felt
) {
    // Desc:
    //   Initialize the contract with the given parameters -
    //   This constructor uses a dedicated initializer that mainly stores the inputs
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   carbonable_project_address(felt): Address of the corresponding Carbonable project
    //   owner(felt): Owner address
    //   proxy_admin(felt): Admin address
    // Returns:
    //   None
    CarbonableOffseter.initializer(carbonable_project_address);
    Ownable.initializer(owner);
    Proxy.initializer(proxy_admin);
    return ();
}

@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    // Desc:
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    // Explicit args:
    //   new_implementation(felt): new contract implementation
    // Raises:
    //   caller: caller is not a contract admin
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
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
    return CarbonableOffseter.carbonable_project_address();
}

@view
func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    status: felt
) {
    // Desc:
    //   Return the locked status of deposits and withdrawals
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   status(felt): Locked status (1 if locked else 0)
    return CarbonableOffseter.is_locked();
}

@view
func total_offsetable{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (total_offsetable: Uint256) {
    // Desc:
    //   Return the total offsetable balance of the provided address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): address
    // Returns:
    //   total_offsetable(Uint256): Total offsetable balance
    return CarbonableOffseter.total_offsetable(address=address);
}

@view
func total_offseted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (total_offseted: Uint256) {
    // Desc:
    //   Return the total offseted balance of the provided address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): address
    // Returns:
    //   total_offseted(Uint256): Total offseted balance
    return CarbonableOffseter.total_offseted(address=address);
}

@view
func total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    balance: Uint256
) {
    // Desc:
    //   Return the current number of tokens locked in the contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   balance(Uint256): Total balance of locked tokens
    return CarbonableOffseter.total_locked();
}

@view
func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
    balance: felt
) {
    // Desc:
    //   Return the current balance of a specified address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   address(felt): Address
    // Returns:
    //   balance(Uint256): Balance associated to the address
    return CarbonableOffseter.balance_of(address=address);
}

@view
func registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (address: felt) {
    // Desc:
    //   Return the registred owner of a token id (0 if token is not locked in the contract)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   address(felt): Registred owner address
    return CarbonableOffseter.registred_owner_of(token_id=token_id);
}

//
// Externals
//

@external
func offset{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (success: felt) {
    // Desc:
    //   Offset the current total offsetable of the caller address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   success(felt): Success status
    return CarbonableOffseter.offset();
}

@external
func snapshot{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    // Desc:
    //   Snapshot deposits
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   success(felt): Success status
    Ownable.assert_only_owner();
    return CarbonableOffseter.snapshot();
}

@external
func start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    unlocked_duration: felt, period_duration: felt, absorption: felt
) -> (success: felt) {
    // Desc:
    //   Start a new period (erase the current one)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   unlocked_duration(felt): Unlocked duration in seconds
    //   period_duration(felt): Period duration in seconds
    //   absorption(felt): Carbon absorption in ng of CO2
    // Returns:
    //   success(felt): Success status
    Ownable.assert_only_owner();
    return CarbonableOffseter.start_period(
        unlocked_duration=unlocked_duration, period_duration=period_duration, absorption=absorption
    );
}

@external
func stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    success: felt
) {
    // Desc:
    //   Stop the current period
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   success(felt): Success status
    Ownable.assert_only_owner();
    return CarbonableOffseter.stop_period();
}

@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    // Desc:
    //   Deposit the specified token id into the contract (lock)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   success(felt): Success status
    return CarbonableOffseter.deposit(token_id=token_id);
}

@external
func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (success: felt) {
    // Desc:
    //   Withdraw the specified token id into the contract
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   token_id(Uint256): Token id
    // Returns:
    //   success(felt): Success status
    return CarbonableOffseter.withdraw(token_id=token_id);
}
