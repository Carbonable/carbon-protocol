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
use carbon::components::farm::interface::{IFarmDispatcher, IFarmDispatcherTrait};
use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};

// Contracts

use carbon::contracts::project::{
    Project, IExternalDispatcher as IProjectDispatcher,
    IExternalDispatcherTrait as IProjectDispatcherTrait
};
use carbon::contracts::offseter::Offseter;
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
const MIN_CLAIMABLE: u256 = 1;
const ONE_MONTH: u64 = consteval_int!(31 * 24 * 60 * 60);
const ONE_DAY: u64 = consteval_int!(24 * 60 * 60);

// Signers
#[derive(Drop)]
struct Signers {
    owner: ContractAddress,
    anyone: ContractAddress,
    users: Array<ContractAddress>,
}

#[derive(Drop)]
struct Contracts {
    project: ContractAddress,
    offseter: ContractAddress,
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

fn deploy_offseter(project: ContractAddress, owner: ContractAddress) -> ContractAddress {
    let mut calldata: Array<felt252> = array![
        project.into(),
        SLOT.low.into(),
        SLOT.high.into(),
        MIN_CLAIMABLE.low.into(),
        MIN_CLAIMABLE.high.into(),
        owner.into()
    ];
    let (address, _) = deploy_syscall(
        Offseter::TEST_CLASS_HASH.try_into().expect('Class hash conversion failed'),
        0,
        calldata.span(),
        false
    )
        .expect('Offseter deploy failed');
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

fn setup_offseter(project: ContractAddress, offseter: ContractAddress, signers: @Signers) {
    set_contract_address(*signers.owner);
    let farmer = IFarmDispatcher { contract_address: offseter };
    // Owner approve offseter to spend his tokens
    let project = IERC721Dispatcher { contract_address: project };
    project.set_approval_for_all(offseter, true);
    // Anyone approve offseter to spend his tokens
    set_contract_address(*signers.anyone);
    project.set_approval_for_all(offseter, true);
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
    let signers = Signers {
        owner: deploy_account('OWNER'),
        anyone: deploy_account('ANYONE'),
        users: array![
            deploy_account('USER1'),
            deploy_account('USER2'),
            deploy_account('USER3'),
            deploy_account('USER4'),
            deploy_account('USER5'),
            deploy_account('USER6')
        ],
    };
    let project = deploy_project(signers.owner);
    let offseter = deploy_offseter(project, signers.owner);

    // Setup
    setup_project(project, @signers);
    setup_offseter(project, offseter, @signers);

    // Return
    let contracts = Contracts { project: project, offseter: offseter, };
    (signers, contracts)
}

mod FarmingDepositWithdrawOffseter {
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
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };
    use carbon::tests::data;
    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, ONE_MONTH};


