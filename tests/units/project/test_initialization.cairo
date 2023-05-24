// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

// Local dependencies
from tests.units.project.library import setup, prepare, CarbonableProject
from src.utils.metadata.library import CarbonableMetadata

@view
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return setup();
}

@external
func test_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;

    // prepare farmer instance
    let (local context) = prepare();

    let (status) = CarbonableProject.is_setup(slot=context.absorption.slot);
    assert status = TRUE;

    let (times_len, times) = CarbonableProject.times(context.absorption.slot);
    assert times_len = context.absorption.times_len;
    let first_time = times[0];
    assert first_time = context.absorption.times[0];
    let final_time = times[times_len - 1];
    assert final_time = context.absorption.times[times_len - 1];

    let (absorptions_len, absorptions) = CarbonableProject.absorptions(
        slot=context.absorption.slot
    );
    assert absorptions_len = context.absorption.values_len;
    let first_absorption = absorptions[0];
    assert first_absorption = context.absorption.values[0];
    let final_absorption = absorptions[absorptions_len - 1];
    assert final_absorption = context.absorption.values[absorptions_len - 1];

    let (ton_equivalent) = CarbonableProject.ton_equivalent(slot=context.absorption.slot);
    assert ton_equivalent = context.absorption.ton_equivalent;

    let (project_value) = CarbonableProject.project_value(slot=context.absorption.slot);
    assert project_value = Uint256(context.project_value, 0);

    return ();
}

@external
func test_metadata{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() {
    alloc_locals;
    let (local instance) = get_contract_address();
    %{
        mock_call(ids.instance, "symbol", [123])
        mock_call(ids.instance, "valueOf", [69420, 0])
        mock_call(ids.instance, "slotOf", [1337, 0])
        mock_call(ids.instance, "supportsInterface", [1])
    %}
    let (uri_len, local uri: felt*) = CarbonableMetadata.token_uri(Uint256(1, 0));
    %{
        uri_data = [memory[ids.uri + i] for i in range(ids.uri_len)]
        assert uri_data == []
    %}

    let (uri_len, local uri: felt*) = CarbonableMetadata.slot_uri(Uint256(1, 0));
    %{
        uri_data = [memory[ids.uri + i] for i in range(ids.uri_len)]
        assert uri_data == []
    %}

    let (uri_len, local uri: felt*) = CarbonableMetadata.contract_uri();
    %{
        uri_data = [memory[ids.uri + i] for i in range(ids.uri_len)]
        assert uri_data == []
    %}
    return ();
}
