# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
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
    # GIVEN a deployed user contracts
    #   AND admin with address 1000
    #   AND anyone with address 1001
    # GIVEN a deployed project nft contact
    # GIVEN a deployed payment token contact
    #   AND total supply set to 1,000,000
    #   AND anyone owns the whole supply
    # GIVEN a deployed minter contact
    #   AND whitelist sale open
    #   AND public sale close
    #   AND max buy per tx set to 5
    #   AND unit price set to 10
    #   AND max supply set to 10
    #   AND reserved supply set to 4
    # GIVEN a set up whitelist merkle tree
    #   AND whitelist includes 5 slots to anyone
    return setup()
end

@view
func test_e2e_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # GIVEN setup context
    #  WHEN anyone approves minter for 5 token equivalent nfts
    #   AND anyone makes 5 whitelist buy
    #   AND admin open the public sale
    #   AND anyone approves minter for 1 token equivalent nft
    #   AND anyone makes 1 public buy
    #   AND admin withdraw minter contract balance
    #  THEN no failed transactions expected

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
    # GIVEN setup context
    #  WHEN admin set up a new whitelist merkle tree excluding anyone
    #   AND anyone approves minter for 1 token equivalent nft
    #   AND anyone makes 1 whitelist buy
    #  THEN 'caller address is not whitelisted' failed transaction happens
    #  WHEN admin open the public sale
    #   AND anyone approves minter for 5 token equivalent nfts
    #   AND anyone makes 5 public buy
    #   AND admin withdraw minter contract balance
    #  THEN no failed transactions expected

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
    # GIVEN setup context
    #  WHEN anyone approves minter for 5 token equivalent nfts
    #   AND anyone makes 5 whitelist buy
    #   AND admin open the public sale
    #   AND anyone approves minter for 2 token equivalent nfts
    #   AND anyone makes 2 public buy
    #  THEN 'not enough available NFTs' failed transaction happens
    #  WHEN admin airdrop 5 nfts to anyone
    #  THEN 'not enough available reserved NFTs' failed transaction happens
    #  WHEN admin airdrop 3 nfts to anyone
    #   AND admin decreases reserved supply by 1
    #   AND anyone makes 1 public buy
    #   AND admin withdraw minter contract balance
    #  THEN no failed transactions expected
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
    # GIVEN setup context
    #  WHEN admin airdrop 11 nfts to anyone
    #  THEN 'not enough available NFTs' failed transaction happens
    alloc_locals
    let (anyone_address) = anyone.get_address()

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    admin.airdrop(to=anyone_address, quantity=11)

    return ()
end
