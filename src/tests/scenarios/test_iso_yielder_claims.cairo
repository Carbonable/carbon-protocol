// Core deps

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
use cairo_erc_3525::interface::{IERC3525Dispatcher, IERC3525DispatcherTrait};

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
use carbon::contracts::minter::Minter;
use carbon::tests::data;

// Constants

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 6;
const SLOT: u256 = 1;
const SLOT2: u256 = 2;
const TON_EQUIVALENT: u64 = 1_000_000;
const PROJECT_VALUE: u256 = 17600_000_000;

const MAX_VALUE_PER_TX: u256 = 25_000_000;
const MIN_VALUE_PER_TX: u256 = 1_000_000;
const MAX_VALUE: u256 = 17600_000_000;
const UNIT_PRICE: u256 = 10;
const RESERVED_VALUE: u256 = 25_000_000;
const ALLOCATION: felt252 = 5;
const BILLION: u256 = 1_000_000_000_000;

const PRICE: u256 = 22;
const VALUE: u256 = 100_000_000;
const ONE_MONTH: u64 = consteval_int!(31 * 24 * 60 * 60);
const ONE_DAY: u64 = consteval_int!(1 * 24 * 60 * 60);

// Signers
#[derive(Drop)]
struct Signers {
    owner: ContractAddress,
    anyone: ContractAddress,
    anyone2: ContractAddress,
    users: Array<ContractAddress>,
}

#[derive(Drop)]
struct Contracts {
    project: ContractAddress,
    erc20: ContractAddress,
    yielder: ContractAddress,
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

    // [Setup] Project
    set_contract_address(owner);
    let absorber = IAbsorberDispatcher { contract_address: address };
    absorber.set_project_value(SLOT, PROJECT_VALUE);
    address
}

