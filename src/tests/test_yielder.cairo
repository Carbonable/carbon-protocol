use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::{Into, TryInto};
use zeroable::Zeroable;
use debug::PrintTrait;

use starknet::ContractAddress;
use starknet::deploy_syscall;
use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};

use openzeppelin::account::account::Account;
use openzeppelin::token::erc20::erc20::ERC20;
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};

use cairo_erc_3525::presets::erc3525_mintable_burnable::{IExternalDispatcher as IERC3525Dispatcher, IExternalDispatcherTrait as IERC3525DispatcherTrait};

use protocol::project::{Project, IExternalDispatcher as IProjectDispatcher, IExternalDispatcherTrait as IProjectDispatcherTrait};
use protocol::yielder::Yielder;

use protocol::absorber::interface::{IAbsorberDispatcher, IAbsorberDispatcherTrait};
use protocol::access::interface::{ICertifierDispatcher, ICertifierDispatcherTrait};
use protocol::access::interface::{IMinterDispatcher, IMinterDispatcherTrait};
use protocol::farm::interface::{IFarmDispatcher, IFarmDispatcherTrait};
use protocol::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};

// Project

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 6;
const SLOT: u256 = 1;
const TON_EQUIVALENT: u64 = 1_000_000;
const VALUE: u256 = 100;

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
    yielder: ContractAddress,
}

fn deploy_account(public_key: felt252) -> ContractAddress {
    let mut calldata = array![public_key];
    let (address, _) = deploy_syscall(
        Account::TEST_CLASS_HASH.try_into().expect('Account declare failed'), 0, calldata.span(), false
    ).expect('Account deploy failed');
    address
}

fn deploy_erc20(owner: ContractAddress) -> ContractAddress {
    let billion = 1000000000000;
    let mut calldata = array![NAME, SYMBOL, billion, 0, owner.into()];
    let (address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().expect('ERC20 declare failed'), 0, calldata.span(), false
    ).expect('ERC20 deploy failed');
    address
}

fn deploy_project(owner: ContractAddress) -> ContractAddress {
    let mut calldata = array![NAME, SYMBOL, DECIMALS.into(), owner.into()];
    let (address, _) = deploy_syscall(
        Project::TEST_CLASS_HASH.try_into().expect('Project declare failed'), 0, calldata.span(), false
    ).expect('Project deploy failed');
    address
}

fn deploy_yielder(project: ContractAddress, erc20: ContractAddress, owner: ContractAddress) -> ContractAddress {
    let mut calldata : Array<felt252> = array![project.into(), SLOT.low.into(), SLOT.high.into(), erc20.into(), owner.into()];
    let (address, _) = deploy_syscall(
        Yielder::TEST_CLASS_HASH.try_into().expect('Yielder declare failed'), 0, calldata.span(), false
    ).expect('Yielder deploy failed');
    address
}

fn setup_project(project: ContractAddress, signers: @Signers) {
    // Prank caller as owner
    set_contract_address(*signers.owner);
    // Grant certifier rights to owner
    let project = ICertifierDispatcher{ contract_address: project };
    project.set_certifier(SLOT, *signers.owner);
    // Setup absorptions
    let project = IAbsorberDispatcher{ contract_address: project.contract_address };
    let times : Array<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200, 1690848000, 1698796800, 2598134400];
    let absorptions : Array<u64> = array![0, 1179750, 2359500, 3539250, 4719000, 6685250, 8651500, 1573000000];
    project.set_absorptions(SLOT, times.span(), absorptions.span(), TON_EQUIVALENT);
}

fn setup_erc20(erc20: ContractAddress, yielder: ContractAddress, signers: @Signers) {
    let erc20 = IERC20Dispatcher { contract_address: erc20 };
    // Send token to yielder
    set_contract_address(*signers.owner);
    let amount = erc20.balance_of(*signers.owner);
    erc20.transfer(yielder, amount);
}

fn setup_yielder(project: ContractAddress, erc20: ContractAddress, yielder: ContractAddress, signers: @Signers) {
    // Setup prices
    set_contract_address(*signers.owner);
    let farmer = IFarmDispatcher{ contract_address: yielder };
    let times : Array<u64> = array![1651363200, 2598134400];
    let prices : Array<u256> = array![10, 10];
    farmer.set_prices(times.span(), prices.span());
    // Anyone approve yielder to spend his tokens
    set_contract_address(*signers.anyone);
    let project = IERC721Dispatcher{ contract_address: project };
    project.set_approval_for_all(yielder, true);
}

fn setup() -> (Signers, Contracts) {
    // Deploy
    let signers = Signers {
        owner: deploy_account('OWNER'),
        anyone: deploy_account('ANYONE'),
    };
    let project = deploy_project(signers.owner);
    let erc20 = deploy_erc20(signers.owner);
    let yielder = deploy_yielder(project, erc20, signers.owner);

    // Setup
    setup_project(project, @signers);
    setup_erc20(erc20, yielder, @signers);
    setup_yielder(project, erc20, yielder, @signers);

    // Return
    let contracts = Contracts {
        project: project,
        erc20: erc20,
        yielder: yielder,
    };
    (signers, contracts)
}

