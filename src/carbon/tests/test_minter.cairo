use carbon::minter::minter::Minter;
use starknet::contract_address_const;
use starknet::ContractAddress;
use starknet::testing::set_caller_address;
use integer::u256;
use integer::u256_from_felt252;

//
// Constants
//

const UNIT_PRICE: felt252 = 1_felt252;
const MAX_VALUE_PER_TX: felt252 = 1000_felt252;
const MIN_VALUE_PER_TX: felt252 = 1_felt252;
const MAX_VALUE: felt252 = 1000000_felt252;
const RESERVED_VALUE: felt252 = 1000_felt252;

//
// Helper functions
//

fn setup() {
    // Set user as default caller
    let owner: ContractAddress = contract_address_const::<0xBA17>();
    let user: ContractAddress = contract_address_const::<0xABDE1>();
    set_caller_address(user);

    // Initialize contract
    let project_address: ContractAddress = contract_address_const::<1>();
    let project_slot: u256 = u256_from_felt252(1);
    let payment_token_address: ContractAddress = contract_address_const::<2>();
    let public_sale_open: bool = true;
    Minter::constructor(
        project_address,
        project_slot,
        payment_token_address,
        public_sale_open,
        MAX_VALUE_PER_TX,
        MIN_VALUE_PER_TX,
        MAX_VALUE,
        UNIT_PRICE,
        RESERVED_VALUE,
        owner,
    );
}

fn set_caller_as_zero() {
    set_caller_address(contract_address_const::<0>());
}

//
// Tests
//

#[test]
#[available_gas(2000000)]
fn test_initializer() {
    let project_address: ContractAddress = contract_address_const::<1>();
    let project_slot: u256 = u256_from_felt252(1);
    let payment_token_address: ContractAddress = contract_address_const::<2>();
    let public_sale_open: bool = true;
    Minter::initializer(
        project_address,
        project_slot,
        payment_token_address,
        public_sale_open,
        MAX_VALUE_PER_TX,
        MIN_VALUE_PER_TX,
        MAX_VALUE,
        UNIT_PRICE,
        RESERVED_VALUE,
    );

    assert(
        Minter::get_carbonable_project_address() == project_address, 'Should be PROJECT_ADDRESS'
    );
    assert(Minter::get_carbonable_project_slot() == project_slot, 'Should be PROJECT_SLOT');
    assert(Minter::get_payment_token_address() == payment_token_address, 'Should be TOKEN_ADDRESS');
    assert(Minter::get_max_value() == MAX_VALUE, 'Should be MAX_VALUE');
    assert(Minter::get_reserved_value() == RESERVED_VALUE, 'Should be RESERVED_VALUE');
}

#[test]
#[available_gas(2000000)]
fn test_constructor() {
    setup();
}

#[test]
#[available_gas(2000000)]
fn test_set_unit_price() {
    setup();
    assert(Minter::get_unit_price() == UNIT_PRICE, 'Should be UNIT_PRICE');
    let unit_price: felt252 = 2_felt252;
    Minter::set_unit_price(unit_price);
    assert(Minter::get_unit_price() == unit_price, 'Should be unit_price');
}

#[test]
#[available_gas(2000000)]
fn test_set_max_value_per_tx() {
    setup();
    assert(Minter::get_max_value_per_tx() == MAX_VALUE_PER_TX, 'Should be MAX_VALUE_PER_TX');
    let max_value_per_tx: felt252 = 2000_felt252;
    Minter::set_max_value_per_tx(max_value_per_tx);
    assert(Minter::get_max_value_per_tx() == max_value_per_tx, 'Should be max_value_per_tx');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('Minter: min_value <= max_value', ))]
fn test_set_max_value_per_tx_panic_too_low() {
    setup();
    assert(Minter::get_max_value_per_tx() == MAX_VALUE_PER_TX, 'Should be MAX_VALUE_PER_TX');
    let max_value_per_tx: felt252 = 0_felt252;
    Minter::set_max_value_per_tx(max_value_per_tx);
    assert(Minter::get_max_value_per_tx() == max_value_per_tx, 'Should be max_value_per_tx');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected = ('Minter: max_per_tx <= max_value', ))]
fn test_set_max_value_per_tx_panic_too_high() {
    setup();
    assert(Minter::get_max_value_per_tx() == MAX_VALUE_PER_TX, 'Should be MAX_VALUE_PER_TX');
    let max_value_per_tx: felt252 = 2000000_felt252;
    Minter::set_max_value_per_tx(max_value_per_tx);
    assert(Minter::get_max_value_per_tx() == max_value_per_tx, 'Should be max_value_per_tx');
}