    #[test]
    #[available_gas(400_000_000)]
    fn deposit_and_withdraw_value_in_offseter() {
        let (signers, contracts) = setup();
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.offseter };
        let offseter = IOffsetDispatcher { contract_address: contracts.offseter };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };

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
        farmer.deposit(token_id, VALUE);
        let deposited = farmer.get_deposited_of(signers.anyone);
        assert(deposited == VALUE, 'Wrong deposited value');

        // At t = Sep 01 2023 07:00:00 GMT+0000 (1 y  after first absorption)
        set_block_timestamp(1693551600);

        // Then `get_claimable_of` should be different from 0
        let claimable = offseter.get_claimable_of(signers.anyone);
        assert(claimable != 0, 'Claimable should not be 0');
        let current_abs = absorber.get_current_absorption(SLOT);
        let expected = (VALUE * current_abs.into()) / PROJECT_VALUE;
        assert(expected == claimable, 'Wrong claimable');

        // withdraw VALUE from offseter 
        assert(erc3525.value_of(token_id) == 0, 'Wrong value of token_id');
        farmer.withdraw_to_token(token_id, VALUE);

        // balance should be egal to value deposited
        assert(VALUE == erc3525.value_of(token_id), 'Wrong balance');
        assert(0 == farmer.get_deposited_of(signers.anyone), 'Wrong deposited');
    }

    #[test]
    #[available_gas(4000_000_000)]
    fn deposit_and_withdraw_value_in_offseter_multiple_user() {
        let (signers, contracts) = setup();
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.offseter };
        let offseter = IOffsetDispatcher { contract_address: contracts.offseter };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
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
                    erc721.set_approval_for_all(contracts.offseter, true);
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
                    let claimable = offseter.get_claimable_of(*user);
                    assert(claimable != 0, 'Wrong claimable');
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let expected = (VALUE * i * current_abs.into()) / PROJECT_VALUE;
                    assert(claimable == expected, 'Wrong claimable');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // withdraw VALUE from offseter for users

        // At t = Three month after 6th absorption time
        set_block_timestamp(*times.at(5) + 3 * ONE_MONTH);

        let mut users = signers.users.span();
        let mut i = 1;
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    set_contract_address(*user);
                    farmer.withdraw_to_token(i, VALUE * i);
                    let claimable = offseter.get_claimable_of(*user);
                    assert(claimable != 0, 'Wrong claimable');
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let expected = (VALUE * i * current_abs.into()) / PROJECT_VALUE;
                    let claimed = offseter.get_claimed_of(*user);
                    assert(claimed == 0, 'Wrong claimed');
                    assert(claimable == expected, 'Wrong claimable');

                    // Claim
                    offseter.claim_all();
                    let claimed = offseter.get_claimed_of(*user);
                    let claimable = offseter.get_claimable_of(*user);
                    assert(claimable == 0, 'Wrong claimable');
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
    fn deposit_and_withdraw_portion_value_in_offseter() {
        let (signers, contracts) = setup();
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.offseter };
        let offseter = IOffsetDispatcher { contract_address: contracts.offseter };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };

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
        set_block_timestamp(1693551600);

        // Then `get_claimable_of` should be different from 0
        let claimable = offseter.get_claimable_of(signers.anyone);
        let current_abs = absorber.get_current_absorption(SLOT);
        let expected = ((VALUE / 2) * current_abs.into()) / PROJECT_VALUE;
        let claimed = offseter.get_claimed_of(signers.anyone);
        assert(claimed == 0, 'Wrong claimed');
        assert(claimable == expected, 'Wrong claimable');

        // withdraw VALUE from offseter 
        assert(erc3525.value_of(token_id) == VALUE / 2, 'Wrong value of token_id');
        farmer.withdraw_to_token(token_id, VALUE / 2);
        // balance should be egal to value deposited
        assert(VALUE == erc3525.value_of(token_id), 'Wrong balance');

        // Check claimed offset balances
        let claimable = offseter.get_claimable_of(signers.anyone);
        let current_abs = absorber.get_current_absorption(SLOT);
        let expected = ((VALUE / 2) * current_abs.into()) / PROJECT_VALUE;
        let claimed = offseter.get_claimed_of(signers.anyone);
        assert(claimed == 0, 'Wrong claimed');
        assert(claimable == expected, 'Wrong claimable');
    }

    #[test]
    #[available_gas(4000_000_000)]
    fn deposit_and_withdraw_value_in_offseter_multiple_user_diff_order() {
        let (signers, contracts) = setup();
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.offseter };
        let offseter = IOffsetDispatcher { contract_address: contracts.offseter };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };
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
                    erc721.set_approval_for_all(contracts.offseter, true);
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
                        .into() % (6 * 31 * 24 * 60 * 60);
                    let rnd: u64 = rnd.try_into().unwrap();
                    set_block_timestamp(*times.at(i - 1) + rnd - 3 * 31 * 24 * 60 * 60);
                    let previous_abs = absorber.get_current_absorption(SLOT);

                    set_block_timestamp(*times.at(9) + 31 * 24 * 60 * 60);
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let abs = current_abs - previous_abs;
                    let expected = (VALUE * i.into() * abs.into()) / PROJECT_VALUE;

                    let claimable = offseter.get_claimable_of(*user);
                    assert(claimable == expected, 'Wrong claimable');
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
                        .into() % (6 * 31 * 24 * 60 * 60);
                    let rnd: u64 = rnd.try_into().unwrap();
                    // Go back to deposit time
                    set_block_timestamp(*times.at(i - 1) + rnd - 3 * 31 * 24 * 60 * 60);
                    let previous_abs = absorber.get_current_absorption(SLOT);

                    // At t = Three month after 12th absorption time
                    set_block_timestamp(*times.at(11) + 3 * ONE_MONTH);
                    set_contract_address(*user);
                    farmer.withdraw_to_token(i.into(), VALUE * i.into());
                    let claimable = offseter.get_claimable_of(*user);
                    assert(claimable != 0, 'Wrong claimable');
                    let current_abs = absorber.get_current_absorption(SLOT);
                    let abs = current_abs - previous_abs;
                    let expected = (VALUE * i.into() * abs.into()) / PROJECT_VALUE;
                    let claimed = offseter.get_claimed_of(*user);

                    assert(claimed == 0, 'Wrong claimed');
                    assert(claimable == expected, 'Wrong claimable');

                    // Claim
                    offseter.claim(claimable);
                    let claimed = offseter.get_claimed_of(*user);
                    let claimable = offseter.get_claimable_of(*user);
                    assert(claimable == 0, 'Wrong claimable');
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
    use carbon::components::farm::interface::{IFarmDispatcher, IFarmDispatcherTrait};
    use carbon::components::offset::interface::{IOffsetDispatcher, IOffsetDispatcherTrait};
    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };
    use carbon::tests::data;
    use super::setup;
    use super::{SLOT, VALUE, PROJECT_VALUE, ONE_MONTH, ONE_DAY, TON_EQUIVALENT};


    #[test]
    #[available_gas(400_000_000_000)]
    fn get_absorption_of_vs_get_claimable_of() {
        let (signers, contracts) = setup();
        // Instantiate contracts
        let farmer = IFarmDispatcher { contract_address: contracts.offseter };
        let offseter = IOffsetDispatcher { contract_address: contracts.offseter };
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let erc3525 = IERC3525Dispatcher { contract_address: contracts.project };

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

        // At t = 0
        set_block_timestamp(0);
        // Anyone deposits value 100_000_000 in offseter
        farmer.deposit(one, VALUE);
        let deposited = farmer.get_deposited_of(signers.anyone);
        assert(deposited == VALUE, 'Wrong deposited value');

        let mut time = *times.at(0);
        loop {
            if time > *times.at(times.len() - 1) {
                break ();
            }
            set_block_timestamp(time);

            let claimable = offseter.get_claimable_of(signers.anyone);
            let user_abs = farmer.get_absorption_of(signers.anyone);
            let current_abs = absorber.get_current_absorption(SLOT);
            let expected_abs = (VALUE * current_abs.into()) / PROJECT_VALUE;
            assert(expected_abs == claimable, 'expected != claimable');
            assert(expected_abs == user_abs, 'expected != user_abs');

            time += 2 * ONE_MONTH + 11 * ONE_DAY;
        }
    }
}
