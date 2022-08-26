# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Local dependencies
from tests.integrations.minter.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
)

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Given a deployed user contracts
    # And an admin with address 1000
    # And an anyone with address 1001
    # Given a deployed project nft contact
    # And owned by admin
    # Given a deployed payment token contact
    # And owned by admin
    # And a total supply set to 1,000,000
    # And anyone owns the whole supply
    # Given a deployed minter contact
    # And owned by admin
    # And a whitelist sale open
    # And a public sale close
    # And a max buy per tx set to 5
    # And an unit price set to 10
    # And a max supply set to 10
    # And a reserved supply set to 4
    # Given a whitelist merkle tree
    # And an allocation of 5 whitelist slots to anyone
    return setup()
end

@view
func test_e2e_whitelisted{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # When anyone approves minter for 5 token equivalent nfts
    # And anyone makes 5 whitelist buy
    # And admin open the public sale
    # And anyone approves minter for 1 token equivalent nft
    # And anyone makes 1 public buy
    # And admin withdraw minter contract balance
    # Then no failed transactions expected

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
    # When admin set up a new whitelist merkle tree excluding anyone
    # And anyone approves minter for 1 token equivalent nft
    # And anyone makes 1 whitelist buy
    # Then 'caller address is not whitelisted' failed transaction happens
    # When admin open the public sale
    # And anyone approves minter for 5 token equivalent nfts
    # And anyone makes 5 public buy
    # And admin withdraw minter contract balance
    # Then no failed transactions expected

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
    # When anyone approves minter for 5 token equivalent nfts
    # And anyone makes 5 whitelist buy
    # And admin open the public sale
    # And anyone approves minter for 2 token equivalent nfts
    # And anyone makes 2 public buy
    # Then 'not enough available NFTs' failed transaction happens
    # When admin airdrops 5 nfts to anyone
    # Then 'not enough available reserved NFTs' failed transaction happens
    # When admin airdrops 3 nfts to anyone
    # And admin decreases reserved supply by 1
    # And anyone makes 1 public buy
    # And admin withdraw minter contract balance
    # Then no failed transactions expected
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
func test_e2e_over_airdropped{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # When admin airdrops 11 nfts to anyone
    # Then 'not enough available NFTs' failed transaction happens
    alloc_locals
    let (anyone_address) = anyone.get_address()

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    admin.airdrop(to=anyone_address, quantity=11)

    return ()
end
