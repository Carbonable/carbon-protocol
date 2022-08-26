# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_minter.cairo)

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
func test_unit_land_surface{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare project instance
    let (local context) = prepare()

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let ss = '100'
    let (str) = StringCodec.ss_to_string(ss)

    CarbonableProject.set_unit_land_surface(
        unit_land_surface_len=str.len, unit_land_surface=str.data
    )

    let (len, array) = CarbonableProject.unit_land_surface()
    let (returned_str) = StringCodec.ss_arr_to_string(len, array)

    assert_string(returned_str, str)
    %{ stop() %}

    return ()
end