#[test]
#[available_gas(2000000)]
fn test_set_min_value_per_tx() {
    setup();
    assert(Minter::get_min_value_per_tx() == MIN_VALUE_PER_TX, 'Should be MIN_VALUE_PER_TX');
    let min_value_per_tx: felt252 = 2_felt252;
    Minter::set_min_value_per_tx(min_value_per_tx);
    assert(Minter::get_min_value_per_tx() == min_value_per_tx, 'Should be min_value_per_tx');
}

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: approve from 0', ))]
// fn test_approve_from_zero() {
//     let (owner, supply) = setup();
//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     set_caller_as_zero();

//     ERC20::approve(spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: approve to 0', ))]
// fn test_approve_to_zero() {
//     let (owner, supply) = setup();
//     let spender: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::approve(spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test__approve() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::_approve(owner, spender, amount);
//     assert(ERC20::allowance(owner, spender) == amount, 'Spender not approved correctly');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: approve from 0', ))]
// fn test__approve_from_zero() {
//     let owner: ContractAddress = contract_address_const::<0>();
//     let spender: ContractAddress = contract_address_const::<1>();
//     let amount: u256 = u256_from_felt252(100);
//     ERC20::_approve(owner, spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: approve to 0', ))]
// fn test__approve_to_zero() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);
//     ERC20::_approve(owner, spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test_transfer() {
//     let (sender, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);
//     let success: bool = ERC20::transfer(recipient, amount);

//     assert(success, 'Should return true');
//     assert(ERC20::balance_of(recipient) == amount, 'Balance should eq amount');
//     assert(ERC20::balance_of(sender) == supply - amount, 'Should eq supply - amount');
//     assert(ERC20::total_supply() == supply, 'Total supply should not change');
// }

// #[test]
// #[available_gas(2000000)]
// fn test__transfer() {
//     let (sender, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);
//     ERC20::_transfer(sender, recipient, amount);

//     assert(ERC20::balance_of(recipient) == amount, 'Balance should eq amount');
//     assert(ERC20::balance_of(sender) == supply - amount, 'Should eq supply - amount');
//     assert(ERC20::total_supply() == supply, 'Total supply should not change');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('u256_sub Overflow', ))]
// fn test__transfer_not_enough_balance() {
//     let (sender, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = supply + u256_from_felt252(1);
//     ERC20::_transfer(sender, recipient, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: transfer from 0', ))]
// fn test__transfer_from_zero() {
//     let sender: ContractAddress = contract_address_const::<0>();
//     let recipient: ContractAddress = contract_address_const::<1>();
//     let amount: u256 = u256_from_felt252(100);
//     ERC20::_transfer(sender, recipient, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: transfer to 0', ))]
// fn test__transfer_to_zero() {
//     let (sender, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);
//     ERC20::_transfer(sender, recipient, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test_transfer_from() {
//     let (owner, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<2>();
//     let spender: ContractAddress = contract_address_const::<3>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::approve(spender, amount);

//     set_caller_address(spender);

//     let success: bool = ERC20::transfer_from(owner, recipient, amount);
//     assert(success, 'Should return true');

//     // Will dangle without setting as a var
//     let spender_allowance: u256 = ERC20::allowance(owner, spender);

//     assert(ERC20::balance_of(recipient) == amount, 'Should eq amount');
//     assert(ERC20::balance_of(owner) == supply - amount, 'Should eq suppy - amount');
//     assert(spender_allowance == u256_from_felt252(0), 'Should eq 0');
//     assert(ERC20::total_supply() == supply, 'Total supply should not change');
// }

// #[test]
// #[available_gas(2000000)]
// fn test_transfer_from_doesnt_consume_infinite_allowance() {
//     let (owner, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<2>();
//     let spender: ContractAddress = contract_address_const::<3>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::approve(spender, MAX_U256());

//     set_caller_address(spender);
//     ERC20::transfer_from(owner, recipient, amount);

//     let spender_allowance: u256 = ERC20::allowance(owner, spender);
//     assert(spender_allowance == MAX_U256(), 'Allowance should not change');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('u256_sub Overflow', ))]
// fn test_transfer_from_greater_than_allowance() {
//     let (owner, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<2>();
//     let spender: ContractAddress = contract_address_const::<3>();
//     let amount: u256 = u256_from_felt252(100);
//     let amount_plus_one: u256 = amount + u256_from_felt252(1);