fn deploy_yielder(
    project: ContractAddress, erc20: ContractAddress, owner: ContractAddress, slot: u256
) -> ContractAddress {
    let mut calldata: Array<felt252> = array![
        project.into(), slot.low.into(), slot.high.into(), erc20.into(), owner.into()
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
        public_sale_open.into(),
        enable_VALUE_PER_TX.into(),
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
        .unwrap();
    //.expect('Minter deploy failed');
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
    let (times, absorptions) = data::get_banegas();
    project.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
}

fn setup_erc20(erc20: ContractAddress, yielder: ContractAddress, signers: @Signers) {
    let erc20 = IERC20Dispatcher { contract_address: erc20 };
    // Send token to yielder
    set_contract_address(*signers.owner);
    let amount = erc20.balance_of(*signers.owner);
}

fn setup_yielder(
    project: ContractAddress,
    erc20: ContractAddress,
    yielder: ContractAddress,
    signers: @Signers,
    price: u256
) {
    // Setup prices
    set_contract_address(*signers.owner);
    let farmer = IYieldFarmDispatcher { contract_address: yielder };

    let times: Array<u64> = array![
        1690884000, 1696154400
    ]; // Aug 01 2023 10:00:00 GMT+0000, Oct 01 2023 10:00:00 GMT+0000
    let prices: Array<u256> = array![0, price];

    farmer.set_prices(times.span(), prices.span());
    // Owner approve yielder to spend his tokens
    let project = IERC721Dispatcher { contract_address: project };
    project.set_approval_for_all(yielder, true);
    // Anyone approve yielder to spend his tokens
    set_contract_address(*signers.anyone);
    project.set_approval_for_all(yielder, true);
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

fn setup(price: u256) -> (Signers, Contracts) {
    // Deploy
    let signers = Signers {
        owner: deploy_account('OWNER'),
        anyone: deploy_account('ANYONE'),
        anyone2: deploy_account('ANYONE2'),
        users: array![
            deploy_account('USER1'),
            deploy_account('USER2'),
            deploy_account('USER3'),
            deploy_account('USER4'),
            deploy_account('USER5'),
            deploy_account('USER6')
        ]
    };
    let project = deploy_project(signers.owner);
    let erc20 = deploy_erc20(signers.owner);
    let yielder = deploy_yielder(project, erc20, signers.owner, SLOT);
    let minter = deploy_minter(project, erc20, signers.owner);

    // Setup
    setup_project(project, @signers);
    setup_erc20(erc20, yielder, @signers);
    setup_yielder(project, erc20, yielder, @signers, price);
    setup_minter(project, minter, @signers);

    // Setup Minter 
    set_contract_address(signers.owner);
    let project_minter = IMinterDispatcher { contract_address: project };
    project_minter.add_minter(SLOT, minter);

    // Return
    let contracts = Contracts { project: project, erc20: erc20, yielder: yielder, minter: minter };
    (signers, contracts)
}

impl SpanPrintImpl<
    T, impl TCopy: Copy<T>, impl TPrint: PrintTrait<T>, impl TDrop: Drop<T>
> of PrintTrait<Span<T>> {
    fn print(self: Span<T>) {
        let mut s = self;
        loop {
            match s.pop_front() {
                Option::Some(x) => {
                    (*x).print();
                },
                Option::None => {
                    break;
                },
            };
        };
    }
}

#[test]
#[available_gas(4_000_000_000)]
fn multi_deposit_entire_value_claim_at_end() {
    let (signers, contracts) = setup(PRICE);
    // Instantiate contracts
    let yieldfarmer = IYieldFarmDispatcher { contract_address: contracts.yielder };
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let yielder = IYieldDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    let erc721 = IERC721Dispatcher { contract_address: contracts.project };

    // Prank caller as owner
    set_contract_address(signers.owner);

    let user1 = *signers.users[0];
    let user2 = *signers.users[1];
    let user3 = *signers.users[2];
    let user4 = *signers.users[3];

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    project.mint(user1, SLOT, VALUE);
    project.mint(user2, SLOT, VALUE / 3);
    project.mint(user3, SLOT, VALUE / 5);
    project.mint(user4, SLOT, PROJECT_VALUE - (VALUE + VALUE / 3 + VALUE / 5));
    minter.revoke_minter(SLOT, signers.owner);

    let price_times: Span<u64> = array![1690884000, 1696154400].span();

    // Deposit
    set_block_timestamp(0);
    set_contract_address(user1);
    erc721.set_approval_for_all(contracts.yielder, true);
    let value = erc3525.value_of(1);
    farmer.deposit(1, value);
    set_contract_address(user2);
    erc721.set_approval_for_all(contracts.yielder, true);
    let value = erc3525.value_of(2);
    farmer.deposit(2, value);
    set_contract_address(user3);
    erc721.set_approval_for_all(contracts.yielder, true);
    let value = erc3525.value_of(3);
    farmer.deposit(3, value);
    set_contract_address(user4);
    erc721.set_approval_for_all(contracts.yielder, true);
    let value = erc3525.value_of(4);
    farmer.deposit(4, value);

    let deposited = farmer.get_total_deposited();
    assert(deposited == PROJECT_VALUE, 'Wrong deposited value');

    set_block_timestamp(*price_times[0]);
    let abs1 = absorber.get_current_absorption(SLOT);
    set_block_timestamp(2614085658 + 3 * ONE_MONTH);
    let abs2 = absorber.get_current_absorption(SLOT);
    let expected_claim = (abs2 - abs1).into() * PRICE;
    set_contract_address(signers.owner);
    erc20.transfer(contracts.yielder, expected_claim);

    set_block_timestamp(*price_times[0]);
    let mut error: u256 = 4;
    let mut time = *price_times[0];
    loop {
        if time > 2614085658 {
            break;
        }
        time += 7 * ONE_MONTH + 5 * ONE_DAY;
        set_block_timestamp(time);
        let user = pedersen::pedersen(0, time.into()).into() % 4_u256;
        if user == 0 {
            set_contract_address(user1);
        } else if user == 1 {
            set_contract_address(user2);
        } else if user == 2 {
            set_contract_address(user3);
        } else {
            set_contract_address(user4);
        }

        yielder.claim();

        error += 1;
    };

    // Rewards
    let claim1 = yielder.get_claimed_of(user1) + yielder.get_claimable_of(user1);
    let claim2 = yielder.get_claimed_of(user2) + yielder.get_claimable_of(user2);
    let claim3 = yielder.get_claimed_of(user3) + yielder.get_claimable_of(user3);
    let claim4 = yielder.get_claimed_of(user4) + yielder.get_claimable_of(user4);
    let total_sale = yieldfarmer.get_total_sale();
    let claimable_total = yielder.get_total_claimable();
    let claimed_total = yielder.get_total_claimed();
    let claim_total = claimable_total + claimed_total;
    let claim_sum_users = claim1 + claim2 + claim3 + claim4;

    assert(total_sale == claim_total, 'Wrong total');
    assert(claim_total >= claim_sum_users, 'Wrong claimable: total != sum');
    assert(claim_total <= claim_sum_users + error, 'Wrong claimable: total != sum');
    assert(claim_total == expected_claim, 'Wrong clmbl total != expected');
}


#[test]
#[available_gas(4_000_000_000)]
fn user_deposit_entire_value_claim_at_end() {
    let (signers, contracts) = setup(PRICE);
    // Instantiate contracts
    let yieldfarmer = IYieldFarmDispatcher { contract_address: contracts.yielder };
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let yielder = IYieldDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
    let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
    let erc721 = IERC721Dispatcher { contract_address: contracts.project };

    // Prank caller as owner
    set_contract_address(signers.owner);

    let user1 = *signers.users[0];

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    project.mint(user1, SLOT, PROJECT_VALUE);
    minter.revoke_minter(SLOT, signers.owner);

    let price_times: Span<u64> = array![1690884000, 1696154400].span();

    // Deposit
    set_block_timestamp(0);
    set_contract_address(user1);
    erc721.set_approval_for_all(contracts.yielder, true);
    let value = erc3525.value_of(1);
    farmer.deposit(1, value);

    let deposited = farmer.get_total_deposited();
    assert(deposited == PROJECT_VALUE, 'Wrong deposited value');

    set_block_timestamp(*price_times[0]);
    let abs1 = absorber.get_current_absorption(SLOT);
    set_block_timestamp(2614085658 + 3 * ONE_MONTH);
    let abs2 = absorber.get_current_absorption(SLOT);
    let expected_claim = (abs2 - abs1).into() * PRICE;
    set_contract_address(signers.owner);
    erc20.transfer(contracts.yielder, expected_claim);

    set_block_timestamp(*price_times[0]);
    set_contract_address(user1);
    let mut error: u256 = 4;
    let mut time = *price_times[0];
    let max_time = 2614085658;
    loop {
        if time > max_time {
            break;
        }
        time += 10 * ONE_MONTH + 5 * ONE_DAY;
        set_block_timestamp(time);

        yielder.claim();

        error += 1;
    };

    set_block_timestamp(2614085658 + ONE_DAY);
    yielder.claim();

    // Rewards
    let claim1 = yielder.get_claimed_of(user1) + yielder.get_claimable_of(user1);
    let claimable_total = yielder.get_total_claimable();
    let claimed_total = yielder.get_total_claimed();
    let claim_total = claimable_total + claimed_total;

    assert(claim_total >= claim1, 'Wrong claimable: total != sum');
    assert(claim_total <= claim1 + error, 'Wrong claimable: total != sum');
    assert(claim_total == expected_claim, 'Wrong clmbl total != expected');

    // Claim again just in case
    set_block_timestamp(2614085658 + ONE_MONTH * 6);
    yielder.claim();

    // Rewards again just in case
    let claim1 = yielder.get_claimed_of(user1) + yielder.get_claimable_of(user1);
    let total_sale = yieldfarmer.get_total_sale();
    let claimable_total = yielder.get_total_claimable();
    let claimed_total = yielder.get_total_claimed();
    let claim_total = claimable_total + claimed_total;

    assert(total_sale == claim_total, 'Wrong total');
    assert(claim_total >= claim1, 'Wrong claimable: total != sum');
    assert(claim_total <= claim1 + error, 'Wrong claimable: total != sum');
    assert(claim_total == expected_claim, 'Wrong clmbl total != expected');
}
