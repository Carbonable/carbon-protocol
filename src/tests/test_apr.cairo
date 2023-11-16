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
use carbon::contracts::minter::Minter;

// Constants

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 6;
const SLOT: u256 = 1;
const TON_EQUIVALENT: u64 = 1_000_000;
const VALUE: u256 = 17600_000_000;

const MAX_VALUE_PER_TX: u256 = 5;
const MIN_VALUE_PER_TX: u256 = 1;
const MAX_VALUE: u256 = 10;
const UNIT_PRICE: u256 = 1;
const RESERVED_VALUE: u256 = 4;
const ALLOCATION: felt252 = 5;
const BILLION: u256 = 1_000_000_000_000;

const PRICE: u256 = 10;

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
    absorber.set_project_value(SLOT, VALUE);
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

fn deploy_minter(
    project: ContractAddress, erc20: ContractAddress, owner: ContractAddress
) -> ContractAddress {
    let public_sale_open: bool = false;
    let mut calldata: Array<felt252> = array![
        project.into(),
        SLOT.low.into(),
        SLOT.high.into(),
        erc20.into(),
        public_sale_open.into(),
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


fn setup_iso_project(project: ContractAddress, signers: @Signers) {
    // Prank caller as owner
    set_contract_address(*signers.owner);
    // Grant certifier rights to owner
    let project = ICertifierDispatcher { contract_address: project };
    project.set_certifier(SLOT, *signers.owner);
    // Setup absorptions
    let project = IAbsorberDispatcher { contract_address: project.contract_address };
    let times: Array<u64> = array![
        1667314458,
        1730472858,
        1793544858,
        1856703258,
        1919775258,
        1982933658,
        2109164058,
        2235394458,
        2330002458,
        2393160858,
        2456232858,
        2582463258,
        2614085658
    ];
    let absorptions: Array<u64> = array![
        0,
        12584000,
        40898000,
        100672000,
        202917000,
        333476000,
        629200000,
        915486000,
        1108965000,
        1223794000,
        1335477000,
        1528956000,
        1573000000
    ];
    project.set_absorptions(SLOT, times.span(), absorptions.span(), TON_EQUIVALENT);
}


fn setup_project_apr(project: ContractAddress, signers: @Signers, n: u64) {
    // Prank caller as owner
    set_contract_address(*signers.owner);
    // Grant certifier rights to owner
    let project = ICertifierDispatcher { contract_address: project };
    project.set_certifier(SLOT, *signers.owner);
    // Setup absorptions
    let project = IAbsorberDispatcher { contract_address: project.contract_address };

    let (times, absorptions) = get_test_absorptions(n);
    project.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
}

fn get_test_absorptions(n: u64) -> (Span<u64>, Span<u64>) {
    let mut times: Array<u64> = Default::default();
    let mut absorptions: Array<u64> = Default::default();
    let mut i = 1;
    loop {
        if i > n {
            break;
        }
        times.append(i * 10);
        absorptions.append((i - 1) * 1000);
        i += 1;
    };
    (times.span(), absorptions.span())
}

fn get_test_prices(n: u64) -> (Span<u64>, Span<u256>) {
    let mut times: Array<u64> = Default::default();
    let mut prices: Array<u256> = Default::default();
    let mut i = 1;
    loop {
        if i > n {
            break;
        }
        times.append(i * 10 + 5);
        prices.append((i * 10).into());
        i += 1;
    };
    (times.span(), prices.span())
}

fn setup_erc20(erc20: ContractAddress, yielder: ContractAddress, signers: @Signers) {
    let erc20 = IERC20Dispatcher { contract_address: erc20 };
    // Send token to yielder
    set_contract_address(*signers.owner);
    let amount = erc20.balance_of(*signers.owner);
    erc20.transfer(yielder, amount);
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
    let times: Array<u64> = array![1730472858, 2614085658];
    let prices: Array<u256> = array![price, price];
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
    let signers = Signers { owner: deploy_account('OWNER'), anyone: deploy_account('ANYONE'), };
    let project = deploy_project(signers.owner);
    let erc20 = deploy_erc20(signers.owner);
    let yielder = deploy_yielder(project, erc20, signers.owner);
    let minter = deploy_minter(project, erc20, signers.owner);

    // Setup
    setup_iso_project(project, @signers);
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

fn setup_for_apr(n: u64) -> (Signers, Contracts) {
    // Deploy
    let signers = Signers { owner: deploy_account('OWNER'), anyone: deploy_account('ANYONE'), };
    let project = deploy_project(signers.owner);
    let erc20 = deploy_erc20(signers.owner);
    let yielder = deploy_yielder(project, erc20, signers.owner);
    let minter = deploy_minter(project, erc20, signers.owner);

    // Setup
    setup_project_apr(project, @signers, n);
    setup_erc20(erc20, yielder, @signers);
    // setup_yielder(project, erc20, yielder, @signers);
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

fn sum_span(s: Span<u256>) -> u256 {
    let mut sum = 0;
    let mut s = s;
    loop {
        match s.pop_front() {
            Option::Some(x) => {
                sum += *x;
            },
            Option::None => {
                break sum;
            },
        };
    }
}

#[test]
#[available_gas(990_000_000)]
fn test_yielder_get_apr() {
    let n = 20;
    let (signers, contracts) = setup_for_apr(n);
    // Instantiate contracts
    let farmer = IYieldFarmDispatcher { contract_address: contracts.yielder };
    let (times, prices) = get_test_prices(n - 1);
    farmer.set_prices(times, prices);
    let minter_address = contracts.minter;

    // [Assert] times, prices and cumsales
    let times = farmer.get_cumsale_times();
    let prices = farmer.get_updated_prices();
    let cumsales = farmer.get_cumsales();

    let mut times_span = times;
    loop {
        match times_span.pop_front() {
            Option::Some(time) => {
                set_block_timestamp(*time - 1);
                let price = farmer.get_current_price();
                let (num, den) = farmer.get_apr(minter_address);
            // DEBUG
            // 'time is'.print();
            // (*time).print();
            // 'apr is'.print();
            // num.low.print();
            // den.low.print();
            },
            Option::None => {
                break;
            },
        };
    };
}
