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
    let amount = erc20.balance_of(*signers.owner) / 10;
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

fn setup_for_apr(n: u64) -> (Signers, Contracts) {
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

mod FarmingDepositWithdrawYielder {
    use starknet::ContractAddress;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};
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
    use carbon::components::farm::interface::{IFarmDispatcher, IFarmDispatcherTrait};
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };

    use carbon::tests::data;

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE, ONE_MONTH};

    fn max(a: u64, b: u64) -> u64 {
        if a > b {
            a
        } else {
            b
        }
    }

    #[test]
    #[available_gas(400_000_000)]
    fn deposit_and_withdraw_value_in_yielder() {
        let (signers, contracts) = setup(PRICE);
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

        // Prank caller as anyone
        set_contract_address(signers.anyone);

        // At t = 0
        set_block_timestamp(0);
        // Anyone deposits value 100_000_000 in yielder
        farmer.deposit(token_id, VALUE);
        let deposited = farmer.get_deposited_of(signers.anyone);
        assert(deposited == VALUE, 'Wrong strat deposited');

        //check balance of anyone need to be reviewed 
        let balance = erc20.balance_of(signers.anyone);
        assert(balance == 0, 'Wrong balce of anyone shld be 0');

        // At t = Aug 01 2023 07:00:00 GMT+0000 (3h before first price other than 0)
        set_block_timestamp(1690873200);
        // Then `get_claimable_of` should be  0
        let claimable = yielder.get_claimable_of(signers.anyone);
        assert(claimable == 0, 'Wrong claimable: should be 0');

        set_block_timestamp(1690884000);
        let previous_abs = absorber.get_current_absorption(SLOT);

        // At t = Sep 01 2023 07:00:00 GMT+0000 (1 month after first price at 22)
        set_block_timestamp(1693551600);

        // Then `get_claimable_of` should be different from 0
        let claimable = yielder.get_claimable_of(signers.anyone);
        assert(claimable != 0, 'Wrong claimable should not be 0');

        let current_abs = absorber.get_current_absorption(SLOT);
        let abs = current_abs - previous_abs;
        let expected = (VALUE * abs.into() * PRICE) / PROJECT_VALUE;
        assert(expected == claimable, 'Wrong claimable');

        // withdraw VALUE from offseter 
        assert(erc3525.value_of(token_id) == 0, 'Wrong value of token_id');
        farmer.withdraw_to_token(token_id, VALUE);

        // balance should be egal to value deposited
        assert(VALUE == erc3525.value_of(token_id), 'Wrong balance');
        assert(0 == farmer.get_deposited_of(signers.anyone), 'Wrong deposited');
    }

    #[test]
    #[available_gas(999_000_000_000)]
    fn deposit_and_withdraw_value_in_yielder_multiple_user() {
        let (signers, contracts) = setup(PRICE);
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.yielder };
        let yielder = IYieldDispatcher { contract_address: contracts.yielder };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
        let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
        let erc721 = IERC721Dispatcher { contract_address: contracts.project };

        let (times, absorptions) = data::get_banegas();

        // Prank caller as owner
        set_contract_address(signers.owner);
        // Grant minter rights to owner, mint 1 token to users and revoke rights
        minter.add_minter(SLOT, signers.owner);
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    project.mint(*user, SLOT, VALUE * i);
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };
        minter.revoke_minter(SLOT, signers.owner);

        // Users deposit value
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    erc721.set_approval_for_all(contracts.yielder, true);
                    set_block_timestamp(1000 * i);
                    farmer.deposit(i.into(), VALUE * i.into());
                    let deposited = farmer.get_deposited_of(*user);
                    assert(
                        deposited == VALUE * i.into(),
                        'Wrong deposit for user' * 256 + 0x30 + i.into()
                    );
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // At t = One month after third absorption time
        set_block_timestamp(*times.at(2) + ONE_MONTH);

        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_block_timestamp(1690884000);
                    let previous_abs = absorber.get_current_absorption(SLOT);

                    set_block_timestamp(*times.at(2) + ONE_MONTH);

                    let claimable = yielder.get_claimable_of(*user);
                    assert(claimable != 0, 'Wrong claimable');
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let abs = current_abs - previous_abs;
                    let expected = (VALUE * i * abs.into() * PRICE) / PROJECT_VALUE;
                    assert(claimable == expected, 'Wrong claimable 2');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // withdraw VALUE from offseter for users
        set_block_timestamp(1690884000);
        let previous_abs = absorber.get_current_absorption(SLOT);
        // At t = Three month after 6th absorption time
        set_block_timestamp(*times.at(5) + 3 * ONE_MONTH);

        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    farmer.withdraw_to_token(i, VALUE * i);
                    let claimable = yielder.get_claimable_of(*user);
                    assert(claimable != 0, 'Wrong claimable 3');
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let abs = current_abs - previous_abs;
                    let expected = ((VALUE * i) * (abs.into() * PRICE)) / PROJECT_VALUE;
                    let claimed = yielder.get_claimed_of(*user);
                    assert(claimed == 0, 'Wrong claimed');
                    assert(claimable <= expected + 1, 'Wrong claimable 4');
                    assert(expected - 1 <= claimable, 'Wrong claimable 4');
                    let expected = claimable;

                    // Claim
                    yielder.claim();
                    let claimed = yielder.get_claimed_of(*user);
                    let claimable = yielder.get_claimable_of(*user);
                    assert(claimable == 0, 'Wrong claimable 5');
                    assert(claimed == expected, 'Wrong claimed');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };
    }

    #[test]
    #[available_gas(400_000_000)]
    fn deposit_and_withdraw_portion_value_in_yielder() {
        let (signers, contracts) = setup(PRICE);
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

        // Prank caller as anyone
        set_contract_address(signers.anyone);

        // At t = 0
        set_block_timestamp(0);
        // Anyone deposits value 100_000_000 in offseter
        farmer.deposit(token_id, VALUE / 2);
        let deposited = farmer.get_deposited_of(signers.anyone);
        assert(deposited == VALUE / 2, 'Wrong start deposited');

        // At t = Sep 01 2023 07:00:00 GMT+0000 (1 y after first absorption)
        set_block_timestamp(1690884000);
        let previous_abs = absorber.get_current_absorption(SLOT);
        set_block_timestamp(1693551600);

        // Then `get_claimable_of` should be different from 0
        let claimable = yielder.get_claimable_of(signers.anyone);
        let current_abs = absorber.get_current_absorption(SLOT);
        let abs = current_abs - previous_abs;
        let expected = ((VALUE / 2) * abs.into() * PRICE) / PROJECT_VALUE;
        let claimed = yielder.get_claimed_of(signers.anyone);
        assert(claimed == 0, 'Wrong claimed');
        assert(claimable == expected, 'Wrong claimable');

        // withdraw VALUE from yielder 
        assert(erc3525.value_of(token_id) == VALUE / 2, 'Wrong value of token_id');
        farmer.withdraw_to_token(token_id, VALUE / 2);
        // balance should be egal to value deposited
        assert(VALUE == erc3525.value_of(token_id), 'Wrong balance');

        // Check claimed yield balances
        let claimable = yielder.get_claimable_of(signers.anyone);
        let claimed = yielder.get_claimed_of(signers.anyone);
        assert(claimed == 0, 'Wrong claimed');
        assert(claimable == expected, 'Wrong claimable');
    }

    #[test]
    #[available_gas(400_000_000)]
    #[should_panic(
        expected: ('ERC3525: value exceeds balance', 'ENTRYPOINT_FAILED', 'ENTRYPOINT_FAILED')
    )]
    fn deposit_more_than_in_wallet() {
        let (signers, contracts) = setup(PRICE);
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

        // Prank caller as anyone
        set_contract_address(signers.anyone);

        // At t = 0
        set_block_timestamp(0);
        // Anyone deposits value 2*100_000_000 in yielder
        farmer.deposit(token_id, VALUE * 2);
    // let deposited = farmer.get_deposited_of(signers.anyone);
    // assert(deposited == VALUE * 2, 'value exceeds balance');
    }


    #[test]
    #[available_gas(4_000_000_000)]
    fn deposit_and_withdraw_value_in_yielder_multiple_user_diff_order() {
        let (signers, contracts) = setup(PRICE);
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.yielder };
        let yielder = IYieldDispatcher { contract_address: contracts.yielder };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
        let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
        let erc721 = IERC721Dispatcher { contract_address: contracts.project };

        let (times, absorptions) = data::get_banegas();

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    project.mint(*user, SLOT, VALUE * i);
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };
        minter.revoke_minter(SLOT, signers.owner);

        // Users deposit value at various times
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    erc721.set_approval_for_all(contracts.yielder, true);
                    let rnd: u256 = pedersen::pedersen((*user).into(), i.into())
                        .into() % (6 * 31 * 24 * 60 * 60);
                    let rnd: u64 = rnd.try_into().unwrap();
                    set_block_timestamp(*times.at(i - 1) + rnd - 3 * 31 * 24 * 60 * 60);
                    farmer.deposit(i.into(), VALUE * i.into());
                    let deposited = farmer.get_deposited_of(*user);
                    assert(
                        deposited == VALUE * i.into(),
                        'Wrong deposit for user' * 256 + 0x30 + i.into()
                    );
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // At t = One month after 10th absorption time
        // Check claimable
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    let rnd: u256 = pedersen::pedersen((*user).into(), i.into())
                        .into() % (6 * ONE_MONTH.into());
                    let rnd: u64 = rnd.try_into().unwrap();
                    let prev_time = max(*times.at(i - 1) + rnd - 3 * ONE_MONTH, 1690884000);
                    set_block_timestamp(prev_time);
                    let previous_abs = absorber.get_current_absorption(SLOT);

                    set_block_timestamp(*times.at(9) + ONE_MONTH);
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let abs = current_abs - previous_abs;
                    let expected = (VALUE * i.into() * abs.into() * PRICE) / PROJECT_VALUE;
                    let claimable = yielder.get_claimable_of(*user);

                    // Rounding error
                    assert(claimable <= expected + 1, 'Wrong claimable 1');
                    assert(claimable >= expected - 1, 'Wrong claimable 1');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // withdraw VALUE from offseter for users
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    let rnd: u256 = pedersen::pedersen((*user).into(), i.into())
                        .into() % (6 * ONE_MONTH.into());
                    let rnd: u64 = rnd.try_into().unwrap();
                    let prev_time = max(*times.at(i - 1) + rnd - 3 * ONE_MONTH, 1690884000);
                    set_block_timestamp(prev_time);
                    let previous_abs = absorber.get_current_absorption(SLOT);

                    // At t = Three month after 12th absorption time
                    set_block_timestamp(*times.at(11) + 3 * ONE_MONTH);
                    set_contract_address(*user);
                    farmer.withdraw_to_token(i.into(), VALUE * i.into());
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let abs = current_abs - previous_abs;
                    let expected = (VALUE * i.into() * abs.into() * PRICE) / PROJECT_VALUE;

                    let claimable = yielder.get_claimable_of(*user);
                    let claimed = yielder.get_claimed_of(*user);
                    assert(claimed == 0, 'Wrong claimed 2');
                    // Rounding error
                    assert(claimable <= expected + 1, 'Wrong claimable 2');
                    assert(claimable >= expected - 1, 'Wrong claimable 2');
                    let expected = claimable;

                    // Claim
                    yielder.claim();
                    let claimed = yielder.get_claimed_of(*user);
                    let claimable = yielder.get_claimable_of(*user);
                    assert(claimable == 0, 'Wrong claimable 3');
                    assert(claimed == expected, 'Wrong claimed');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };
    }
}

