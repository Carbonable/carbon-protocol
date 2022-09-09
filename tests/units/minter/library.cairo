# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

# Local dependencies
from src.mint.library import CarbonableMinter

#
# Structs
#

struct Signers:
    member admin : felt
    member anyone : felt
end

struct Mocks:
    member carbonable_project_address : felt
    member payment_token_address : felt
end

struct Whitelist:
    member slots : felt
    member merkle_root : felt
    member merkle_proof : felt*
    member merkle_proof_len : felt
end

struct TestContext:
    member signers : Signers
    member mocks : Mocks
    member whitelist : Whitelist
end

#
# Functions
#

func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/units/minter/config.yml", context)
    %}

    return ()
end

func prepare{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    public_sale_open : felt,
    max_buy_per_tx : felt,
    unit_price : Uint256,
    max_supply_for_mint : Uint256,
    reserved_supply_for_mint : Uint256,
) -> (test_context : TestContext):
    alloc_locals

    # Extract context variables
    local admin
    local anyone
    local carbonable_project_address
    local payment_token_address
    local slots
    local merkle_root
    local merkle_proof_len
    let (local merkle_proof : felt*) = alloc()
    %{
        ids.admin = context.signers.admin
        ids.anyone = context.signers.anyone
        ids.carbonable_project_address = context.mocks.carbonable_project_address
        ids.payment_token_address = context.mocks.payment_token_address
        ids.slots = context.whitelist.slots
        ids.merkle_root = context.whitelist.merkle_root
        ids.merkle_proof_len = context.whitelist.merkle_proof_len
        for index, node in enumerate(context.whitelist.merkle_proof):
            memory[ids.merkle_proof + index] = node
    %}

    # Instantiate minter
    CarbonableMinter.constructor(
        owner=admin,
        carbonable_project_address=carbonable_project_address,
        payment_token_address=payment_token_address,
        public_sale_open=public_sale_open,
        max_buy_per_tx=max_buy_per_tx,
        unit_price=unit_price,
        max_supply_for_mint=max_supply_for_mint,
        reserved_supply_for_mint=reserved_supply_for_mint,
    )

    # Instantiate context, useful to avoid many hints in tests
    local signers : Signers = Signers(admin=admin, anyone=anyone)

    local mocks : Mocks = Mocks(
        carbonable_project_address=carbonable_project_address,
        payment_token_address=payment_token_address,
        )

    local whitelist : Whitelist = Whitelist(
        slots=slots,
        merkle_root=merkle_root,
        merkle_proof=merkle_proof,
        merkle_proof_len=merkle_proof_len,
        )

    local context : TestContext = TestContext(signers=signers, mocks=mocks, whitelist=whitelist)

    return (context)
end
