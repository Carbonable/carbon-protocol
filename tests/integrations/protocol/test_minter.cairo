// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Local dependencies
from tests.integrations.protocol.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
)

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Given a deployed user contracts
    // And an admin with address 1000
    // And an anyone with address 1001
    // Given a deployed project contact
    // And owned by admin
    // Given a deployed payment token contact
    // And owned by admin
    // And a total supply set to 1,000,000
    // And anyone owns the whole supply
    // Given a deployed minter contact
    // And owned by admin
    // And a whitelist sale open
    // And a public sale close
    // And a max buy per tx set to 5
    // And an unit price set to 10
    // And a max supply set to 10
    // And a reserved supply set to 4
    // Given a whitelist merkle tree
    // And an allocation of 5 whitelist slots to anyone
    return setup();
}

@view
func test_whitelisted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When anyone approves minter for 5 token equivalent nfts
    // And anyone makes 5 whitelist buy
    // And admin open the public sale
    // And anyone approves minter for 1 token equivalent nft
    // And anyone makes 1 public buy
    // And admin withdraw minter contract balance
    // Then no failed transactions expected

    anyone.approve(quantity=5);
    anyone.whitelist_buy(quantity=5);
    admin.set_public_sale_open(TRUE);
    anyone.approve(quantity=1);
    anyone.public_buy(quantity=1);
    admin.withdraw();

    return ();
}

@view
func test_not_whitelisted{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When admin set up a new whitelist merkle tree excluding anyone
    // And anyone approves minter for 1 token equivalent nft
    // And anyone makes 1 whitelist buy
    // Then 'caller address is not whitelisted' failed transaction happens

    admin.set_whitelist_merkle_root(123);
    anyone.approve(quantity=1);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: caller address is not whitelisted") %}
    anyone.whitelist_buy(quantity=1);

    return ();
}

@view
func test_airdrop{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When anyone approves minter for 5 token equivalent nfts
    // And anyone makes 5 whitelist buy
    // And admin open the public sale
    // And anyone approves minter for 2 token equivalent nfts
    // And admin airdrops 3 nfts to anyone
    // And admin decreases reserved supply by 1
    // And anyone makes 1 public buy
    // And admin withdraw minter contract balance
    // Then no failed transactions expected
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    anyone.approve(quantity=5);
    anyone.whitelist_buy(quantity=5);
    admin.set_public_sale_open(TRUE);
    admin.airdrop(to=anyone_address, quantity=3);
    admin.decrease_reserved_supply_for_mint(slots=1);
    anyone.approve(quantity=1);
    anyone.public_buy(quantity=1);
    admin.withdraw();

    return ();
}

@view
func test_public_buy_not_enough_available_nfts{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone approves minter for 5 token equivalent nfts
    // And anyone makes 5 whitelist buy
    // And admin open the public sale
    // And anyone approves minter for 2 token equivalent nfts
    // And anyone makes 2 public buy
    // Then 'not enough available NFTs' failed transaction happens
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    anyone.approve(quantity=5);
    anyone.whitelist_buy(quantity=5);
    admin.set_public_sale_open(TRUE);
    anyone.approve(quantity=2);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    anyone.public_buy(quantity=2);

    return ();
}

@view
func test_airdrop_not_enough_available_reserved_nfts{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone approves minter for 5 token equivalent nfts
    // And anyone makes 5 whitelist buy
    // And admin open the public sale
    // And anyone approves minter for 2 token equivalent nfts
    // And admin airdrops 5 nfts to anyone
    // Then 'not enough available reserved NFTs' failed transaction happens
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    anyone.approve(quantity=5);
    anyone.whitelist_buy(quantity=5);
    admin.set_public_sale_open(TRUE);
    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available reserved NFTs") %}
    admin.airdrop(to=anyone_address, quantity=5);

    return ();
}

@view
func test_over_airdropped{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When admin airdrops 11 nfts to anyone
    // Then 'not enough available NFTs' failed transaction happens
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    %{ expect_revert("TRANSACTION_FAILED", "CarbonableMinter: not enough available NFTs") %}
    admin.airdrop(to=anyone_address, quantity=11);

    return ();
}

@view
func test_revert_set_public_sale_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone closes the public sale
    // Then 'caller is not the owner' failed transaction happens
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_public_sale_open(FALSE);

    return ();
}

@view
func test_revert_set_max_buy_per_tx_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone set the max buy per tx
    // Then 'caller is not the owner' failed transaction happens
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_max_buy_per_tx(3);

    return ();
}

@view
func test_revert_set_unit_price_not_owner{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    // When anyone set the unit price
    // Then 'caller is not the owner' failed transaction happens
    alloc_locals;

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.set_unit_price(2);

    return ();
}