//     ERC20::approve(spender, amount);

//     set_caller_address(spender);

//     ERC20::transfer_from(owner, recipient, amount_plus_one);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: transfer to 0', ))]
// fn test_transfer_from_to_zero_address() {
//     let (owner, supply) = setup();

//     let recipient: ContractAddress = contract_address_const::<0>();
//     let spender: ContractAddress = contract_address_const::<3>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::approve(spender, amount);

//     set_caller_address(spender);

//     ERC20::transfer_from(owner, recipient, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('u256_sub Overflow', ))]
// fn test_transfer_from_from_zero_address() {
//     let (owner, supply) = setup();

//     let zero_address: ContractAddress = contract_address_const::<0>();
//     let recipient: ContractAddress = contract_address_const::<2>();
//     let spender: ContractAddress = contract_address_const::<3>();
//     let amount: u256 = u256_from_felt252(100);

//     set_caller_address(zero_address);

//     ERC20::transfer_from(owner, recipient, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test_increase_allowance() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::approve(spender, amount);
//     let success: bool = ERC20::increase_allowance(spender, amount);
//     assert(success, 'Should return true');

//     let spender_allowance: u256 = ERC20::allowance(owner, spender);
//     assert(spender_allowance == amount + amount, 'Should be amount * 2');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: approve to 0', ))]
// fn test_increase_allowance_to_zero_address() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::increase_allowance(spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: approve from 0', ))]
// fn test_increase_allowance_from_zero_address() {
//     let (owner, supply) = setup();

//     let zero_address: ContractAddress = contract_address_const::<0>();
//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     set_caller_address(zero_address);

//     ERC20::increase_allowance(spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test_decrease_allowance() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::approve(spender, amount);
//     let success: bool = ERC20::decrease_allowance(spender, amount);
//     assert(success, 'Should return true');

//     let spender_allowance: u256 = ERC20::allowance(owner, spender);
//     assert(spender_allowance == amount - amount, 'Should be 0');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('u256_sub Overflow', ))]
// fn test_decrease_allowance_to_zero_address() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::decrease_allowance(spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('u256_sub Overflow', ))]
// fn test_decrease_allowance_from_zero_address() {
//     let (owner, supply) = setup();

//     let zero_address: ContractAddress = contract_address_const::<0>();
//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     set_caller_address(zero_address);

//     ERC20::decrease_allowance(spender, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test__spend_allowance_not_unlimited() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::_approve(owner, spender, supply);
//     ERC20::_spend_allowance(owner, spender, amount);
//     assert(ERC20::allowance(owner, spender) == supply - amount, 'Should eq supply - amount');
// }

// #[test]
// #[available_gas(2000000)]
// fn test__spend_allowance_unlimited() {
//     let (owner, supply) = setup();

//     let spender: ContractAddress = contract_address_const::<2>();
//     let max_minus_one: u256 = MAX_U256() - u256_from_felt252(1);

//     ERC20::_approve(owner, spender, MAX_U256());
//     ERC20::_spend_allowance(owner, spender, max_minus_one);

//     assert(ERC20::allowance(owner, spender) == MAX_U256(), 'Allowance should not change');
// }

// #[test]
// #[available_gas(2000000)]
// fn test__mint() {
//     let minter: ContractAddress = contract_address_const::<2>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::_mint(minter, amount);

//     let minter_balance: u256 = ERC20::balance_of(minter);
//     assert(minter_balance == amount, 'Should eq amount');

//     assert(ERC20::total_supply() == amount, 'Should eq total supply');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: mint to 0', ))]
// fn test__mint_to_zero() {
//     let minter: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::_mint(minter, amount);
// }

// #[test]
// #[available_gas(2000000)]
// fn test__burn() {
//     let (owner, supply) = setup();

//     let amount: u256 = u256_from_felt252(100);
//     ERC20::_burn(owner, amount);

//     assert(ERC20::total_supply() == supply - amount, 'Should eq supply - amount');
//     assert(ERC20::balance_of(owner) == supply - amount, 'Should eq supply - amount');
// }

// #[test]
// #[available_gas(2000000)]
// #[should_panic(expected = ('ERC20: burn from 0', ))]
// fn test__burn_from_zero() {
//     setup();
//     let zero_address: ContractAddress = contract_address_const::<0>();
//     let amount: u256 = u256_from_felt252(100);

//     ERC20::_burn(zero_address, amount);
// }


