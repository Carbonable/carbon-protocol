# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_withdrawcairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

# Local dependencies
from tests.units.minter.library import setup, prepare, CarbonableMinter

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Given a deployed user contracts
    # And an admin with address 1000
    # And an anyone with address 1001
    # Given a deployed project nft contact
    # Given a deployed payment token contact
    # Given a deployed minter contact
    # And owned by admin
    # And a whitelist sale close
    # And a public sale close
    # And a max buy per tx set to 5
    # And an unit price set to 10
    # And a max supply set to 10
    # And a reserved supply set to 0
    return setup()
end

@external
func test_withdraw_nominal_case{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ):
    # Given a deployed payment token contact
    # And the transfer function succeeds
    # Given a deployed minter contact
    # And a balance of payment token at 5
    # When admin withdraws funds
    # Then no failed transactions expected
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}
    %{ mock_call(context.mocks.payment_token_address, "balanceOf", [5, 0]) %}
    %{ mock_call(context.mocks.payment_token_address, "transfer", [1]) %}
    let (success) = CarbonableMinter.withdraw()
    assert success = TRUE
    %{ stop() %}
    return ()
end

@external
func test_withdraw_revert_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    # When anyone withdraws funds
    # Then 'caller is not the owner' failed transaction happens
    alloc_locals

    # prepare minter instance
    let (local context) = prepare(
        public_sale_open=FALSE,
        max_buy_per_tx=5,
        unit_price=Uint256(10, 0),
        max_supply_for_mint=Uint256(10, 0),
        reserved_supply_for_mint=Uint256(0, 0),
    )

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}
    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableMinter.withdraw()
    %{ stop() %}
    return ()
end