mod FarmingClaimingReward {
    use starknet::ContractAddress;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};
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
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };
    use carbon::components::farm::interface::{
        IFarmDispatcher, IFarmDispatcherTrait, IYieldFarmDispatcher, IYieldFarmDispatcherTrait
    };
    use carbon::tests::data;

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE, ONE_MONTH, TON_EQUIVALENT};
    use super::SpanPrintImpl;

    // Costly test to activate locally only
    //#[test]
    //#[available_gas(19_000_000_000)]
    fn ensure_correct_distribution() {
        let (mut signers, contracts) = setup(PRICE);
        // Instantiate contracts
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let certifier = ICertifierDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
        let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
        let erc721 = IERC721Dispatcher { contract_address: contracts.project };

        // Prank caller as owner
        set_contract_address(signers.owner);

        minter.add_minter(SLOT, signers.owner);

        // Override price and absorptions
        let abs_times = array![0, 10, 20, 30, 40].span();
        let absorptions = array![0, 10000, 20000, 30000, 40000].span();
        let price_times = array![15, 20, 25, 30, 35].span();

        let mut datasets: Span<Span<u256>> = array![
            array![22, 24, 28, 30, 47].span(),
            array![22, 20, 18, 12, 7].span(),
            array![22, 24, 18, 12, 47].span(),
            array![22, 24, 0, 12, 47].span(),
            array![22, 24, 18, 12, 0].span(),
            array![22, 0, 0, 12, 47].span(),
            array![0, 0, 0, 12, 47].span(),
        ]
            .span();

        // Keep only 4 users
        signers.users.pop_front();
        signers.users.pop_front();
        let num_users: u256 = signers.users.len().into();

        let mut slot = 0;
        loop {
            match datasets.pop_front() {
                Option::Some(prices) => {
                    slot += 1;
                    ('dataset' * 256 + '0' + slot.try_into().unwrap()).print();
                    set_contract_address(signers.owner);
                    certifier.set_certifier(slot, signers.owner);

                    let prices = *prices;
                    // Compute prices at times [0,1,2,...,40]
                    let full_prices = array![
                        // 0 to 15
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        *prices.at(0),
                        // 15 to 20
                        *prices.at(1),
                        *prices.at(1),
                        *prices.at(1),
                        *prices.at(1),
                        *prices.at(1),
                        // 20 to 25
                        *prices.at(2),
                        *prices.at(2),
                        *prices.at(2),
                        *prices.at(2),
                        *prices.at(2),
                        // 25 to 30
                        *prices.at(3),
                        *prices.at(3),
                        *prices.at(3),
                        *prices.at(3),
                        *prices.at(3),
                        // 30 to 40
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        *prices.at(4),
                        // 41--42 (abs should be zero)
                        *prices.at(4),
                        *prices.at(4),
                    ]
                        .span();

                    // Setup new yielder
                    let contract_yielder = super::deploy_yielder(
                        contracts.project, erc20.contract_address, signers.owner, slot
                    );
                    let yielder = IYieldDispatcher { contract_address: contract_yielder };
                    let farmer = IFarmDispatcher { contract_address: contract_yielder };
                    let yieldfarmer = IYieldFarmDispatcher { contract_address: contract_yielder };

                    // Setup slot
                    set_block_timestamp(0);
                    absorber.set_absorptions(slot, abs_times, absorptions, TON_EQUIVALENT);
                    absorber.set_project_value(slot, PROJECT_VALUE);
                    yieldfarmer.set_prices(price_times, prices);

                    // Setup and mint value to users
                    minter.add_minter(slot, signers.owner);
                    let mut users = signers.users.span();
                    let mut i = 1;
                    loop {
                        match users.pop_front() {
                            Option::Some(user) => {
                                set_contract_address(*user);
                                erc721.set_approval_for_all(contract_yielder, true);
                                set_contract_address(signers.owner);
                                assert(
                                    (num_users + 1) * (slot - 1)
                                        + i.into() == project.mint(*user, slot, VALUE * i),
                                    'Wrong token'
                                );
                                i += 1;
                            },
                            Option::None => {
                                break ();
                            }
                        };
                    };

                    // Check claimables for all users at all times
                    let mut users = signers.users.span();
                    let mut i = 1;
                    loop {
                        // Check claimables for user i
                        match users.pop_front() {
                            Option::Some(user) => {
                                // User i deposits at time 2*(i-1)
                                set_contract_address(*user);
                                set_block_timestamp(2 * (i - 1));
                                farmer
                                    .deposit(
                                        (num_users + 1) * (slot - 1) + i.into(), VALUE * i.into()
                                    );
                                let deposited = farmer.get_deposited_of(*user);
                                assert(
                                    deposited == VALUE * i.into(),
                                    'Wrong deposit for user' * 256 + 0x30 + i.into()
                                );

                                // Check claimable at all times
                                let mut time = 2 * (i - 1);
                                let mut cumsale = 0;
                                loop {
                                    time += 1;
                                    if time > 42 {
                                        break ();
                                    }
                                    set_block_timestamp(time);
                                    let claimable = yielder.get_claimable_of(*user);

                                    // Absorption per tick is constant (1000)
                                    let mut abs_const = 0;
                                    if time <= 40 {
                                        abs_const = 1000;
                                    }
                                    let current_sale = abs_const
                                        * *full_prices.at(time.try_into().unwrap());
                                    cumsale += current_sale;
                                    let expected = (VALUE * i.into() * cumsale) / PROJECT_VALUE;

                                    assert(
                                        claimable <= expected + 1,
                                        'Wrong claimable for user' * 256 + 0x30 + i.into()
                                    );
                                    assert(
                                        claimable >= {
                                            if expected.is_zero() {
                                                0
                                            } else {
                                                expected - 1
                                            }
                                        },
                                        'Wrong claimable for user' * 256 + 0x30 + i.into()
                                    );
                                };
                                i += 1;
                            },
                            Option::None => {
                                break ();
                            }
                        };
                    };
                },
                Option::None => {
                    break ();
                }
            };
        };
    }

    #[test]
    #[available_gas(500_000_000)]
    fn farm_then_transfer_then_farm() {
        let (signers, contracts) = setup(PRICE);
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.yielder };
        let yielder = IYieldDispatcher { contract_address: contracts.yielder };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
        let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
        let erc721 = IERC721Dispatcher { contract_address: contracts.project };

        let (times, absorptions) = data::get_banegas();

        // Prank caller as owner
        set_contract_address(signers.owner);
        let userA = *signers.users[0];
        set_contract_address(userA);
        erc721.set_approval_for_all(contracts.yielder, true);
        let userB = *signers.users[1];
        set_contract_address(userB);
        erc721.set_approval_for_all(contracts.yielder, true);
        let userWitness = *signers.users[2];
        set_contract_address(userWitness);
        erc721.set_approval_for_all(contracts.yielder, true);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        set_contract_address(signers.owner);
        minter.add_minter(SLOT, signers.owner);
        assert(1 == project.mint(userA, SLOT, VALUE), 'first token');
        assert(2 == project.mint(userWitness, SLOT, VALUE), 'second token');
        minter.revoke_minter(SLOT, signers.owner);

        set_block_timestamp(*times[0] - 1);
        set_contract_address(userWitness);
        farmer.deposit(2, VALUE);
        set_contract_address(userA);
        farmer.deposit(1, VALUE);
        set_block_timestamp(*times[3] + 1);
        let claimableA_at_t3 = yielder.get_claimable_of(userA);
        farmer.withdraw_to_token(1, VALUE);
        assert(4 == erc3525.transfer_value_from(1, 0, userB, VALUE), 'third token');

        set_contract_address(userB);
        farmer.deposit(4, VALUE);
        set_block_timestamp(*times[7] + 1);
        let claimableA_at_t7 = yielder.get_claimable_of(userA);
        let claimableB_at_t7 = yielder.get_claimable_of(userB);
        let claimableW_at_t7 = yielder.get_claimable_of(userWitness);

        assert(claimableA_at_t3 > 0, 'Wrong claimable 1');
        assert(claimableA_at_t7 == claimableA_at_t3, 'Wrong claimable 2');
        assert(claimableB_at_t7 + claimableA_at_t7 == claimableW_at_t7, 'Wrong claimable 2');
    }


    #[test]
    #[available_gas(5_000_000_000)]
    fn multiple_user_deposit() {
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

        let (times, absorptions) = data::get_banegas();
        let price_times: Array<u64> = array![1690884000, 1696154400];

        // Mint value to users
        set_contract_address(signers.owner);
        minter.add_minter(SLOT, signers.owner);
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    erc721.set_approval_for_all(contracts.yielder, true);
                    set_contract_address(signers.owner);
                    assert(i == project.mint(*user, SLOT, VALUE * i), 'Wrong token');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // Users deposit value
        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    set_block_timestamp(0 * i);
                    farmer.deposit(i.into(), VALUE * i.into());
                    let deposited = farmer.get_deposited_of(*user);
                    assert(
                        deposited == VALUE * i.into(),
                        'Wrong deposit for user' * 256 + 0x30 + i.into()
                    );
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };
        // Claim rewards

        set_block_timestamp(*price_times.at(0));
        let prev_abs = absorber.get_current_absorption(SLOT);
        set_block_timestamp(*price_times.at(1) + ONE_MONTH);
        let curr_abs = absorber.get_current_absorption(SLOT);
        let abs = curr_abs - prev_abs;

        let mut users = signers.users.span();
        let mut i: usize = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    yielder.claim();
                    let rewards = erc20.balance_of(*user);
                    let expected = (VALUE * i.into() * abs.into() * PRICE) / PROJECT_VALUE;

                    // TODO: off-by-one error
                    assert(
                        rewards <= expected + 1, 'Wrong rewards for user' * 256 + 0x30 + i.into()
                    );
                    assert(
                        rewards >= expected - 1, 'Wrong rewards for user' * 256 + 0x30 + i.into()
                    );
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };
    }

    #[test]
    #[available_gas(4000_000_000)]
    #[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED', 'ENTRYPOINT_FAILED'))]
    fn claim_rewards_first_no_usdc_then_enough_usdc() {
        // test should panic on yielder.claim() as no usdc     

        let (signers, contracts) = setup(PRICE);
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

        // Prank caller as anyone
        set_contract_address(signers.anyone);

        // At t = 0
        set_block_timestamp(0);
        // Anyone deposits value 100_000_000 in yielder
        farmer.deposit(token_id, VALUE);
        let deposited = farmer.get_deposited_of(signers.anyone);

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

        let amount = erc20.balance_of(yielder.contract_address);
        // pranl caller is yielder
        set_contract_address(yielder.contract_address);
        // yielder transfer amount to owner
        erc20.transfer(signers.owner, amount);
        let amount = erc20.balance_of(yielder.contract_address);
        // verify amount is 0
        assert(amount == 0, 'Wrong balance');

        // Prank caller as anyone
        set_contract_address(signers.anyone);

        // move timestamp one month later
        set_block_timestamp(1693551600);
        // Compute expected balance
        let claimable = yielder.get_claimable_of(signers.anyone);

        let expected_balance = erc20.balance_of(signers.anyone) + claimable;
        // Anyone claims should fail !
        yielder.claim();
    }

    #[test]
    #[available_gas(4000_000_000)]
    fn farm_but_no_price_set() {
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

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);
        let token_id = project.mint(signers.anyone, SLOT, VALUE);
        minter.revoke_minter(SLOT, signers.owner);

        // Prank caller as user
        set_contract_address(signers.anyone);

        // At t = 0
        set_block_timestamp(0);
        // Anyone deposits value 100_000_000 in yielder
        farmer.deposit(token_id, VALUE);
        let deposited = farmer.get_deposited_of(signers.anyone);

        // two month after time setup - ie the price is not setup the last prie to be taken in consideration is PRICE
        set_block_timestamp(1696154400 + 2 * ONE_MONTH);
        // Compute expected balance
        let claimable = yielder.get_claimable_of(signers.anyone);

        // Prank caller as owner
        set_contract_address(signers.owner);

        // UPDATING NEW PRICES
        let times: Array<u64> = array![
            1690884000, 1696154400, 1696154400 + ONE_MONTH, 1696154400 + ONE_MONTH * 2
        ]; // Aug 01 2023 10:00:00 GMT+0000, Oct 01 2023 10:00:00 GMT+0000
        let prices: Array<u256> = array![0, PRICE, PRICE * 2, PRICE * 3];

        yieldfarmer.set_prices(times.span(), prices.span());

        // Prank caller as user
        set_contract_address(signers.anyone);

        let claimable2 = yielder.get_claimable_of(signers.anyone);
        assert(claimable2 > claimable, 'nouveau pric pas pris en compte');
    }
}


