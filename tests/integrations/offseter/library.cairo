// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.token.erc20.IERC20 import IERC20
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from interfaces.offseter import ICarbonableOffseter
from interfaces.project import ICarbonableProject

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/offseter/config.yml", context)

        # Admin account deployment
        context.admin_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.admin,
            },
        ).contract_address

        # Anyone account deployment
        context.anyone_account_contract = deploy_contract(
            contract=context.sources.account,
            constructor_args={
                "public_key": context.signers.anyone,
            },
        ).contract_address

        # Carbonable project deployment
        context.carbonable_project_class_hash = declare(contract=context.sources.project).class_hash
        calldata = {
            "name": context.project.name,
            "symbol": context.project.symbol,
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
        }
        context.carbonable_project_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_project_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address

        # Carbonable offseter deployment
        context.carbonable_offseter_class_hash = declare(contract=context.sources.offseter).class_hash
        calldata = {
            "carbonable_project_address": context.carbonable_project_contract,
            "owner": context.admin_account_contract,
            "proxy_admin": context.admin_account_contract,
        }
        context.carbonable_offseter_contract = deploy_contract(
            contract=context.sources.proxy,
            constructor_args={
                "implementation_hash": context.carbonable_offseter_class_hash,
                "selector": context.selector.initializer,
                "calldata": calldata.values(),
            }
        ).contract_address
    %}

    // Mint 2 tokens to admin and 3 tokens to anyone
    let (local admin_address) = admin_instance.get_address();
    let (local anyone_address) = anyone_instance.get_address();

    admin_instance.set_minter(admin_address);

    admin_instance.mint(to=admin_address, token_id=1);
    admin_instance.mint(to=admin_address, token_id=2);
    admin_instance.mint(to=anyone_address, token_id=3);
    admin_instance.mint(to=anyone_address, token_id=4);
    admin_instance.mint(to=anyone_address, token_id=5);
    return ();
}

namespace carbonable_project_instance {
    // Internals

    func deployed() -> (carbonable_project_contract: felt) {
        tempvar carbonable_project_contract;
        %{ ids.carbonable_project_contract = context.carbonable_project_contract %}
        return (carbonable_project_contract,);
    }

    // Views

    func owner{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (owner: felt) {
        let (owner: felt) = ICarbonableProject.owner(carbonable_project);
        return (owner,);
    }

    func balanceOf{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(owner: felt) -> (balance: Uint256) {
        let (balance) = IERC721.balanceOf(carbonable_project, owner);
        return (balance,);
    }

    func ownerOf{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(tokenId: Uint256) -> (owner: felt) {
        let (owner) = IERC721.ownerOf(carbonable_project, tokenId);
        return (owner,);
    }

    func totalSupply{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (totalSupply: Uint256) {
        let (total_supply) = IERC721Enumerable.totalSupply(carbonable_project);
        return (total_supply,);
    }

    // Externals

    func set_minter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(minter: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_minter(carbonable_project, minter);
        %{ stop_prank() %}
        return ();
    }

    func approve{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(approved: felt, token_id: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        IERC721.approve(carbonable_project, approved, token_id);
        %{ stop_prank() %}
        return ();
    }

    func mint{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(to: felt, token_id: Uint256, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.mint(carbonable_project, to, token_id);
        %{ stop_prank() %}
        return ();
    }
}

namespace carbonable_offseter_instance {
    // Internals

    func deployed() -> (carbonable_offseter_contract: felt) {
        tempvar carbonable_offseter_contract;
        %{ ids.carbonable_offseter_contract = context.carbonable_offseter_contract %}
        return (carbonable_offseter_contract=carbonable_offseter_contract,);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (carbonable_project_address: felt) {
        let (carbonable_project_address) = ICarbonableOffseter.carbonable_project_address(
            carbonable_offseter
        );
        return (carbonable_project_address=carbonable_project_address,);
    }

    func is_locked{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (status: felt) {
        let (status) = ICarbonableOffseter.is_locked(carbonable_offseter);
        return (status=status,);
    }

    func total_locked{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }() -> (balance: Uint256) {
        let (balance) = ICarbonableOffseter.total_locked(carbonable_offseter);
        return (balance=balance,);
    }

    func balance_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(address: felt) -> (balance: felt) {
        let (balance) = ICarbonableOffseter.balance_of(carbonable_offseter, address);
        return (balance=balance,);
    }

    func registred_owner_of{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256) -> (address: felt) {
        let (address) = ICarbonableOffseter.registred_owner_of(carbonable_offseter, token_id);
        return (address=address,);
    }

    // Externals

    func start_period{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(unlocked_duration: felt, period_duration: felt, caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.start_period(
            carbonable_offseter, unlocked_duration, period_duration
        );
        %{ stop_prank() %}
        return (success=success,);
    }

    func stop_period{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(caller: felt) -> (success: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        let (success) = ICarbonableOffseter.stop_period(carbonable_offseter);
        %{ stop_prank() %}
        return (success=success,);
    }

    func deposit{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256, caller: felt, carbonable_project: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_offseter, target_contract_address=ids.carbonable_project) %}
        let (success) = ICarbonableOffseter.deposit(carbonable_offseter, token_id);
        %{ stop_prank_offseter() %}
        %{ stop_prank_project() %}
        return (success=success,);
    }

    func withdraw{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_offseter: felt
    }(token_id: Uint256, caller: felt, carbonable_project: felt) -> (success: felt) {
        %{ stop_prank_offseter = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_offseter) %}
        %{ stop_prank_project = start_prank(caller_address=ids.carbonable_offseter, target_contract_address=ids.carbonable_project) %}
        let (success) = ICarbonableOffseter.withdraw(carbonable_offseter, token_id);
        %{ stop_prank_offseter() %}
        %{ stop_prank_project() %}
        return (success=success,);
    }
}

namespace admin_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar admin;
        %{ ids.admin = context.admin_account_contract %}
        return (admin,);
    }

    // Views

    func owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (owner: felt) {
        let (carbonable_project) = carbonable_project_instance.deployed();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
        }
        return (owner=owner,);
    }

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (
                carbonable_project_address
            ) = carbonable_offseter_instance.carbonable_project_address();
        }
        return (carbonable_project_address=carbonable_project_address,);
    }

    func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (status) = carbonable_offseter_instance.is_locked();
        }
        return (status=status,);
    }

