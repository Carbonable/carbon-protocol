# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Local dependencies
from tests.integrations.badge.library import (
    setup,
    admin_instance as admin,
    anyone_instance as anyone,
)

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Given a deployed user contracts
    # And an admin with address 1000
    # And an anyone with address 1001
    # Given a deployed badge contact
    # And an uri set to 'ipfs://carbonable/{id}.json'
    # And a name set to 'Badge'
    # And owned by admin
    return setup()
end

@view
func test_mint_not_owner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # When anyone mints a token to anyone
    # Then a failed transactions expected
    alloc_locals
    let (anyone_address) = anyone.get_address()

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    anyone.mint(to=anyone_address, id=0, amount=1)
    return ()
end