#[test]
#[available_gas(2_000_000_000)]
fn test_nominal_single_user_case() {
    let (signers, contracts) = setup();
    // Instantiate contracts
    let farmer = IFarmDispatcher{ contract_address: contracts.yielder };
    let yielder = IYieldDispatcher{ contract_address: contracts.yielder };
    let minter = IMinterDispatcher{ contract_address: contracts.project };
    let project = IProjectDispatcher{ contract_address: contracts.project };
    let absorber = IAbsorberDispatcher{ contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher{ contract_address: contracts.project };
    
    // Prank caller as owner
    set_contract_address(signers.owner);

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    let token_id = project.mint(signers.anyone, SLOT, VALUE);
    minter.revoke_minter(SLOT, signers.owner);

    // Setup project value
    let project_value = erc3525.total_value(SLOT);
    absorber.set_project_value(SLOT, project_value);

    // Prank caller as anyone
    set_contract_address(signers.anyone);

    // At t = 0
    set_block_timestamp(0);
    // Anyone deposits value 100
    farmer.deposit(token_id, VALUE);
    let deposited = farmer.get_deposited_of(signers.anyone);
    assert(deposited == VALUE, 'Wrong deposited');
    // Claimable is 0
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 0, 'Wrong claimable');
    // Claimed is 0
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 0, 'Wrong claimed');
    
    // At t = 1659312000
    set_block_timestamp(1659312000);
    // Claimable is 1179750
    let claimable = yielder.get_claimable_of(signers.anyone);
    claimable.print();
    // assert(claimable == 132064245, 'Wrong claimable');
    // assert(claimable == 1179750, 'Wrong claimable');
    // Claimed is 0
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 0, 'Wrong claimed');
    
    // At t = 1667260800
    set_block_timestamp(1667260800);
    // Anyone claims
    yielder.claim();
    
    // At t = 1675209600
    set_block_timestamp(1675209600);
    // Claimable is 1179750
    let claimable = yielder.get_claimable_of(signers.anyone);
    claimable.print();
    // assert(claimable == 1179750, 'Wrong claimable');
    // Claimed is 1179750
    let claimed = yielder.get_claimed_of(signers.anyone);
    claimed.print();
    // assert(claimed == 1179750, 'Wrong claimed');
    
    // At t = 1682899200
    set_block_timestamp(1682899200);
    // Anyone wtihdraws token #1
    farmer.withdraw_to_token(token_id, VALUE);
    // Total absorption is 4719000
    let absorption = farmer.get_total_absorption();
    absorption.print();
    // assert(absorption == 4719000, 'Wrong absorption');
    // Claimable is 2359500
    let claimable = yielder.get_claimable_of(signers.anyone);
    claimable.print();
    // assert(claimable == 2359500, 'Wrong claimable');
    // Claimed is 2359500
    let claimed = yielder.get_claimed_of(signers.anyone);
    claimed.print();
    // assert(claimed == 2359500, 'Wrong claimed');
    
    // At t = 1690848000
    set_block_timestamp(1690848000);
    // Claimable is 2359500
    let claimable = yielder.get_claimable_of(signers.anyone);
    claimable.print();
    // assert(claimable == 2359500, 'Wrong claimable');
    // Claimed is 1179750
    let claimed = yielder.get_claimed_of(signers.anyone);
    claimed.print();
    // assert(claimed == 1179750, 'Wrong claimed');
}

// #[test]
// #[available_gas(20000000)]
// fn test_deposit() {
//     let yielder = setup();
//     let caller = contract_address_try_from_felt252(ANYONE).unwrap();
//     testing::set_contract_address(caller);
//     IFarmerDispatcher { contract_address: yielder }.deposit(token_id: 1_u256, value: AMOUNT);
//     let total_deposited = IFarmerDispatcher { contract_address: yielder }.get_total_deposited();
//     assert(total_deposited == AMOUNT, 'Wrong total deposited');
//     let user_deposited = IFarmerDispatcher { contract_address: yielder }.get_deposited_of(caller);
//     assert(user_deposited == AMOUNT, 'Wrong user deposited');
// }

// #[test]
// #[available_gas(20000000)]
// fn test_withdraw() {
//     let yielder = setup();
//     let caller = contract_address_try_from_felt252(ANYONE).unwrap();
//     testing::set_contract_address(caller);
//     IFarmerDispatcher { contract_address: yielder }.deposit(token_id: 1_u256, value: AMOUNT);
//     IFarmerDispatcher { contract_address: yielder }.withdraw_to(value: AMOUNT);
//     let total_deposited = IFarmerDispatcher { contract_address: yielder }.get_total_deposited();
//     assert(total_deposited == 0, 'Wrong total deposited');
//     let user_deposited = IFarmerDispatcher { contract_address: yielder }.get_deposited_of(caller);
//     assert(user_deposited == 0, 'Wrong user deposited');
// }
