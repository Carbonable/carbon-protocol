# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_minter.cairo)

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

from cairopen.string.string import String
from cairopen.string.ASCII import StringCodec

from tests.units.project.library import setup, prepare, CarbonableProject

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    return setup()
end

@external
func test_image_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    alloc_locals

    # prepare minter instance
    let (local context) = prepare()

    # run scenario
    %{ stop=start_prank(context.signers.admin) %}

    let image_url_ss = 'https://image.com'
    let (image_url) = StringCodec.ss_to_string(image_url_ss)

    CarbonableProject.set_image_url(image_url_len=image_url.len, image_url=image_url.data)

    let (returned_image_url_len, returned_image_url) = CarbonableProject.image_url()
    assert returned_image_url_len = image_url.len
    assert returned_image_url[image_url.len - 1] = image_url.data[image_url.len - 1]
    %{ stop() %}

    return ()
end
