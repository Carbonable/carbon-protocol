// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.token.erc721.IERC721 import IERC721
from openzeppelin.token.erc721.enumerable.IERC721Enumerable import IERC721Enumerable
from openzeppelin.security.safemath.library import SafeUint256

// Local dependencies
from src.interfaces.project import ICarbonableProject

//
// Functions
//

namespace instance {
    // Internals

    func get_address() -> (carbonable_project_contract: felt) {
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

    func get_start_time{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (start_time: felt) {
        let (start_time) = ICarbonableProject.getStartTime(carbonable_project);
        return (start_time=start_time);
    }

    func get_final_time{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (final_time: felt) {
        let (final_time) = ICarbonableProject.getFinalTime(carbonable_project);
        return (final_time=final_time);
    }

    func get_times{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (times_len: felt, times: felt*) {
        let (times_len, times) = ICarbonableProject.getTimes(carbonable_project);
        return (times_len=times_len, times=times);
    }

    func get_absorptions{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (absorptions_len: felt, absorptions: felt*) {
        let (absorptions_len, absorptions) = ICarbonableProject.getAbsorptions(carbonable_project);
        return (absorptions_len=absorptions_len, absorptions=absorptions);
    }

    func get_absorption{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(time: felt) -> (absorption: felt) {
        let (absorption) = ICarbonableProject.getAbsorption(
            contract_address=carbonable_project, time=time
        );
        return (absorption=absorption);
    }

    func get_current_absorption{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (absorption: felt) {
        let (absorption) = ICarbonableProject.getCurrentAbsorption(
            contract_address=carbonable_project
        );
        return (absorption=absorption);
    }

    func get_final_absorption{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (absorption: felt) {
        let (absorption) = ICarbonableProject.getFinalAbsorption(
            contract_address=carbonable_project
        );
        return (absorption=absorption);
    }

    func get_ton_equivalent{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }() -> (ton_equivalent: felt) {
        let (ton_equivalent) = ICarbonableProject.getTonEquivalent(
            contract_address=carbonable_project
        );
        return (ton_equivalent=ton_equivalent);
    }

    func get_minters{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(caller: felt) -> (minters_len: felt, minters: felt*) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        let (minters_len, minters) = ICarbonableProject.getMinters(carbonable_project);
        %{ stop_prank() %}
        return (minters_len, minters);
    }

    func get_certifier{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(caller: felt) -> (certifier: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        let (certifier) = ICarbonableProject.getCertifier(carbonable_project);
        %{ stop_prank() %}
        return (certifier=certifier);
    }

    // Externals

    func add_minter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(minter: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.addMinter(carbonable_project, minter);
        %{ stop_prank() %}
        return ();
    }

    func revoke_minter{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(minter: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.revokeMinter(carbonable_project, minter);
        %{ stop_prank() %}
        return ();
    }

    func set_certifier{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(certifier: felt, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.setCertifier(carbonable_project, certifier);
        %{ stop_prank() %}
        return ();
    }

    func set_absorptions{
        syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, carbonable_project: felt
    }(
        times_len: felt,
        times: felt*,
        absorptions_len: felt,
        absorptions: felt*,
        ton_equivalent: felt,
        caller: felt,
    ) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.setAbsorptions(
            contract_address=carbonable_project,
            times_len=times_len,
            times=times,
            absorptions_len=absorptions_len,
            absorptions=absorptions,
            ton_equivalent=ton_equivalent,
        );
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
