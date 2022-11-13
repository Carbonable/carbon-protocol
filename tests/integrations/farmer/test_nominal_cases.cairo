// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Local dependencies
from tests.integrations.farmer.library import (
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
    // And with 2 tokens owned by admin
    // And with 3 tokens owned by anyone
    // Given a deployed farmer contract
    // And owned by admin
    return setup();
}

@view
func test_e2e_deposite{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // When anyone approves minter for 5 token equivalent nfts
    // And anyone makes 5 whitelist buy
    // And admin open the public sale
    // And anyone approves minter for 1 token equivalent nft
    // And anyone makes 1 public buy
    // And admin withdraw minter contract balance
    // Then no failed transactions expected
    alloc_locals;
    let (anyone_address) = anyone.get_address();

    admin.start_period(unlocked_duration=5, period_duration=10);
    admin.deposite(token_id=1);
    anyone.deposite(token_id=3);

    let (share) = anyone.share(anyone_address, precision=100);
    assert share = Uint256(low=0, high=0);

    return ();
}
