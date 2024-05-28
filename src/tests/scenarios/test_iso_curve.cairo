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
use carbon::tests::data;

// Constants

const NAME: felt252 = 'NAME';
const SYMBOL: felt252 = 'SYMBOL';
const DECIMALS: u8 = 6;
const SLOT: u256 = 1;
const SLOT2: u256 = 2;
const TON_EQUIVALENT: u64 = 1_000_000;
const PROJECT_VALUE: u256 = 121_099_000000;

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
    let (times, absorptions) = data::get_manjarisoa();
    project.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
}

fn setup_erc20(erc20: ContractAddress, yielder: ContractAddress, signers: @Signers) {
    let erc20 = IERC20Dispatcher { contract_address: erc20 };
    // Send token to yielder
    set_contract_address(*signers.owner);
    let amount = erc20.balance_of(*signers.owner) / 10;
    erc20.transfer(yielder, amount);
}

fn setup_yielder(
    project: ContractAddress,
    erc20: ContractAddress,
    yielder: ContractAddress,
    signers: @Signers,
    times: Span<u64>,
    prices: Span<u256>
) {
    // Setup prices
    set_contract_address(*signers.owner);
    let farmer = IYieldFarmDispatcher { contract_address: yielder };
    farmer.set_prices(times, prices);

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
    let times = array![1711278000, 1713952800].span();
    let prices = array![19, 19].span();
    setup_yielder(project, erc20, yielder, @signers, times, prices);
    setup_minter(project, minter, @signers);

    // Setup Minter 
    set_contract_address(signers.owner);
    let project_minter = IMinterDispatcher { contract_address: project };
    project_minter.add_minter(SLOT, minter);

    // Return
    let contracts = Contracts { project: project, erc20: erc20, yielder: yielder, minter: minter };
    (signers, contracts)
}

