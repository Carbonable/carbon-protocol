// Core deps

use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::{Into, TryInto};
use zeroable::Zeroable;
use debug::PrintTrait;

// Starknet deps

use starknet::ContractAddress;
use starknet::deploy_syscall;
use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};

// External deps

use openzeppelin::account::account::Account;
use openzeppelin::token::erc20::erc20::ERC20;
use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
use cairo_erc_3525::presets::erc3525_mintable_burnable::{
    IExternalDispatcher as IERC3525Dispatcher, IExternalDispatcherTrait as IERC3525DispatcherTrait
};

// Components

use carbon::components::absorber::interface::{IAbsorberDispatcher, IAbsorberDispatcherTrait};
use carbon::components::access::interface::{ICertifierDispatcher, ICertifierDispatcherTrait};
use carbon::components::access::interface::{IMinterDispatcher, IMinterDispatcherTrait};
use carbon::components::farm::interface::{
    IFarmDispatcher, IFarmDispatcherTrait, IYieldFarmDispatcher, IYieldFarmDispatcherTrait
};
use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};

// Contracts

use carbon::contracts::project::{
    Project, IExternalDispatcher as IProjectDispatcher,
    IExternalDispatcherTrait as IProjectDispatcherTrait
};
use carbon::contracts::yielder::Yielder;

// Constants

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
        Account::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Account deploy failed');
    address
}

