// Core deps

use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::{Into, TryInto};
use zeroable::Zeroable;
use debug::PrintTrait;
use hash::HashStateTrait;
use pedersen::PedersenTrait;

// Starknet deps

use starknet::ContractAddress;
use starknet::deploy_syscall;
use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};

// External deps

use alexandria_data_structures::merkle_tree::{
    Hasher, MerkleTree, pedersen::PedersenHasherImpl, MerkleTreeTrait,
};
use openzeppelin::account::account::Account;
use openzeppelin::token::erc20::erc20::ERC20;
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
use cairo_erc_3525::presets::erc3525_mintable_burnable::{
    IExternalDispatcher as IERC3525Dispatcher, IExternalDispatcherTrait as IERC3525DispatcherTrait
};

// Components

use carbon::components::absorber::interface::{IAbsorberDispatcher, IAbsorberDispatcherTrait};
use carbon::components::access::interface::{IMinterDispatcher, IMinterDispatcherTrait};
use carbon::components::mint::interface::{IMintDispatcher, IMintDispatcherTrait};

// Contracts

use carbon::contracts::project::{
    Project, IExternalDispatcher as IProjectDispatcher,
    IExternalDispatcherTrait as IProjectDispatcherTrait
};
use carbon::contracts::minter::Minter;

// Constants

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 6;
const SLOT: u256 = 1;
const VALUE: u256 = 10;

const MAX_VALUE_PER_TX: u256 = 5;
const MIN_VALUE_PER_TX: u256 = 1;
const MAX_VALUE: u256 = 10;
const UNIT_PRICE: u256 = 10;
const RESERVED_VALUE: u256 = 4;
const ALLOCATION: felt252 = 5;
const BILLION: u256 = 1000000000000;

// Signers

#[derive(Drop)]
struct Signers {
    owner: ContractAddress,
    anyone: ContractAddress,
}

#[derive(Drop)]
struct Contracts {
    project: ContractAddress,
    erc20: ContractAddress,
    minter: ContractAddress,
}

