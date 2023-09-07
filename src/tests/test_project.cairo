#[cfg(test)]
mod Test {
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
    use openzeppelin::token::erc721::interface::{IERC721Dispatcher, IERC721DispatcherTrait};
    use cairo_erc_3525::presets::erc3525_mintable_burnable::{
        IExternalDispatcher as IERC3525Dispatcher,
        IExternalDispatcherTrait as IERC3525DispatcherTrait
    };

    // Components

    use carbon::components::absorber::interface::{IAbsorberDispatcher, IAbsorberDispatcherTrait};
    use carbon::components::access::interface::{ICertifierDispatcher, ICertifierDispatcherTrait};
    use carbon::components::access::interface::{IMinterDispatcher, IMinterDispatcherTrait};

    // Contracts

    use carbon::contracts::project::{
        Project, IExternalDispatcher as IProjectDispatcher,
        IExternalDispatcherTrait as IProjectDispatcherTrait
    };

    // Constants

    const NAME: felt252 = 'NAME';
    const SYMBOL: felt252 = 'SYMBOL';
    const DECIMALS: u8 = 6;
    const SLOT: u256 = 1;
    const TOKEN_ID: u256 = 1;
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

    fn setup() -> (Signers, Contracts) {
        // Deploy
        let signers = Signers { owner: deploy_account('OWNER'), anyone: deploy_account('ANYONE'), };
        let project = deploy_project(signers.owner);

        // Setup
        setup_project(project, @signers);

        // Stop prank
        set_contract_address(starknet::contract_address_const::<'NO-ONE'>());

        // Return
        let contracts = Contracts { project: project, };
        (signers, contracts)
    }

    #[test]
    #[available_gas(6_000_000)]
    fn test_project_nominal_case_minter() {
        // [Setup]
        let (signers, contracts) = setup();
        let minter = IMinterDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Assert] Provide minter rights to anyone
        set_contract_address(signers.owner);
        minter.add_minter(SLOT, signers.anyone);
        assert(minter.get_minters(SLOT) == array![signers.anyone].span(), 'Wrong minters');

        // [Assert] Mint
        set_contract_address(signers.anyone);
        project.mint(signers.anyone, SLOT, VALUE);
    }

    #[test]
    #[available_gas(8_000_000)]
    fn test_project_nominal_case_certifier() {
        // [Setup]
        let (signers, contracts) = setup();
        let certifier = ICertifierDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };

        // [Assert] Provide certifier rights to anyone
        set_contract_address(signers.owner);
        certifier.set_certifier(SLOT, signers.anyone);
        assert(certifier.get_certifier(SLOT) == signers.anyone, 'Wrong certifier');

        // [Assert] Set absorptions
        set_contract_address(signers.anyone);
        let absorptions = array![1, 2, 3].span();
        let times = array![1, 2, 3].span();
        absorber.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
        assert(absorber.get_times(SLOT) == times, 'Wrong times');
        assert(absorber.get_absorptions(SLOT) == absorptions, 'Wrong absorptions');
        assert(absorber.get_ton_equivalent(SLOT) == TON_EQUIVALENT, 'Wrong ton equivalent');
    }

    #[test]
    #[available_gas(16_000_000)]
    fn test_project_reset_absorptions() {
        // [Setup]
        let (signers, contracts) = setup();
        let certifier = ICertifierDispatcher { contract_address: contracts.project };
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };

        // [Assert] Provide certifier rights to anyone
        set_contract_address(signers.owner);
        certifier.set_certifier(SLOT, signers.anyone);
        assert(certifier.get_certifier(SLOT) == signers.anyone, 'Wrong certifier');

        // [Assert] Set absorptions
        set_contract_address(signers.anyone);
        let absorptions = array![1, 2, 3].span();
        let times = array![1, 2, 3].span();
        absorber.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
        assert(absorber.get_times(SLOT) == times, 'Wrong times');
        assert(absorber.get_absorptions(SLOT) == absorptions, 'Wrong absorptions');
        assert(absorber.get_ton_equivalent(SLOT) == TON_EQUIVALENT, 'Wrong ton equivalent');

        // [Assert] Reset absorptions
        let absorptions = array![4].span();
        let times = array![4].span();
        absorber.set_absorptions(SLOT, times, absorptions, TON_EQUIVALENT);
        assert(absorber.get_times(SLOT) == times, 'Wrong times');
        assert(absorber.get_absorptions(SLOT) == absorptions, 'Wrong absorptions');
        assert(absorber.get_ton_equivalent(SLOT) == TON_EQUIVALENT, 'Wrong ton equivalent');
    }

    #[test]
    #[available_gas(5_000_000)]
    #[should_panic] // Caller is missing role
    fn test_project_mint_revert_not_minter() {
        // [Setup]
        let (signers, contracts) = setup();
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Revert] Mint
        project.mint(signers.anyone, SLOT, VALUE);
    }

    #[test]
    #[available_gas(4_000_000)]
    #[should_panic] // Caller is missing role
    fn test_project_mint_value_revert_not_minter() {
        // [Setup]
        let (signers, contracts) = setup();
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Revert] Mint value
        project.mint_value(TOKEN_ID, VALUE);
    }

    #[test]
    #[available_gas(4_000_000)]
    #[should_panic] // Caller is missing role
    fn test_project_set_absorptions_revert_not_certifier() {
        // [Setup]
        let (signers, contracts) = setup();
        let absorber = IAbsorberDispatcher { contract_address: contracts.project };
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Revert] Set absorptions
        absorber
            .set_absorptions(SLOT, array![1, 2, 3].span(), array![1, 2, 3].span(), TON_EQUIVALENT);
    }

    #[test]
    #[available_gas(4_000_000)]
    #[should_panic] // Caller is not the owner
    fn test_project_set_token_uri_revert_not_owner() {
        // [Setup]
        let (signers, contracts) = setup();
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Revert] Set token uri
        project.set_token_uri(TOKEN_ID, 'URI');
    }

    #[test]
    #[available_gas(4_000_000)]
    #[should_panic] // Caller is not the owner
    fn test_project_set_contract_uri_revert_not_owner() {
        // [Setup]
        let (signers, contracts) = setup();
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Revert] Set contract uri
        project.set_contract_uri('URI');
    }

    #[test]
    #[available_gas(4_000_000)]
    #[should_panic] // Caller is not the owner
    fn test_project_set_slot_uri_revert_not_owner() {
        // [Setup]
        let (signers, contracts) = setup();
        let project = IProjectDispatcher { contract_address: contracts.project };

        // [Revert] Set slot uri
        project.set_slot_uri(SLOT, 'URI');
    }
}
