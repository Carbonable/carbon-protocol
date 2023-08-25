use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::{Into, TryInto};
use starknet::ContractAddress;
use starknet::deploy_syscall;
use starknet::contract_address_try_from_felt252;
use starknet::testing;
use zeroable::Zeroable;
use debug::PrintTrait;

use super::mocks::project::project;
use super::mocks::erc20::erc20;
use super::super::yielder::yielder;
use super::super::interfaces::yielder::{IYielder, IYielderDispatcher, IYielderDispatcherTrait};
use super::super::interfaces::farmer::{IFarmer, IFarmerDispatcher, IFarmerDispatcherTrait};
use super::super::interfaces::ownable::{IOwnable, IOwnableDispatcher, IOwnableDispatcherTrait};
use super::super::yielder::yielder::{ContractState as YielderContractState, InternalTrait};
use protocol::tests::constants::{SLOT, OWNER, ANYONE, SOMEONE};

const AMOUNT: u256 = 1000;

fn deploy_erc20() -> ContractAddress {
    let mut calldata = ArrayTrait::<felt252>::new();
    calldata.append(1); // initial_supply_low
    calldata.append(0); // initial_supply_high
    calldata.append(1); // initial_supply_recipient
    let (address, _) = deploy_syscall(
        erc20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}

fn deploy_project() -> ContractAddress {
    let mut calldata = ArrayTrait::<felt252>::new();
    let (address, _) = deploy_syscall(
        project::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}

fn deploy_yielder() -> ContractAddress {
    let mut calldata = ArrayTrait::<felt252>::new();
    calldata.append(deploy_project().into());
    calldata.append(SLOT.low.into());
    calldata.append(SLOT.high.into());
    calldata.append(deploy_erc20().into());
    calldata.append(1);

    let (address, _) = deploy_syscall(
        yielder::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();

    address
}

fn setup() -> ContractAddress {
    let address = deploy_yielder();
    let caller = IOwnableDispatcher { contract_address: address }.owner();
    testing::set_contract_address(caller);
    IFarmerDispatcher { contract_address: address }.add_price(time: 1000000_u64, price: 25_u256);
    address
}

#[test]
#[available_gas(20000000)]
fn test_deposit() {
    let yielder = setup();
    let caller = contract_address_try_from_felt252(ANYONE).unwrap();
    testing::set_contract_address(caller);
    IFarmerDispatcher { contract_address: yielder }.deposit(token_id: 1_u256, value: AMOUNT);
    let total_deposited = IFarmerDispatcher { contract_address: yielder }.get_total_deposited();
    assert(total_deposited == AMOUNT, 'Wrong total deposited');
    let user_deposited = IFarmerDispatcher { contract_address: yielder }.get_deposited_of(caller);
    assert(user_deposited == AMOUNT, 'Wrong user deposited');
}

#[test]
#[available_gas(20000000)]
fn test_withdraw() {
    let yielder = setup();
    let caller = contract_address_try_from_felt252(ANYONE).unwrap();
    testing::set_contract_address(caller);
    IFarmerDispatcher { contract_address: yielder }.deposit(token_id: 1_u256, value: AMOUNT);
    IFarmerDispatcher { contract_address: yielder }.withdraw_to(value: AMOUNT);
    let total_deposited = IFarmerDispatcher { contract_address: yielder }.get_total_deposited();
    assert(total_deposited == 0, 'Wrong total deposited');
    let user_deposited = IFarmerDispatcher { contract_address: yielder }.get_deposited_of(caller);
    assert(user_deposited == 0, 'Wrong user deposited');
}