mod PriceConfigAccounting {
    use starknet::ContractAddress;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};
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
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };
    use carbon::components::farm::interface::{
        IFarmDispatcher, IFarmDispatcherTrait, IYieldFarmDispatcher, IYieldFarmDispatcherTrait
    };

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE, ONE_MONTH, TON_EQUIVALENT};
    use super::SpanPrintImpl;

    #[test]
    #[available_gas(4_000_000_000)]
    fn setting_overwriting_prices() {
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

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);
        project.mint(signers.anyone, SLOT, VALUE);
        project.mint(signers.owner, SLOT, VALUE);
        minter.revoke_minter(SLOT, signers.owner);

        let ONE_DAY = 24 * 60 * 60;
        let times: Array<u64> = array![
            1690884000 - 2 * ONE_MONTH,
            1690884000,
            1690884000 + 2 * ONE_DAY,
            1696154400 - 2 * ONE_DAY,
            1696154400,
            1696154400 + 2 * ONE_MONTH,
            1696154400 + 6 * ONE_MONTH
        ];

        let abs: Array<u64> = array![0, 1000, 2000, 3000, 4000, 5000, 6000];
        absorber.set_absorptions(SLOT, times.span(), abs.span(), TON_EQUIVALENT);

        let times: Array<u64> = array![
            1690884000, 1696154400
        ]; // Aug 01 2023 10:00:00 GMT+0000, Oct 01 2023 10:00:00 GMT+0000
        let prices: Array<u256> = array![0, 20];
        // Set prices again to update updated_prices
        yieldfarmer.set_prices(times.span(), prices.span());

        let updated_prices = yieldfarmer.get_updated_prices();
        assert(updated_prices == array![0, 0, 20, 20, 20, 20, 20].span(), 'Wrong price 1');

        // Deposit as anyone
        set_contract_address(signers.anyone);
        farmer.deposit(1, VALUE);
        set_contract_address(signers.owner);

        // OVERWRITE PRICE
        let times: Array<u64> = array![
            1690884000, 1696154400, 1696154400 + ONE_MONTH, 1696154400 + ONE_MONTH * 2
        ];
        let prices: Array<u256> = array![0, 0, PRICE, 2 * PRICE];
        set_contract_address(signers.owner);
        yieldfarmer.set_prices(times.span(), prices.span());

        let updated_prices = yieldfarmer.get_updated_prices();
        assert(
            updated_prices == array![0, 0, 0, 0, 0, PRICE, 2 * PRICE, 2 * PRICE].span(),
            'Wrong price 2'
        );
    }

    #[test]
    #[available_gas(4_000_000_000)]
    fn verifying_new_prices_in_accounting() {
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

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);
        project.mint(signers.anyone, SLOT, VALUE);
        project.mint(signers.owner, SLOT, VALUE);
        minter.revoke_minter(SLOT, signers.owner);

        // Deposit as anyone
        set_contract_address(signers.anyone);
        farmer.deposit(1, VALUE);

        set_block_timestamp(1690884000 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) == 0, 'Wrong claimable 1');
        set_block_timestamp(1696154400 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) > 0, 'Wrong claimable 2');

        // OVERWRITE PRICE
        let times: Array<u64> = array![
            1690884000, 1696154400, 1696154400 + ONE_MONTH, 1696154400 + ONE_MONTH * 2
        ];
        let prices: Array<u256> = array![0, 0, 2 * PRICE, 2 * PRICE];
        set_contract_address(signers.owner);
        yieldfarmer.set_prices(times.span(), prices.span());
        // set_contract_address(signers.anyone);

        set_block_timestamp(1690884000 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) == 0, 'Wrong claimable 3');
        set_block_timestamp(1696154400 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) == 0, 'Wrong claimable 4');
        set_block_timestamp(1696154400 + 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) > 0, 'Wrong claimable 5');

        // OVERWRITE PRICE AND DEPOSIT
        set_block_timestamp(1690884000 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) == 0, 'Wrong claimable 3');
        set_block_timestamp(1690884000 - 24 * 60 * 60);
        farmer.deposit(2, VALUE / 4);
        set_block_timestamp(1690884000 + 24 * 60 * 60);
        farmer.deposit(2, VALUE / 4);
        set_block_timestamp(1696154400 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) == 0, 'Wrong claimable 4');
        assert(yielder.get_claimable_of(signers.owner) == 0, 'Wrong claimable o4');
        set_block_timestamp(1696154400 + 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) > 0, 'Wrong claimable 5');
        assert(yielder.get_claimable_of(signers.owner) > 0, 'Wrong claimable o5');

        // OVERWRITE PRICE AND DEPOSIT AND CLAIM
        set_block_timestamp(1690884000 + 2 * 24 * 60 * 60);
        yielder.claim();
        set_block_timestamp(1696154400 - 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) == 0, 'Wrong claimable 6');
        assert(yielder.get_claimable_of(signers.owner) == 0, 'Wrong claimable o6');
        set_block_timestamp(1696154400 + 7 * 24 * 60 * 60);
        assert(yielder.get_claimable_of(signers.anyone) > 0, 'Wrong claimable 7');
        assert(yielder.get_claimable_of(signers.owner) > 0, 'Wrong claimable o7');
    }
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

