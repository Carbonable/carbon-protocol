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

const NAME: felt252 = 'Carbon_Test';
const SYMBOL: felt252 = 'CARBT';
const DECIMALS: u8 = 6;
const SLOT: u256 = 1;
const TON_EQUIVALENT: u64 = 1_000_000;
const PROJECT_VALUE: u256 = 2_139_004_800_000;

const MAX_VALUE_PER_TX: u256 = 0;
const MIN_VALUE_PER_TX: u256 = 1_000_000;
const MAX_VALUE: u256 = 2_139_004_800_000;
const UNIT_PRICE: u256 = 1;
const RESERVED_VALUE: u256 = 0;
const ALLOCATION: felt252 = 0;
const BILLION: u256 = 1_000_000_000_000;

const PRICE: u256 = 22;
const VALUE: u256 = 40_000_000;
const VALUE_USER_2: u256 = 10_000_000;
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
    let enable_max_per_tx: bool = false;
    let mut calldata: Array<felt252> = array![
        project.into(),
        SLOT.low.into(),
        SLOT.high.into(),
        erc20.into(),
        public_sale_open.into(),
        enable_max_per_tx.into(),
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
    let (times, absorptions) = data::get_karathuru();
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

    // Setup prices
    let times: Array<u64> = array![1717581600, 1720605600];
    let prices: Array<u256> = array![price, price];

    let set_price_block_timestamps: u64 = 1717236000;
    set_block_timestamp(set_price_block_timestamps);
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
        users: array![deploy_account('USER1'), deploy_account('USER2')]
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


mod ISOProjectKarathuru {
    use core::array::ArrayTrait;
    use core::traits::Into;
    use core::box::BoxTrait;
    use core::option::OptionTrait;
    use core::array::SpanTrait;
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

    use carbon::tests::scenarios::test_iso_karathuru::setup;
    use carbon::tests::scenarios::test_iso_karathuru::{SLOT, VALUE, VALUE_USER_2, PROJECT_VALUE, PRICE, ONE_MONTH};

    fn max(a: u64, b: u64) -> u64 {
        if a > b {
            a
        } else {
            b
        }
    }


    #[test]
    #[available_gas(4_000_000_000)]
    fn iso_deposit_and_withdraw_value_in_yielder_multiple_user_diff_order() {
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

        let (times, absorptions) = data::get_karathuru();

        // Date : Jul 01 2024 12:00:00, Jul 02 2024 12:00:00
        let depo_block_timestamp: Array<u64> = array![1719828000, 1719914400];
        // Date :  Jul 04 2024 12:00:00, Jul 05 2024 12:00:00
        let withdraw_block_timestamp: Array<u64> = array![1720087200, 1720173600];

        let values: Array<u256> = array![40000000, 10000000];

        // Prank caller as owner
        set_contract_address(signers.owner);

        // Grant minter rights to owner, mint 1 token to anyone and revoke rights
        // 'minting'.print();
        minter.add_minter(SLOT, signers.owner);
        let mut users = signers.users.span();
        let mut sft_values = values.span();
        let mut i = 1;

        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    let token_value: u256 = *sft_values[i - 1];
                    project.mint(*user, SLOT, token_value);
                    assert(erc3525.value_of(i.into()) == token_value, 'Wrong value of user');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        minter.revoke_minter(SLOT, signers.owner);

        // Users deposit value at specific times
        let mut users = signers.users.span();
        let mut i = 1;
        let mut sft_values = values.span();
        loop {
            match users.pop_front() {
                Option::Some(user) => {
                    // 'deposit '.print();
                    set_contract_address(*user);
                    erc721.set_approval_for_all(contracts.yielder, true);
                    set_block_timestamp(*depo_block_timestamp[i - 1]);

                    let token_value: u256 = *sft_values[i - 1];
                    farmer.deposit(i.into(), token_value);
                    let deposited = farmer.get_deposited_of(*user);
                    assert(deposited == token_value, 'Wrong deposit for user');
                    i += 1;
                },
                Option::None => {
                    break ();
                }
            };
        };

        // Users withdraw value at various times
        let mut users = signers.users.span();
        let mut sft_values = values.span();

        // First user withdraws
        let user_2 = signers.users[1];
        let user_1 = signers.users[0];
        set_contract_address(*user_2);
        set_block_timestamp(*withdraw_block_timestamp[0]);

        // let mut deposited :u256 = farmer.get_deposited_of(*user_2);
        // 'user_1 absorption'.print();
        let mut absorption_of: u256 = farmer.get_absorption_of(*user_1);
        // 'absorption_of'.print();
        // absorption_of.print();

        // 'user_2 operation'.print();
        let mut token_value: u256 = *sft_values[1];
        // token_value.print();
        farmer.withdraw_to_token(2, token_value);
        let mut deposited = farmer.get_deposited_of(*user_2);
        assert(deposited == 0, 'Wrong deposit for user');
        assert(erc3525.value_of(2) == token_value, 'Wrong withdraw value of user 2');

        // Control to the second user

        set_contract_address(*user_1);
        set_block_timestamp(*withdraw_block_timestamp[1]);
        absorption_of = farmer.get_absorption_of(*user_1);

        token_value = *sft_values[0];
        farmer.withdraw_to_token(1, token_value);
        deposited = farmer.get_deposited_of(*user_1);

        assert(deposited == 0, 'Wrong deposit for user');
        assert(erc3525.value_of(1) == token_value, 'Wrong withdraw value of user 1');
    }
}
