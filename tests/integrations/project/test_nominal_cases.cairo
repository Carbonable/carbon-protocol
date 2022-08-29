# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_nominal_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Local dependencies
from tests.integrations.project.library import setup, admin_instance as admin

@view
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    # Given a deployed user contracts
    # And an admin with address 1000
    # And an anyone with address 1001
    # Given a deployed project contact
    # And owned by admin
    return setup()
end

@view
func test_setters{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}():
    # When admin set up the image url
    # And admin set up the external url
    # And admin set up the description
    # And admin set up the holder
    # And admin set up the certifier
    # And admin set up the land
    # And admin set up the unit land surface
    # And admin set up the country
    # And admin set up the expiration
    # And admin set up the total co2 sequestration
    # And admin set up the unit co2 sequestration
    # And admin set up the sequestration color
    # And admin set up the sequestration type
    # And admin set up the sequestration category
    # And admin set up the background color
    # And admin set up the animation url
    # And admin set up the youtube url
    # Then no failed transactions expected

    admin.set_image_url('https://image.com')
    admin.set_external_url('https://external.com')
    admin.set_description('This is a description')
    admin.set_holder('Holder')
    admin.set_certifier('Certifier')
    admin.set_land('Land')
    admin.set_unit_land_surface('100')
    admin.set_country('Country')
    admin.set_expiration('2042')
    admin.set_total_co2_sequestration('3603')
    admin.set_unit_co2_sequestration('0.5004')
    admin.set_sequestration_color('blue')
    admin.set_sequestration_type('mangrove')
    admin.set_sequestration_category('regeneration')
    admin.set_background_color('green')
    admin.set_animation_url('https://animation.com')
    admin.set_youtube_url('https://youtube.com')

    return ()
end