fn deploy_erc20(owner: ContractAddress) -> ContractAddress {
    let billion = 1000000000000;
    let mut calldata = array![NAME, SYMBOL, billion, 0, owner.into()];
    let (address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('ERC20 deploy failed');
    address
}

fn deploy_project(owner: ContractAddress) -> ContractAddress {
    let mut calldata = array![NAME, SYMBOL, DECIMALS.into(), owner.into()];
    let (address, _) = deploy_syscall(
        Project::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Project deploy failed');
    address
}

fn deploy_yielder(
    project: ContractAddress, erc20: ContractAddress, owner: ContractAddress
) -> ContractAddress {
    let mut calldata: Array<felt252> = array![
        project.into(), SLOT.low.into(), SLOT.high.into(), erc20.into(), owner.into()
    ];
    let (address, _) = deploy_syscall(
        Yielder::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Yielder deploy failed');
    address
}

fn setup_project(project: ContractAddress, signers: @Signers) {
    // Prank caller as owner
    set_contract_address(*signers.owner);
    // Grant certifier rights to owner
    let project = ICertifierDispatcher { contract_address: project };
    project.set_certifier(SLOT, *signers.owner);
    // Setup absorptions
    let project = IAbsorberDispatcher { contract_address: project.contract_address };
    let times: Array<u64> = array![
        1651363200,
        1659312000,
        1667260800,
        1675209600,
        1682899200,
        1690848000,
        1698796800,
        2598134400
    ];
    let absorptions: Array<u64> = array![
        0, 1179750, 2359500, 3539250, 4719000, 6685250, 8651500, 1573000000
    ];
    project.set_absorptions(SLOT, times.span(), absorptions.span(), TON_EQUIVALENT);
}

fn setup_erc20(erc20: ContractAddress, yielder: ContractAddress, signers: @Signers) {
    let erc20 = IERC20Dispatcher { contract_address: erc20 };
    // Send token to yielder
    set_contract_address(*signers.owner);
    let amount = erc20.balance_of(*signers.owner);
    erc20.transfer(yielder, amount);
}

fn setup_yielder(
    project: ContractAddress, erc20: ContractAddress, yielder: ContractAddress, signers: @Signers
) {
    // Setup prices
    set_contract_address(*signers.owner);
    let farmer = IYieldFarmDispatcher { contract_address: yielder };
    let times: Array<u64> = array![1659312000, 2598134400];
    let prices: Array<u256> = array![10, 10];
    farmer.set_prices(times.span(), prices.span());
    // Owner approve yielder to spend his tokens
    let project = IERC721Dispatcher { contract_address: project };
    project.set_approval_for_all(yielder, true);
    // Anyone approve yielder to spend his tokens
    set_contract_address(*signers.anyone);
    project.set_approval_for_all(yielder, true);
}

fn setup() -> (Signers, Contracts) {
    // Deploy
    let signers = Signers { owner: deploy_account('OWNER'), anyone: deploy_account('ANYONE'), };
    let project = deploy_project(signers.owner);
    let erc20 = deploy_erc20(signers.owner);
    let yielder = deploy_yielder(project, erc20, signers.owner);

    // Setup
    setup_project(project, @signers);
    setup_erc20(erc20, yielder, @signers);
    setup_yielder(project, erc20, yielder, @signers);

    // Return
    let contracts = Contracts { project: project, erc20: erc20, yielder: yielder, };
    (signers, contracts)
}

#[test]
#[available_gas(40_000_000)]
fn test_yielder_cumsales() {
    let (signers, contracts) = setup();
    // Instantiate contracts
    let farmer = IYieldFarmDispatcher { contract_address: contracts.yielder };

    // [Assert] times, prices and cumsales
    let times = farmer.get_cumsale_times();
    let prices = farmer.get_updated_prices();
    let cumsales = farmer.get_cumsales();
    assert(
        times == array![
            1651363200,
            1659312000,
            1667260800,
            1675209600,
            1682899200,
            1690848000,
            1698796800,
            2598134400
        ]
            .span(),
        'Wrong times'
    );
    assert(prices == array![10, 10, 10, 10, 10, 10, 10, 10].span(), 'Wrong prices');
    assert(
        cumsales == array![
            0, 11797500, 23595000, 35392500, 47190000, 66852500, 86515000, 15730000000
        ]
            .span(),
        'Wrong cumsales'
    );
}

#[test]
#[available_gas(300_000_000)]
fn test_yielder_nominal_single_user_case() {
    let (signers, contracts) = setup();
    // Instantiate contracts
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let yielder = IYieldDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };

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
    // Claimable is 1179750 * 10
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 11797500, 'Wrong claimable');
    // Claimed is 0
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 0, 'Wrong claimed');

    // At t = 1667260800
    set_block_timestamp(1667260800);
    // Compute expected balance
    let claimable = yielder.get_claimable_of(signers.anyone);
    let expected_balance = erc20.balance_of(signers.anyone) + claimable;
    // Anyone claims
    yielder.claim();
    // [Assert] Balance
    let balance = erc20.balance_of(signers.anyone);
    assert(balance == expected_balance, 'Wrong balance');

    // At t = 1675209600
    set_block_timestamp(1675209600);
    // Claimable is 1179750 * 10
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 11797500, 'Wrong claimable');
    // Claimed is 2359500 * 10
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 23595000, 'Wrong claimed');

    // At t = 1682899200
    set_block_timestamp(1682899200);
    // Anyone wtihdraws token #1
    farmer.withdraw_to_token(token_id, VALUE);
    // Total absorption is 4719000
    let absorption = farmer.get_total_absorption();
    assert(absorption == 4719000, 'Wrong absorption');
    // Claimable is 2359500 * 10
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 23595000, 'Wrong claimable');
    // Claimed is 2359500 * 10
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 23595000, 'Wrong claimed');

    // At t = 1690848000
    set_block_timestamp(1690848000);
    // Claimable is 2359500 * 10
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 23595000, 'Wrong claimable');
    // Claimed is 2359500 * 10
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 23595000, 'Wrong claimed');
}

