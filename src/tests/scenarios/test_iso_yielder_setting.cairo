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
    let yielder = deploy_yielder(project, erc20, signers.owner);
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

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE, ONE_MONTH};


    #[test]
    #[available_gas(4000_000_000)]
    fn ensure_right_distribution() {
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
    // TODO
    }

    #[test]
    #[available_gas(4000_000_000)]
    fn claim_part_of_usdc() {
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
    // TODO
    }

    #[test]
    #[available_gas(4000_000_000)]
    fn multi_deposit_before_start_then_claim_after_start() {
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
    // TODO
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
        'claimable: '.print();
        claimable.print();

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
    use carbon::components::farm::interface::{IFarmDispatcher, IFarmDispatcherTrait};
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE};

    #[test]
    #[available_gas(4_000_000_000)]
    fn setting_overwriting_prices() {
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

        panic(array!['TODO']);
    }

    #[test]
    #[available_gas(4_000_000_000)]
    fn verifying_new_prices_in_accounting() {
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

        panic(array!['TODO']);
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
    use carbon::components::farm::interface::{IFarmDispatcher, IFarmDispatcherTrait};
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::components::yield::interface::{IYieldDispatcher, IYieldDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };

    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, PRICE};

    #[test]
    #[available_gas(4_000_000_000)]
    fn set_prices_and_verify_cumsales_dataset1() {
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

        panic(array!['TODO']);
    }

    #[test]
    #[available_gas(4_000_000_000)]
    fn set_prices_and_verify_cumsales_dataset2() {
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

        panic(array!['TODO']);
    }

    #[test]
    #[available_gas(4_000_000_000)]
    fn set_prices_and_verify_cumsales_dataset3() {
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

        panic(array!['TODO']);
    }

    #[test]
    #[available_gas(4_000_000_000)]
    fn set_prices_and_verify_cumsales_dataset4() {
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

        panic(array!['TODO']);
    }
}
