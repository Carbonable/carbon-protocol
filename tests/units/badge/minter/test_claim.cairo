%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

from src.interfaces.badgeMinter import ICarbonableBadgeMinter

@external
func test_claim{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr : SignatureBuiltin*
}() {
    alloc_locals;

    local minter_contract_address: felt;
    local logic_class: felt;
    let public_key = 0x07c42ac1a6415ba91ce25cca6ea3ffcf8201151a722e6a07fe2f73e931f221c6;
    let contract_owner = 0x4;

    // Deploy the minter contract
    %{
        from starkware.starknet.compiler.compile import get_selector_from_name
        ids.logic_class = declare("src/badge/minter.cairo").class_hash
        ids.minter_contract_address = deploy_contract("openzeppelin/upgrades/presets/Proxy.cairo", [ids.logic_class, get_selector_from_name("initializer"), 3, ids.contract_owner, ids.public_key, 0]).contract_address
    %}

    local badge_contract_address: felt;
    // Deploy the badge contract
    %{
        ids.badge_contract_address = deploy_contract("src/badge/badge.cairo", [1, 1, 1, ids.minter_contract_address]).contract_address
    %}

    %{ stop_prank_callable = start_prank(ids.contract_owner, target_contract_address=ids.minter_contract_address) %}

    // Set the badge contract address in the minter contract
    ICarbonableBadgeMinter.setBadgeContractAddress(minter_contract_address, badge_contract_address);

    let badge_type = 0;
    // Generated signature for the pedersen hash of the user address badge type, with the private key associated to the public key set in the initializer
    let sig = (1446613889061454488684584816134311028150072838391055356173753342137386273038,550323174704161837982944959231864662796077128280001789888940955956125828334);

    // Claim the badge
    ICarbonableBadgeMinter.claim(minter_contract_address, sig, badge_type);
    
    %{ stop_prank_callable() %}

    return ();
}