mod VerifyCumulativeSalePrice {
    use starknet::ContractAddress;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};
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
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };
    use carbon::components::farm::interface::{
        IFarmDispatcher, IFarmDispatcherTrait, IYieldFarmDispatcher, IYieldFarmDispatcherTrait
    };
    use carbon::tests::data;

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE, TON_EQUIVALENT};
    use super::SpanPrintImpl;

    #[test]
    #[available_gas(4_000_000_000)]
    fn set_prices_and_verify_cumsales_datasets() {
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

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);

        // Override price and absorptions
        let abs_times = array![0, 10, 20, 30, 40];
        let absorptions = array![0, 10000, 20000, 30000, 40000];
        absorber.set_absorptions(SLOT, abs_times.span(), absorptions.span(), TON_EQUIVALENT);
        let price_times = array![15, 20, 25, 30, 35];

        let mut datasets: Span<Span<u256>> = array![
            array![22, 24, 28, 30, 47].span(),
            array![22, 20, 18, 12, 7].span(),
            array![22, 24, 18, 12, 47].span(),
            array![22, 24, 0, 12, 47].span(),
            array![22, 24, 18, 12, 0].span(),
            array![22, 0, 0, 12, 47].span(),
            array![22, 22, 0, 0, 47].span(),
        ]
            .span();

        loop {
            match datasets.pop_front() {
                Option::Some(prices) => {
                    let prices = *prices;

                    yieldfarmer.set_prices(price_times.span(), prices);

                    let cumsales = yieldfarmer.get_cumsales();
                    let cum_times = yieldfarmer.get_cumsale_times();
                    let updated_prices = yieldfarmer.get_updated_prices();

                    assert(
                        updated_prices == array![
                            *prices[0],
                            *prices[0],
                            *prices[0],
                            *prices[1],
                            *prices[2],
                            *prices[3],
                            *prices[4],
                            *prices[4]
                        ]
                            .span(),
                        'Wrong updated_prices'
                    );
                    assert(
                        cum_times == array![0, 10, 15, 20, 25, 30, 35, 40].span(), 'Wrong cum_times'
                    );
                    assert(
                        cumsales == array![
                            0,
                            10000 * *prices[0],
                            15000 * *prices[0],
                            15000 * *prices[0] + 5000 * *prices[1],
                            15000 * *prices[0] + 5000 * *prices[1] + 5000 * *prices[2],
                            15000 * *prices[0]
                                + 5000 * *prices[1]
                                + 5000 * *prices[2]
                                + 5000 * *prices[3],
                            15000 * *prices[0]
                                + 5000 * *prices[1]
                                + 5000 * *prices[2]
                                + 5000 * *prices[3]
                                + 5000 * *prices[4],
                            15000 * *prices[0]
                                + 5000 * *prices[1]
                                + 5000 * *prices[2]
                                + 5000 * *prices[3]
                                + 10000 * *prices[4],
                        ]
                            .span(),
                        'Wrong cumsales'
                    );
                },
                Option::None => {
                    break ();
                }
            };
        };
    }


    #[test]
    #[available_gas(4_000_000_000)]
    fn set_prices_and_verify_cumsales_iso_dataset() {
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

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);

        // Override price and absorptions
        let (abs_times, absorptions) = data::get_banegas();
        absorber.set_absorptions(SLOT, abs_times, absorptions, TON_EQUIVALENT);

        'TODO'.print();
    }
}


