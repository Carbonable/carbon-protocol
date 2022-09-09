# SPDX-License-Identifier: MIT
# Carbonable Contracts written in Cairo v0.9.1 (test_minter.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from cairopen.string.ASCII import StringCodec

# Local dependencies
from tests.units.project.library import setup, prepare, CarbonableProject
from tests.library import assert_string

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_total_co2_sequestration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare project instance
    let (local context) = prepare()

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let ss = '3603'
    let (str) = StringCodec.ss_to_string(ss)

    CarbonableProject.set_total_co2_sequestration(
        total_co2_sequestration_len=str.len, total_co2_sequestration=str.data
    )

    let (len, array) = CarbonableProject.total_co2_sequestration()
    let (returned_str) = StringCodec.ss_arr_to_string(len, array)

    assert_string(returned_str, str)
    %{ stop() %}

    return ()
end

@external
func test_total_co2_sequestration_revert_not_owner{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare project instance
    let (local context) = prepare()

    # run scenario
    %{ stop=start_prank(context.signers.anyone) %}

    let ss = '3603'
    let (str) = StringCodec.ss_to_string(ss)

    %{ expect_revert("TRANSACTION_FAILED", "Ownable: caller is not the owner") %}
    CarbonableProject.set_total_co2_sequestration(
        total_co2_sequestration_len=str.len, total_co2_sequestration=str.data
    )

    %{ stop() %}

    return ()
end