#[test]
#[available_gas(370_000_000)]
fn test_yielder_nominal_multi_user_case() {
    let (signers, contracts) = setup();
    // Instantiate contracts
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let yielder = IYieldDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };

    // Prank caller as owner
    set_contract_address(signers.owner);

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    let one = project.mint(signers.owner, SLOT, VALUE);
    let two = project.mint(signers.owner, SLOT, VALUE);
    let three = project.mint(signers.anyone, SLOT, VALUE);
    let four = project.mint(signers.anyone, SLOT, VALUE);
    let five = project.mint(signers.anyone, SLOT, VALUE);
    minter.revoke_minter(SLOT, signers.owner);

    // Setup project value
    let project_value = erc3525.total_value(SLOT);
    absorber.set_project_value(SLOT, project_value);

    // Prank caller as anyone
    set_contract_address(signers.anyone);

    // At t = 0
    set_block_timestamp(0);

    // [Assert] Owner deposits value 2 * 100
    set_contract_address(signers.owner);
    farmer.deposit(one, VALUE);
    farmer.deposit(two, VALUE);
    let deposited = farmer.get_deposited_of(signers.owner);
    assert(deposited == 2 * VALUE, 'Wrong deposited');

    // [Assert] Anyone deposits value 3 * 100
    set_contract_address(signers.anyone);
    farmer.deposit(three, VALUE);
    farmer.deposit(four, VALUE);
    farmer.deposit(five, VALUE);
    let deposited = farmer.get_deposited_of(signers.anyone);
    assert(deposited == 3 * VALUE, 'Wrong deposited');

    // Claimable is 0
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 0, 'Wrong claimable');
    // Claimed is 0
    let claimed = yielder.get_claimed_of(signers.anyone);
    assert(claimed == 0, 'Wrong claimed');

    // At t = 1659312000
    set_block_timestamp(1659312000);

    // Total claimable is 1179750 * 10
    let total_claimable = yielder.get_total_claimable();
    assert(total_claimable == 11797500, 'Wrong claimable');

    // Owner claimable is 1179750 * 10 * 2 / 5
    let claimable = yielder.get_claimable_of(signers.owner);
    assert(claimable == 11797500 * 2 / 5, 'Wrong claimable');

    // Anyone claimable is 1179750 * 10 * 3 / 5
    let claimable = yielder.get_claimable_of(signers.anyone);
    assert(claimable == 11797500 * 3 / 5, 'Wrong claimable');
}

#[test]
#[available_gas(75_000_000)]
#[should_panic(expected: ('Caller is not owner', 'ENTRYPOINT_FAILED'))]
#[should_panic]
fn test_yielder_deposit_revert_not_token_owner() {
    let (signers, contracts) = setup();
    // Instantiate contracts
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };

    // Prank caller as owner
    set_contract_address(signers.owner);

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    let one = project.mint(signers.owner, SLOT, VALUE);
    let two = project.mint(signers.anyone, SLOT, VALUE);
    minter.revoke_minter(SLOT, signers.owner);

    // Setup project value
    let project_value = erc3525.total_value(SLOT);
    absorber.set_project_value(SLOT, project_value);

    // Prank caller as anyone
    set_contract_address(signers.anyone);

    // At t = 0
    set_block_timestamp(0);

    // [Assert] Anyone deposits value 2 * 100
    set_contract_address(signers.anyone);
    farmer.deposit(two, VALUE);
    farmer.deposit(one, VALUE);
}

#[test]
#[available_gas(110_000_000)]
#[should_panic(expected: ('Caller is not owner', 'ENTRYPOINT_FAILED'))]
fn test_yielder_withdraw_revert_not_token_owner() {
    let (signers, contracts) = setup();
    // Instantiate contracts
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };

    // Prank caller as owner
    set_contract_address(signers.owner);

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    let one = project.mint(signers.owner, SLOT, VALUE);
    let two = project.mint(signers.anyone, SLOT, VALUE);
    minter.revoke_minter(SLOT, signers.owner);

    // Setup project value
    let project_value = erc3525.total_value(SLOT);
    absorber.set_project_value(SLOT, project_value);

    // Prank caller as anyone
    set_contract_address(signers.anyone);

    // At t = 0
    set_block_timestamp(0);

    // Anyone deposits value 100
    set_contract_address(signers.owner);
    farmer.deposit(one, VALUE);

    // Anyone deposits value 100
    set_contract_address(signers.anyone);
    farmer.deposit(two, VALUE);

    // Withdraw to token #1
    farmer.withdraw_to_token(one, VALUE);
}