mod AdditionalTests {
    use starknet::ContractAddress;
    use starknet::testing::{set_caller_address, set_contract_address, set_block_timestamp};
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
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };
    use carbon::components::farm::interface::{
        IFarmDispatcher, IFarmDispatcherTrait, IYieldFarmDispatcher, IYieldFarmDispatcherTrait
    };
    use carbon::tests::data;

    use super::setup;
    use super::SpanPrintImpl;
    use super::{SLOT, VALUE, PROJECT_VALUE, ONE_MONTH, ONE_DAY, TON_EQUIVALENT, PRICE};


    #[test]
    #[available_gas(400_000_000_000)]
    fn expected_claimable_vs_get_claimable_of() {
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

        let (times, absorptions) = data::get_banegas();

        // Prank caller as owner
        set_contract_address(signers.owner);
        absorber.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        minter.add_minter(SLOT, signers.owner);
        let one = project.mint(signers.anyone, SLOT, VALUE);
        minter.revoke_minter(SLOT, signers.owner);

        // Prank caller as anyone
        set_contract_address(signers.anyone);

        // Deposit when yielder has price set
        let mut time = 1696154400;
        set_block_timestamp(time);
        let prev_abs = absorber.get_current_absorption(SLOT);
        let value = VALUE / 3;
        farmer.deposit(one, value);
        let deposited = farmer.get_deposited_of(signers.anyone);
        assert(deposited == value, 'Wrong deposited value');

        loop {
            if time > *times.at(times.len() - 1) {
                break ();
            }
            set_block_timestamp(time);

            let claimable = yielder.get_claimable_of(signers.anyone);
            let user_abs = farmer.get_absorption_of(signers.anyone);
            let current_abs = absorber.get_current_absorption(SLOT);
            let abs = current_abs - prev_abs;
            let expected_abs = (value * abs.into()) / PROJECT_VALUE;
            if expected_abs != user_abs {
                time.print();
                'abs error'.print();
                expected_abs.low.print();
                user_abs.low.print();
            }
            assert(expected_abs == user_abs, 'expected != user_abs');
            let expected_claimable = (value * abs.into() * PRICE) / PROJECT_VALUE;
            let abs_times_price = expected_abs.into() * PRICE;
            let expected_2 = (value * (current_abs.into() * PRICE - prev_abs.into() * PRICE))
                / PROJECT_VALUE;

            if expected_claimable != claimable {
                assert(claimable == expected_claimable + 1, 'Rounding error too large');
            }

            time += 5 * ONE_MONTH + 11 * ONE_DAY;
        }
    }


    #[test]
    #[available_gas(400_000_000_000)]
    fn distribute_all_claim_sparse() {
        let (signers, contracts) = setup(PRICE);
        // Instantiate contracts
        let yieldfarmer = IYieldFarmDispatcher { contract_address: contracts.yielder };
        let farmer = IFarmDispatcher { contract_address: contracts.yielder };
        let yielder = IYieldDispatcher { contract_address: contracts.yielder };
        let certifier = ICertifierDispatcher { contract_address: contracts.project };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
        let erc20 = IERC20Dispatcher { contract_address: contracts.erc20 };
        let erc721 = IERC721Dispatcher { contract_address: contracts.project };

        let (times, absorptions) = data::get_banegas();

        let user1 = *signers.users[0];
        let user2 = *signers.users[1];
        let user3 = *signers.users[2];
        let user4 = *signers.users[3];

        set_contract_address(signers.owner);

        // Deploy yielders
        let contract_yielder2 = super::deploy_yielder(
            contracts.project, erc20.contract_address, signers.owner, SLOT + 1
        );
        let contract_yielder3 = super::deploy_yielder(
            contracts.project, erc20.contract_address, signers.owner, SLOT + 2
        );
        let yielder2 = IYieldDispatcher { contract_address: contract_yielder2 };
        let farmer2 = IFarmDispatcher { contract_address: contract_yielder2 };
        let yieldfarmer2 = IYieldFarmDispatcher { contract_address: contract_yielder2 };

        let yielder3 = IYieldDispatcher { contract_address: contract_yielder3 };
        let farmer3 = IFarmDispatcher { contract_address: contract_yielder3 };
        let yieldfarmer3 = IYieldFarmDispatcher { contract_address: contract_yielder3 };

        // Setup slots
        certifier.set_certifier(SLOT + 0, signers.owner);
        certifier.set_certifier(SLOT + 1, signers.owner);
        certifier.set_certifier(SLOT + 2, signers.owner);
        absorber.set_absorptions(SLOT + 0, times, absorptions, TON_EQUIVALENT);
        absorber.set_project_value(SLOT + 0, PROJECT_VALUE);
        absorber.set_absorptions(SLOT + 1, times, absorptions, TON_EQUIVALENT);
        absorber.set_project_value(SLOT + 1, PROJECT_VALUE);
        absorber.set_absorptions(SLOT + 2, times, absorptions, TON_EQUIVALENT);
        absorber.set_project_value(SLOT + 2, PROJECT_VALUE);
        super::setup_yielder(
            project.contract_address,
            erc20.contract_address,
            yielder2.contract_address,
            @signers,
            PRICE
        );
        super::setup_yielder(
            project.contract_address,
            erc20.contract_address,
            yielder3.contract_address,
            @signers,
            PRICE
        );

        set_contract_address(signers.owner);
        erc20.transfer(yielder.contract_address, 100_000_000_000);
        erc20.transfer(yielder2.contract_address, 100_000_000_000);
        erc20.transfer(yielder3.contract_address, 100_000_000_000);

        minter.add_minter(SLOT + 0, signers.owner);
        minter.add_minter(SLOT + 1, signers.owner);
        minter.add_minter(SLOT + 2, signers.owner);
        assert(1 == project.mint(user1, SLOT + 0, VALUE), 'Wrong token 1');
        assert(2 == project.mint(user2, SLOT + 1, VALUE), 'Wrong token 2');
        assert(3 == project.mint(user3, SLOT + 2, VALUE), 'Wrong token 3');
        assert(4 == project.mint(user4, SLOT + 2, VALUE), 'Wrong token 4');
        minter.revoke_minter(SLOT + 0, signers.owner);
        minter.revoke_minter(SLOT + 1, signers.owner);
        minter.revoke_minter(SLOT + 2, signers.owner);

        // Set approvals
        set_contract_address(user1);
        erc721.set_approval_for_all(contracts.yielder, true);
        set_contract_address(user2);
        erc721.set_approval_for_all(contracts.yielder, true);
        erc721.set_approval_for_all(yielder2.contract_address, true);
        set_contract_address(user3);
        erc721.set_approval_for_all(yielder3.contract_address, true);
        set_contract_address(user4);
        erc721.set_approval_for_all(yielder3.contract_address, true);

        // on yielder1: user1 deposits at t=start and claims at t=end
        set_contract_address(user1);
        set_block_timestamp(*times.at(0) - 1);
        assert(0 == erc20.balance_of(user1), 'Wrong balance');
        farmer.deposit(1, VALUE);
        set_block_timestamp(*times.at(times.len() - 1) + 1);
        yielder.claim();
        let rewards_u1 = erc20.balance_of(user1);

        // on yielder2: user2 deposits at t=start and claims at t=[start+end/(1,2,3,4)]
        set_contract_address(user2);
        set_block_timestamp(*times.at(0) - 1);
        assert(0 == erc20.balance_of(user2), 'Wrong balance');
        farmer2.deposit(2, VALUE);
        set_block_timestamp(*times.at(times.len() / 4 - 1) + 1);
        yielder2.claim();
        set_block_timestamp(*times.at(times.len() / 3 - 1) + 1);
        yielder2.claim();
        set_block_timestamp(*times.at(times.len() / 2 - 1) + 1);
        yielder2.claim();
        set_block_timestamp(*times.at(times.len() - 1) + 1);
        yielder2.claim();
        let rewards_u2 = erc20.balance_of(user2);

        // on yielder3: user3 and user4 do the above actions at the same time
        set_contract_address(user3);
        set_block_timestamp(*times.at(0) - 1);
        assert(0 == erc20.balance_of(user3), 'Wrong balance');
        farmer3.deposit(3, VALUE);
        set_contract_address(user4);
        set_block_timestamp(*times.at(0) - 1);
        assert(0 == erc20.balance_of(user4), 'Wrong balance');
        farmer3.deposit(4, VALUE);
        set_block_timestamp(*times.at(times.len() / 4 - 1) + 1);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() / 3 - 1) + 1);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() / 2 - 1) + 1);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() / 2 - 1) + 2);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() / 2 - 1) + 3);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() / 2 - 1) + 4);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() / 2 - 1) + 10);
        yielder3.claim();
        set_block_timestamp(*times.at(times.len() - 1) + 1);
        yielder3.claim();
        set_contract_address(user3);
        yielder3.claim();
        let rewards_u3 = erc20.balance_of(user2);
        let rewards_u4 = erc20.balance_of(user2);

        assert(rewards_u1 > 0, 'Wrong rewards for user1');
        assert(
            rewards_u1 == rewards_u2 && rewards_u2 == rewards_u3 && rewards_u3 == rewards_u4,
            'Wrong rewards for user2'
        );
    }
}


