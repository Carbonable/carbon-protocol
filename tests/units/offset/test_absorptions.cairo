// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Local dependencies
from tests.units.offset.library import setup, prepare, CarbonableOffseter

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (absorptions_len, absorptions) = CarbonableOffseter.absorptions();
    assert absorptions_len = context.absorption.values_len;
    assert absorptions[0] = context.absorption.values[0];
    assert absorptions[absorptions_len - 1] = context.absorption.values[absorptions_len - 1];

    let (local new_absorptions: felt*) = alloc();
    assert [new_absorptions + 0] = 1;
    assert [new_absorptions + 1] = 2;
    assert [new_absorptions + 2] = 3;
    assert [new_absorptions + 3] = 4;
    assert [new_absorptions + 4] = 5;
    let new_absorptions_len = 5;
    CarbonableOffseter.set_absorptions(
        absorptions_len=new_absorptions_len, absorptions=new_absorptions
    );

    let (absorptions_len, absorptions) = CarbonableOffseter.absorptions();
    assert absorptions_len = new_absorptions_len;
    assert absorptions[0] = new_absorptions[0];
    assert absorptions[new_absorptions_len - 1] = new_absorptions[new_absorptions_len - 1];

    return ();
}