fn deploy_account(public_key: felt252) -> ContractAddress {
    let mut calldata = array![public_key];
    let (address, _) = deploy_syscall(
        Account::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Account deploy failed');
    address
}

fn deploy_project(owner: ContractAddress) -> ContractAddress {
    // [Deploy]
    let mut calldata = array![NAME, SYMBOL, DECIMALS.into(), owner.into()];
    let (address, _) = deploy_syscall(
        Project::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Project deploy failed');
    // [Setup] Project
    set_contract_address(owner);
    let absorber = IAbsorberDispatcher { contract_address: address };
    absorber.set_project_value(SLOT, VALUE);
    address
}

fn deploy_erc20(owner: ContractAddress) -> ContractAddress {
    let mut calldata = array![NAME, SYMBOL, BILLION.low.into(), 0, owner.into()];
    let (address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('ERC20 deploy failed');
    address
}

fn deploy_minter(
    project: ContractAddress, erc20: ContractAddress, owner: ContractAddress
) -> ContractAddress {
    let public_sale_open: bool = false;
    let enable_VALUE_PER_TX: bool = true;
    let mut calldata: Array<felt252> = array![
        project.into(),
        SLOT.low.into(),
        SLOT.high.into(),
        erc20.into(),
        public_sale_open.into(), // public_sale_open = false
        enable_VALUE_PER_TX.into(), // enable_VALUE_PER_TX = true
        MAX_VALUE_PER_TX.low.into(),
        MAX_VALUE_PER_TX.high.into(),
        MIN_VALUE_PER_TX.low.into(),
        MIN_VALUE_PER_TX.high.into(),
        MAX_VALUE.low.into(),
        MAX_VALUE.high.into(),
        UNIT_PRICE.low.into(),
        UNIT_PRICE.high.into(),
        RESERVED_VALUE.low.into(),
        RESERVED_VALUE.high.into(),
        owner.into(),
    ];
    let (address, _) = deploy_syscall(
        Minter::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Minter deploy failed');
    address
}

fn setup_project(project: ContractAddress, minter: ContractAddress, signers: @Signers) {
    // Prank caller as owner
    set_contract_address(*signers.owner);
    // Grant minter rights to minter
    let project_minter = IMinterDispatcher { contract_address: project };
    project_minter.add_minter(SLOT, minter);
}

fn setup_erc20(erc20: ContractAddress, signers: @Signers) {
    let token = IERC20Dispatcher { contract_address: erc20 };
    // Owner sends tokens to anyone
    set_contract_address(*signers.owner);
    token.transfer(*signers.anyone, BILLION / 2);
}


fn setup_minter(project: ContractAddress, minter: ContractAddress, signers: @Signers) {
    let project = IERC721Dispatcher { contract_address: project };
    // Owner approve minter to spend his tokens
    set_contract_address(*signers.owner);
    project.set_approval_for_all(minter, true);
    // Anyone approve minter to spend his tokens
    set_contract_address(*signers.anyone);
    project.set_approval_for_all(minter, true);
}

fn setup() -> (Signers, Contracts) {
    // Deploy
    let signers = Signers { owner: deploy_account('OWNER'), anyone: deploy_account('ANYONE'), };
    let project = deploy_project(signers.owner);
    let erc20 = deploy_erc20(signers.owner);
    let minter = deploy_minter(project, erc20, signers.owner);

    // Setup
    setup_project(project, minter, @signers);
    setup_erc20(erc20, @signers);
    setup_minter(project, minter, @signers);

    // Return
    let contracts = Contracts { project: project, erc20: erc20, minter: minter, };
    (signers, contracts)
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Caller is not the owner', 'ENTRYPOINT_FAILED',))]
fn test_minter_setup_whitelist_revert_not_owner() {
    let (signers, contracts) = setup();
    // [Setup] Whitelist
    set_contract_address(signers.anyone);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_whitelist_merkle_root(1);
}

#[test]
#[available_gas(200_000_000)]
fn test_minter_pre_buy() {
    let (signers, contracts) = setup();
    // [Setup] Compute merkle tree and proof
    let mut state = PedersenTrait::new(signers.owner.into());
    state = state.update(1);
    let left = state.finalize();
    let mut state = PedersenTrait::new(signers.anyone.into());
    state = state.update(ALLOCATION);
    let right = state.finalize();
    let leaves: Array<felt252> = array![left, right];
    let mut tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
    let proof = tree.compute_proof(leaves, 1);
    let root = tree.compute_root(right, proof);
    // [Setup] Whitelist
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_whitelist_merkle_root(root);
    // [Assert] Whitelist buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * ALLOCATION.into());
    minter.pre_buy(ALLOCATION, proof, 5, false);
    // [Assert] Sold out
    let status = minter.is_sold_out();
    assert(!status, 'Wrong sold out status');
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Caller is not whitelisted', 'ENTRYPOINT_FAILED',))]
fn test_minter_pre_buy_revert_not_whitelisted() {
    let (signers, contracts) = setup();
    // [Setup] Whitelist
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_whitelist_merkle_root(1);
    // [Assert] Whitelist buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * ALLOCATION.into());
    minter.pre_buy(ALLOCATION, array![1, 2].span(), 5, false);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Pre sale is closed', 'ENTRYPOINT_FAILED',))]
fn test_minter_pre_buy_revert_closed() {
    let (signers, contracts) = setup();
    // [Assert] Whitelist buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * ALLOCATION.into());
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.pre_buy(ALLOCATION, array![1, 2].span(), 5, false);
}

#[test]
#[available_gas(200_000_000)]
fn test_minter_airdrop() {
    let (signers, contracts) = setup();
    // [Setup] Compute merkle tree and proof
    let mut state = PedersenTrait::new(signers.owner.into());
    state = state.update(1);
    let left = state.finalize();
    let mut state = PedersenTrait::new(signers.anyone.into());
    state = state.update(ALLOCATION);
    let right = state.finalize();
    let leaves: Array<felt252> = array![left, right];
    let mut tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
    let proof = tree.compute_proof(leaves, 1);
    let root = tree.compute_root(right, proof);
    // [Setup] Whitelist
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_whitelist_merkle_root(root);
    // [Assert] Pre buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * MAX_VALUE);
    minter.pre_buy(ALLOCATION, proof, 5, false);
    // [Assert] Airdrop
    set_contract_address(signers.owner);
    minter.airdrop(signers.anyone, 3);
    // [Assert] Open public sale
    minter.set_public_sale_open(true);
    assert(minter.is_public_sale_open(), 'Public sale should be open');
    minter.update_reserved_value(0);
    // [Assert] Public buy
    set_contract_address(signers.anyone);
    minter.public_buy(1, false);
    minter.public_buy(2, true);
    // [Assert] Withdraw
    set_contract_address(signers.owner);
    minter.withdraw();
}

#[test]
#[available_gas(200_000_000)]
fn test_remaining_value() {
    let (signers, contracts) = setup();
    // [Setup] Minter
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_public_sale_open(true);
    // [Assert] initial reserve value
    assert(minter.get_reserved_value() == RESERVED_VALUE, 'Wrong init reserved value');
    assert(minter.get_remaining_value() == VALUE - RESERVED_VALUE, 'Wrong init remaining value');
    // [Assert] Public buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * MAX_VALUE);
    minter.public_buy(5, false);
    assert(minter.get_remaining_value() == 1, 'Wrong remaining value post buy');
}

#[test]
#[available_gas(200_000_000)]
fn test_update_reserve() {
    let (signers, contracts) = setup();
    // [Setup] Minter
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    // [Assert] initial reserve value
    assert(minter.get_reserved_value() == RESERVED_VALUE, 'Wrong init reserved value');
    // [Assert] update reserve value
    minter.update_reserved_value(1);
    assert(minter.get_reserved_value() == 1, 'Wrong reserved value');
}

#[test]
#[available_gas(200_000_000)]
fn test_minter_remaining_after_decrease_reserved_update() {
    let (signers, contracts) = setup();
    // [Setup] Minter
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_public_sale_open(true);
    // [Assert] initial reserve value
    assert(minter.get_reserved_value() == RESERVED_VALUE, 'Wrong init reserved value');
    assert(minter.get_remaining_value() == VALUE - RESERVED_VALUE, 'Wrong init remaining value');
    // [Assert] Public buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * MAX_VALUE);
    minter.public_buy(5, false);
    assert(minter.get_remaining_value() == 1, 'Wrong remaining value post buy');
    // [Assert] update reserve value
    set_contract_address(signers.owner);
    minter.update_reserved_value(2);
    assert(minter.get_remaining_value() == 3, 'Wrong remaining post update');
}

#[test]
#[available_gas(200_000_000)]
fn test_minter_remaining_after_increase_reserved_update() {
    let (signers, contracts) = setup();
    // [Setup] Minter
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_public_sale_open(true);
    // [Assert] initial reserve value
    assert(minter.get_reserved_value() == RESERVED_VALUE, 'Wrong init reserved value');
    assert(minter.get_remaining_value() == VALUE - RESERVED_VALUE, 'Wrong init remaining value');
    // [Assert] Public buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * MAX_VALUE);
    minter.public_buy(5, false);
    assert(minter.get_remaining_value() == 1, 'Wrong remaining value post buy');
    // [Assert] update reserve value
    set_contract_address(signers.owner);
    minter.update_reserved_value(5);
    assert(minter.get_remaining_value() == 0, 'Wrong remaining post update');
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Not enough remaining value', 'ENTRYPOINT_FAILED',))]
fn test_minter_reserved_revert_mint_too_much() {
    let (signers, contracts) = setup();
    // [Setup] Minter
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_public_sale_open(true);
    // [Assert] initial reserve value
    assert(minter.get_reserved_value() == RESERVED_VALUE, 'Wrong init reserved value');
    assert(minter.get_remaining_value() == VALUE - RESERVED_VALUE, 'Wrong init remaining value');
    // [Assert] Public buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * MAX_VALUE);
    minter.public_buy(5, false);
    assert(minter.get_remaining_value() == 1, 'Wrong remaining value post buy');
    // [Assert] update reserve value
    set_contract_address(signers.owner);
    minter.update_reserved_value(6);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Not enough remaining value', 'ENTRYPOINT_FAILED',))]
fn test_minter_reserved_revert_not_enough_remaining_value() {
    let (signers, contracts) = setup();
    // [Assert] Airdrop
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.update_reserved_value(11);
}


#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Not enough value', 'ENTRYPOINT_FAILED',))]
fn test_minter_public_buy_revert_not_enough_available_value() {
    let (signers, contracts) = setup();
    // [Assert] Open public sale
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_public_sale_open(true);
    // [Assert] Pre buy
    set_contract_address(signers.anyone);
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    erc20.approve(contracts.minter, UNIT_PRICE * 7);
    minter.public_buy(5, false);
    minter.public_buy(2, false);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Not enough reserved value', 'ENTRYPOINT_FAILED',))]
fn test_minter_airdrop_revert_not_enough_reserved_value() {
    let (signers, contracts) = setup();
    // [Assert] Airdrop
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.airdrop(signers.anyone, 5);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Not enough value', 'ENTRYPOINT_FAILED',))]
fn test_minter_airdrop_revert_not_enough_value() {
    let (signers, contracts) = setup();
    // [Assert] Airdrop
    set_contract_address(signers.owner);
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.airdrop(signers.anyone, 11);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Caller is not the owner', 'ENTRYPOINT_FAILED',))]
fn test_minter_set_public_sale_revert_not_owner() {
    let (signers, contracts) = setup();
    // [Assert] Open public sale
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_public_sale_open(true);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Caller is not the owner', 'ENTRYPOINT_FAILED',))]
fn test_minter_set_max_value_revert_not_owner() {
    let (signers, contracts) = setup();
    // [Assert] Open public sale
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_max_value_per_tx(10);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Caller is not the owner', 'ENTRYPOINT_FAILED',))]
fn test_minter_set_min_value_revert_not_owner() {
    let (signers, contracts) = setup();
    // [Assert] Open public sale
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_min_value_per_tx(2);
}

#[test]
#[available_gas(200_000_000)]
#[should_panic(expected: ('Caller is not the owner', 'ENTRYPOINT_FAILED',))]
fn test_minter_set_unit_price_revert_not_owner() {
    let (signers, contracts) = setup();
    // [Assert] Open public sale
    let minter = IMintDispatcher { contract_address: contracts.minter };
    minter.set_unit_price(1);
}