#[test]
#[available_gas(575_000_000)]
fn yielder_total_abs_exceeds_max_abs() {
    let (signers, contracts) = setup(PRICE);
    // Instantiate contracts
    let yieldfarmer = IYieldFarmDispatcher { contract_address: contracts.yielder };
    let farmer = IFarmDispatcher { contract_address: contracts.yielder };
    let yielder = IYieldDispatcher { contract_address: contracts.yielder };
    let minter = IMinterDispatcher { contract_address: contracts.project };
    let project = IProjectDispatcher { contract_address: contracts.project };
    let absorber = IAbsorberDispatcher { contract_address: contracts.project };
    let erc721 = IERC721Dispatcher { contract_address: contracts.project };

    let (times, absorptions) = data::get_banegas();

    let user1 = *signers.users[0];
    let user2 = *signers.users[1];

    // Setup
    set_contract_address(signers.owner);
    absorber.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
    let price_times: Array<u64> = array![1679312000, 2598134400];
    let prices: Array<u256> = array![0, PRICE];
    yieldfarmer.set_prices(price_times.span(), prices.span());

    // Grant minter rights to owner, mint 1 token to anyone and revoke rights
    minter.add_minter(SLOT, signers.owner);
    assert(1 == project.mint(user1, SLOT, VALUE * 1), 'Wrong token');
    assert(2 == project.mint(user2, SLOT, VALUE * 2), 'Wrong token');
    minter.revoke_minter(SLOT, signers.owner);

    // Setup approvals
    set_contract_address(user1);
    erc721.set_approval_for_all(contracts.yielder, true);
    set_contract_address(user2);
    erc721.set_approval_for_all(contracts.yielder, true);

    let user1_deposit_time = *times.at(1) + ONE_DAY;
    set_block_timestamp(user1_deposit_time);
    let project_prev_abs1 = absorber.get_absorption(SLOT, user1_deposit_time);
    set_contract_address(user1);
    farmer.deposit(1, VALUE * 1);
    let user1_prev_abs = farmer.get_absorption_of(user1);
    let user2_deposit_time = *times.at(2) + ONE_DAY;
    set_block_timestamp(user2_deposit_time);
    let project_prev_abs2 = absorber.get_absorption(SLOT, user2_deposit_time);
    set_contract_address(user2);
    farmer.deposit(2, VALUE * 2);
    let user2_prev_abs = farmer.get_absorption_of(user2);
    let claim_time = *times.at(4) + ONE_DAY * 3;
    set_block_timestamp(claim_time);
    let project_prev_abs2 = absorber.get_absorption(SLOT, claim_time);

    let new_abs_user1 = farmer.get_absorption_of(user1);
    let new_abs_user2 = farmer.get_absorption_of(user2);
}
