use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::{ Into, TryInto };
use starknet::ContractAddress;
use starknet::deploy_syscall;
use starknet::contract_address_try_from_felt252;
use starknet::testing;
use debug::PrintTrait;

use super::mocks::project::project;
use super::mocks::erc20::erc20;
use super::super::yielder::yielder;
use super::super::interfaces::yielder::{IYielder, IYielderDispatcher, IYielderDispatcherTrait};
use super::super::interfaces::farmer::{IFarmer, IFarmerDispatcher, IFarmerDispatcherTrait};
use super::super::interfaces::ownable::{IOwnable, IOwnableDispatcher, IOwnableDispatcherTrait};
use super::super::yielder::yielder::{
    ContractState as YielderContractState,
    InternalTrait
};

const SLOT : u256 = 1;

fn deploy_erc20() -> ContractAddress {
    let mut calldata = ArrayTrait::<felt252>::new();
    calldata.append(1);  // initial_supply_low
    calldata.append(0);  // initial_supply_high
    calldata.append(1);  // initial_supply_recipient
    let (address, _) = deploy_syscall(
        erc20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    ).unwrap();
    address
}

fn deploy_project() -> ContractAddress {
    let mut calldata = ArrayTrait::<felt252>::new();
    let (address, _) = deploy_syscall(
        project::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    ).unwrap();
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
    ).unwrap();
    address
}

#[test]
#[available_gas(20000000)]
fn test_deposit() {
    let yielder = deploy_yielder();
    let caller = IOwnableDispatcher { contract_address: yielder }.owner();
    testing::set_contract_address(caller);
    IFarmerDispatcher{ contract_address: yielder }.deposit(token_id: 1_u256, value: 1000_u256);
}


