# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from tests.integrations.minter.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
)

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (local whitelist_merkle_proof : felt*) = alloc()
    assert [whitelist_merkle_proof] = 1489335374474017495857579265074565262713421005832572026644103123081435719307
    let whitelist_merkle_proof_len = 1
    setup(
        # User addresses
        admin_address=1000,
        anyone_address=1001,
        # CarbonableProjectNFT
        nft_name='Carbonable ERC-721 Test',
        nft_symbol='CET',
        # Payment token
        token_name='StableCoinToken',
        token_symbol='SCT',
        token_decimals=6,
        token_initial_supply=1000000,
        # CarbonableMint
        minter_public_sale_open=FALSE,
        minter_max_buy_per_tx=5,
        minter_unit_price=10,
        minter_max_supply_for_mint=10,
        minter_reserved_supply_for_mint=4,
        # Whitelist ANYONE
        whitelist_slots=5,
        whitelist_merkle_root=3236969588476960619958150604131083087415975923122021901088942336874683133579,
        whitelist_merkle_proof=whitelist_merkle_proof,
        whitelist_merkle_proof_len=whitelist_merkle_proof_len,
    )
    return ()
end

@view
func test_e2e_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    # User: ANYONE
    # - wants to buy 6 NFTs (5 whitelist, 1 public)
    # - whitelisted: TRUE
    # - has enough funds: YES
    let (anyone_address) = anyone.get_address()

    anyone.approve(quantity=5)
    anyone.whitelist_buy(quantity=5)
    admin.set_public_sale_open(TRUE)
    anyone.approve(quantity=1)
    anyone.public_buy(quantity=1)
    admin.withdraw()

    return ()
end

@view
func test_e2e_not_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # STORY
    # ---
    # User: ANYONE
    # - wants to buy 6 NFTs (1 whitelist, 5 public)
    # - whitelisted: FALSE
    # - has enough funds: YES

    admin.set_whitelist_merkle_root(123)
    anyone.approve(quantity=1)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: caller address is not whitelisted") %}
    anyone.whitelist_buy(quantity=1)
    admin.set_public_sale_open(TRUE)
    anyone.approve(quantity=5)
    anyone.public_buy(quantity=5)
    admin.withdraw()

    return ()
end

@view
func test_e2e_airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: ANYONE
    # - wants to buy 6 NFTs (5 whitelist, 2 public)
    # - whitelisted: TRUE
    # - has enough funds: YES
    # User: ADMIN
    # - aidrop 5 nft to ANYONE
    # - aidrop 3 nft to ANYONE
    # - decrease reserved supply by one
    # User: ADMIN
    # - wants to buy 2 NFTs (2 public)
    alloc_locals
    let (anyone_address) = anyone.get_address()

    anyone.approve(quantity=5)
    anyone.whitelist_buy(quantity=5)
    admin.set_public_sale_open(TRUE)
    anyone.approve(quantity=2)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    anyone.public_buy(quantity=2)
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved NFTs") %}
    admin.airdrop(to=anyone_address, quantity=5)
    admin.airdrop(to=anyone_address, quantity=3)
    admin.decrease_reserved_supply_for_mint(slots=1)
    anyone.public_buy(quantity=1)
    admin.withdraw()

    return ()
end

@view
func test_e2e_over_airdrop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # User: ANYONE
    # - wants to buy 1 NFT1 (1 whitelist)
    # - whitelisted: TRUE
    # - has enough funds: YES
    # User: ADMIN
    # - aidrop 11 nft to ANYONE
    alloc_locals
    let (anyone_address) = anyone.get_address()
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    admin.airdrop(to=anyone_address, quantity=11)

    return ()
end