    func total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        balance: Uint256
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.total_locked();
        }
        return (balance=balance,);
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (balance: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.balance_of(address=address);
        }
        return (balance=balance,);
    }

    func registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_offseter {
            let (address) = carbonable_offseter_instance.registred_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address,);
    }

    // Externals

    func set_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(minter: felt) {
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        with carbonable_project {
            carbonable_project_instance.set_minter(minter=minter, caller=caller);
        }
        return ();
    }

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.approve(
                approved=approved, token_id=token_id_uint256, caller=caller
            );
        }
        return ();
    }

    func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        to: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.mint(to=to, token_id=token_id_uint256, caller=caller);
        }
        return ();
    }

    func start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.start_period(
                unlocked_duration=unlocked_duration, period_duration=period_duration, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    func stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.stop_period(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(token_id: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.deposit(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        return ();
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(token_id: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.withdraw(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }
}

namespace anyone_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar anyone;
        %{ ids.anyone = context.anyone_account_contract %}
        return (anyone,);
    }

    // Views

    func carbonable_project_address{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
    }() -> (carbonable_project_address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (
                carbonable_project_address
            ) = carbonable_offseter_instance.carbonable_project_address();
        }
        return (carbonable_project_address=carbonable_project_address,);
    }

    func is_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        status: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (status) = carbonable_offseter_instance.is_locked();
        }
        return (status=status,);
    }

    func total_locked{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        balance: Uint256
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.total_locked();
        }
        return (balance=balance,);
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        address: felt
    ) -> (balance: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        with carbonable_offseter {
            let (balance) = carbonable_offseter_instance.balance_of(address=address);
        }
        return (balance=balance,);
    }

    func registred_owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: felt
    ) -> (address: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_offseter {
            let (address) = carbonable_offseter_instance.registred_owner_of(
                token_id=token_id_uint256
            );
        }
        return (address=address,);
    }

    // Externals

    func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        approved: felt, token_id: felt
    ) {
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            carbonable_project_instance.approve(
                approved=approved, token_id=token_id_uint256, caller=caller
            );
        }
        return ();
    }

    func start_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        unlocked_duration: felt, period_duration: felt
    ) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.start_period(
                unlocked_duration=unlocked_duration, period_duration=period_duration, caller=caller
            );
            assert success = TRUE;
        }
        return ();
    }

    func stop_period{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (caller) = get_address();
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.stop_period(caller=caller);
            assert success = TRUE;
        }
        return ();
    }

    func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(token_id: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.deposit(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        return ();
    }

    func withdraw{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(token_id: felt) {
        let (carbonable_offseter) = carbonable_offseter_instance.deployed();
        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = get_address();
        let token_id_uint256 = Uint256(low=token_id, high=0);
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = carbonable_offseter;
        }
        with carbonable_offseter {
            let (success) = carbonable_offseter_instance.withdraw(
                token_id=token_id_uint256, caller=caller, carbonable_project=carbonable_project
            );
            assert success = TRUE;
        }
        with carbonable_project {
            let (owner) = carbonable_project_instance.ownerOf(tokenId=token_id_uint256);
            assert owner = caller;
        }
        return ();
    }
}