mod FarmingDepositWithdrawYielder {
    use starknet::ContractAddress;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};
    use starknet::{get_contract_address, get_caller_address};

    use debug::PrintTrait;

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
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };

    use carbon::tests::data;

    use super::{setup, Contracts};
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE, ONE_DAY, ONE_MONTH, TON_EQUIVALENT};

    fn max(a: u64, b: u64) -> u64 {
        if a > b {
            a
        } else {
            b
        }
    }

    fn deposit(
        contracts: @Contracts, user: ContractAddress, amount: u256, time: u64, token_id: u256
    ) {
        let farmer = IFarmDispatcher { contract_address: *contracts.yielder };
        let erc3525 = IERC3525Dispatcher { contract_address: *contracts.project };
        set_contract_address(user);
        set_block_timestamp(time);
        let initial = erc3525.value_of(token_id);
        let initial_deposited = farmer.get_deposited_of(user);
        farmer.deposit(token_id, amount);
        let final = erc3525.value_of(token_id);
        let final_deposited = farmer.get_deposited_of(user);
        assert(final == initial - amount, 'dep: value error');
        assert(final_deposited == initial_deposited + amount, 'dep: deposited error');
    }


    fn transfer(contracts: @Contracts, token_id: u256, to: u256, amount: u256, time: u64,) {
        let erc3525 = IERC3525Dispatcher { contract_address: *contracts.project };
        let erc721 = IERC721Dispatcher { contract_address: *contracts.project };
        let from = erc721.owner_of(token_id);
        set_contract_address(from);
        set_block_timestamp(time);
        let initial = erc3525.value_of(token_id);
        erc3525.transfer_value_from(token_id, to, 0.try_into().unwrap(), amount);
        let final = erc3525.value_of(token_id);
        assert(final == initial - amount, 'dep: value error');
    }


    fn withdraw(
        contracts: @Contracts, user: ContractAddress, amount: u256, time: u64, token_id: u256
    ) {
        let farmer = IFarmDispatcher { contract_address: *contracts.yielder };
        let erc3525 = IERC3525Dispatcher { contract_address: *contracts.project };
        set_contract_address(user);
        set_block_timestamp(time);
        let initial = erc3525.value_of(token_id);
        let initial_deposited = farmer.get_deposited_of(user);
        farmer.withdraw_to_token(token_id, amount);
        let final = erc3525.value_of(token_id);
        let final_deposited = farmer.get_deposited_of(user);
        assert(final == initial + amount, 'with: value error');
        assert(final_deposited == initial_deposited - amount, 'with: deposited error');
    }

    fn withdraw_all(contracts: @Contracts, user: ContractAddress, time: u64, token_id: u256) {
        let farmer = IFarmDispatcher { contract_address: *contracts.yielder };
        let erc3525 = IERC3525Dispatcher { contract_address: *contracts.project };
        set_contract_address(user);
        set_block_timestamp(time);
        let initial = erc3525.value_of(token_id);
        let initial_deposited = farmer.get_deposited_of(user);
        farmer.withdraw_to_token(token_id, initial_deposited);
        let final = erc3525.value_of(token_id);
        let final_deposited = farmer.get_deposited_of(user);
        assert(final == initial + initial_deposited, 'with: value error');
        assert(final_deposited == 0, 'with: deposited error');
    }


    fn claim(contracts: @Contracts, user: ContractAddress, time: u64) {
        let farmer = IFarmDispatcher { contract_address: *contracts.yielder };
        let yielder = IYieldDispatcher { contract_address: *contracts.yielder };
        set_contract_address(user);
        set_block_timestamp(time);
        let claimable = yielder.get_claimable_of(user);
        let claimed = yielder.get_claimed_of(user);
        let initial_balance = IERC20Dispatcher { contract_address: *contracts.erc20 }
            .balance_of(user);
        yielder.claim();
        let final_balance = IERC20Dispatcher { contract_address: *contracts.erc20 }
            .balance_of(user);
        assert(final_balance == initial_balance + claimable, 'claim: balance error');
        assert(yielder.get_claimable_of(user) == 0, 'claim: claimable error');
        assert(yielder.get_claimed_of(user) == claimed + claimable, 'claim: claimed error');
    }
    #[derive(Drop, Copy)]
    struct YieldState {
        deposited: u256,
        claimable: u256,
        claimed: u256,
    }

    fn get_user_yielder_state(contracts: @Contracts, user: ContractAddress,) -> YieldState {
        let farmer = IFarmDispatcher { contract_address: *contracts.yielder };
        let yielder = IYieldDispatcher { contract_address: *contracts.yielder };
        let deposited = farmer.get_deposited_of(user);
        let claimable = yielder.get_claimable_of(user);
        let claimed = yielder.get_claimed_of(user);
        YieldState { deposited, claimable, claimed }
    }

    fn compare_yield_state(
        contracts: @Contracts, user: ContractAddress, initial: YieldState, claimed: bool
    ) {
        let current = get_user_yielder_state(contracts, user);
        if claimed {
            assert(current.deposited == initial.deposited, 'deposited error');
            assert(current.claimable == 0, 'claimable error');
            assert(current.claimed == initial.claimed + initial.claimable, 'claimed error');
        } else {
            assert(current.deposited == initial.deposited, 'deposited error');
            assert(current.claimable == initial.claimable, 'claimable error');
            assert(current.claimed == initial.claimed, 'claimed error');
        }
    }

    fn mint(contracts: @Contracts, user: ContractAddress, amount: u256, time: u64) -> u256 {
        let project = IProjectDispatcher { contract_address: *contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: *contracts.project };
        let erc721 = IERC721Dispatcher { contract_address: *contracts.project };
        let token_id = project.mint(user, SLOT, amount);
        let user_value = erc3525.value_of(token_id);
        assert(user_value == amount, 'mint: value error');
        let prev_caller = get_contract_address();
        set_contract_address(user);
        erc721.set_approval_for_all(*contracts.yielder, true);
        set_contract_address(prev_caller);
        token_id
    }


    #[test]
    #[available_gas(4_400_000_000)]
    fn when_absorption_curve_changes_users_claimables_are_correct() {
        let (signers, contracts) = setup(PRICE);
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.yielder };
        let yfarmer = IYieldFarmDispatcher { contract_address: contracts.yielder };
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
        let _ = mint(@contracts, *signers.users[0], VALUE * 1, 0);
        let _ = mint(@contracts, *signers.users[1], VALUE * 1, 0);
        let _ = mint(@contracts, *signers.users[2], VALUE * 2, 0);
        let _ = mint(@contracts, *signers.users[3], VALUE * 8, 0);
        let _ = mint(@contracts, *signers.users[4], VALUE * 8, 0);
        let _ = mint(@contracts, *signers.users[5], VALUE * 8, 0);
        minter.revoke_minter(SLOT, signers.owner);

        // Manjarisoa data
        let (times, abs) = data::get_manjarisoa();
        // March 24th, April 24th
        let price_times = array![1711278000, 1713952800].span();
        let prices = array![19, 19].span();

        deposit(@contracts, *signers.users[0], VALUE, *times[0] + 3 * ONE_DAY, 1);
        deposit(@contracts, *signers.users[1], VALUE, *times[0] + 4 * ONE_DAY, 2);
        deposit(@contracts, *signers.users[2], VALUE, *times[0] + 5 * ONE_DAY, 3);
        transfer(@contracts, 3, 2, VALUE, *times[0] + 6 * ONE_DAY);
        deposit(@contracts, *signers.users[3], VALUE * 4, *times[0] + 10 * ONE_DAY, 4);
        withdraw(@contracts, *signers.users[1], VALUE, *times[0] + 14 * ONE_DAY, 2);
        transfer(@contracts, 4, 1, VALUE * 2, *times[0] + 16 * ONE_DAY);
        deposit(@contracts, *signers.users[0], VALUE * 2, *times[0] + 17 * ONE_DAY, 1);
        withdraw(@contracts, *signers.users[3], VALUE * 2, *times[0] + 18 * ONE_DAY, 4);
        deposit(@contracts, *signers.users[4], VALUE * 4, *times[0] + 19 * ONE_DAY, 5);
        deposit(@contracts, *signers.users[5], VALUE * 5, *times[0] + 20 * ONE_DAY, 6);
        transfer(@contracts, 5, 2, VALUE * 2, *times[0] + 21 * ONE_DAY);
        deposit(@contracts, *signers.users[1], VALUE * 2, *times[0] + 22 * ONE_DAY, 2);
        claim(@contracts, *signers.users[0], *times[0] + 23 * ONE_DAY);
        withdraw(@contracts, *signers.users[4], VALUE * 3, *times[0] + 31 * ONE_DAY, 5);

        // Change abs
        let may29 = 1717005600;
        set_block_timestamp(may29);

        let ys1_i = get_user_yielder_state(@contracts, *signers.users[0]);
        let ys2_i = get_user_yielder_state(@contracts, *signers.users[1]);
        let ys3_i = get_user_yielder_state(@contracts, *signers.users[2]);
        let ys4_i = get_user_yielder_state(@contracts, *signers.users[3]);
        let ys5_i = get_user_yielder_state(@contracts, *signers.users[4]);
        let ys6_i = get_user_yielder_state(@contracts, *signers.users[5]);

        set_contract_address(signers.owner);
        let (new_times, new_abs) = data::get_manjarisoa_new();
        absorber.set_absorptions(SLOT, new_times, new_abs, TON_EQUIVALENT);
        yfarmer.set_prices(price_times, prices);

        compare_yield_state(@contracts, *signers.users[0], ys1_i, false);
        compare_yield_state(@contracts, *signers.users[1], ys2_i, false);
        compare_yield_state(@contracts, *signers.users[2], ys3_i, false);
        compare_yield_state(@contracts, *signers.users[3], ys4_i, false);
        compare_yield_state(@contracts, *signers.users[4], ys5_i, false);
        compare_yield_state(@contracts, *signers.users[5], ys6_i, false);

        set_block_timestamp(may29 + 7 * ONE_MONTH + 19 * ONE_DAY);

        compare_yield_state(@contracts, *signers.users[0], ys1_i, false);
        compare_yield_state(@contracts, *signers.users[1], ys2_i, false);
        compare_yield_state(@contracts, *signers.users[2], ys3_i, false);
        compare_yield_state(@contracts, *signers.users[3], ys4_i, false);
        compare_yield_state(@contracts, *signers.users[4], ys5_i, false);
        compare_yield_state(@contracts, *signers.users[5], ys6_i, false);

        set_block_timestamp(may29 + 10 * ONE_MONTH);

        claim(@contracts, *signers.users[0], may29 + 10 * ONE_MONTH);
        claim(@contracts, *signers.users[1], may29 + 10 * ONE_MONTH);
        claim(@contracts, *signers.users[2], may29 + 10 * ONE_MONTH);
        claim(@contracts, *signers.users[3], may29 + 10 * ONE_MONTH);
        claim(@contracts, *signers.users[4], may29 + 10 * ONE_MONTH);
        claim(@contracts, *signers.users[5], may29 + 10 * ONE_MONTH);

        compare_yield_state(@contracts, *signers.users[0], ys1_i, true);
        compare_yield_state(@contracts, *signers.users[1], ys2_i, true);
        compare_yield_state(@contracts, *signers.users[2], ys3_i, true);
        compare_yield_state(@contracts, *signers.users[3], ys4_i, true);
        compare_yield_state(@contracts, *signers.users[4], ys5_i, true);
        compare_yield_state(@contracts, *signers.users[5], ys6_i, true);

        let ys1_f = get_user_yielder_state(@contracts, *signers.users[0]);
        let ys2_f = get_user_yielder_state(@contracts, *signers.users[1]);
        let ys3_f = get_user_yielder_state(@contracts, *signers.users[2]);
        let ys4_f = get_user_yielder_state(@contracts, *signers.users[3]);
        let ys5_f = get_user_yielder_state(@contracts, *signers.users[4]);
        let ys6_f = get_user_yielder_state(@contracts, *signers.users[5]);

        set_block_timestamp(may29 + 31 * ONE_MONTH);

        withdraw_all(@contracts, *signers.users[0], may29 + 31 * ONE_MONTH, 1);
        withdraw_all(@contracts, *signers.users[1], may29 + 31 * ONE_MONTH, 2);
        withdraw_all(@contracts, *signers.users[2], may29 + 31 * ONE_MONTH, 3);
        withdraw_all(@contracts, *signers.users[3], may29 + 31 * ONE_MONTH, 4);
        withdraw_all(@contracts, *signers.users[4], may29 + 31 * ONE_MONTH, 5);
        withdraw_all(@contracts, *signers.users[5], may29 + 31 * ONE_MONTH, 6);

        compare_yield_state(
            @contracts,
            *signers.users[0],
            YieldState { deposited: 0, claimable: 0, claimed: ys1_f.claimable + ys1_f.claimed },
            false
        );
        compare_yield_state(
            @contracts,
            *signers.users[1],
            YieldState { deposited: 0, claimable: 0, claimed: ys2_f.claimable + ys2_f.claimed },
            false
        );
        compare_yield_state(
            @contracts,
            *signers.users[2],
            YieldState { deposited: 0, claimable: 0, claimed: ys3_f.claimable + ys3_f.claimed },
            false
        );
        compare_yield_state(
            @contracts,
            *signers.users[3],
            YieldState { deposited: 0, claimable: 0, claimed: ys4_f.claimable + ys4_f.claimed },
            false
        );
        compare_yield_state(
            @contracts,
            *signers.users[4],
            YieldState { deposited: 0, claimable: 0, claimed: ys5_f.claimable + ys5_f.claimed },
            false
        );
        compare_yield_state(
            @contracts,
            *signers.users[5],
            YieldState { deposited: 0, claimable: 0, claimed: ys6_f.claimable + ys6_f.claimed },
            false
        );
    }
}
