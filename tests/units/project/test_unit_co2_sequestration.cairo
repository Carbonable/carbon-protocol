# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_minter.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

from cairopen.string.ASCII import StringCodec

from tests.units.project.library import setup, prepare, CarbonableProject
from tests.library import assert_string

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_unit_co2_sequestration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare project instance
    let (local context) = prepare()

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let ss = '0.5004'
    let (str) = StringCodec.ss_to_string(ss)

    CarbonableProject.set_unit_co2_sequestration(
        unit_co2_sequestration_len=str.len, unit_co2_sequestration=str.data
    )

    let (len, array) = CarbonableProject.unit_co2_sequestration()
    let (returned_str) = StringCodec.ss_arr_to_string(len, array)

    assert_string(returned_str, str)
    %{ stop() %}

    return ()
end
