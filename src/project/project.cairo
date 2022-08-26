# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (project.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from openzeppelin.token.erc721_enumerable.ERC721_Enumerable_Mintable_Burnable import constructor

# Local dependencies
from src.project.library import CarbonableProject

#
# Getters
#

@view
func image_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (image_url_len : felt, image_url : felt*):
    return CarbonableProject.image_url()
end

@view
func external_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (external_url_len : felt, external_url : felt*):
    return CarbonableProject.external_url()
end

@view
func description{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (description_len : felt, description : felt*):
    return CarbonableProject.description()
end

@view
func holder{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (holder_len : felt, holder : felt*):
    return CarbonableProject.holder()
end

@view
func certifier{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (certifier_len : felt, certifier : felt*):
    return CarbonableProject.certifier()
end

@view
func land{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (land_len : felt, land : felt*):
    return CarbonableProject.land()
end

@view
func unit_land_surface{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (unit_land_surface_len : felt, unit_land_surface : felt*):
    return CarbonableProject.unit_land_surface()
end

@view
func country{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (country_len : felt, country : felt*):
    return CarbonableProject.country()
end

@view
func expiration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (expiration_len : felt, expiration : felt*):
    return CarbonableProject.expiration()
end

@view
func total_co2_sequestration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (total_co2_sequestration_len : felt, total_co2_sequestration : felt*):
    return CarbonableProject.total_co2_sequestration()
end

@view
func unit_co2_sequestration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (unit_co2_sequestration_len : felt, unit_co2_sequestration : felt*):
    return CarbonableProject.unit_co2_sequestration()
end

@view
func sequestration_color{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (sequestration_color_len : felt, sequestration_color : felt*):
    return CarbonableProject.sequestration_color()
end

@view
func sequestration_type{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (sequestration_type_len : felt, sequestration_type : felt*):
    return CarbonableProject.sequestration_type()
end

@view
func sequestration_category{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (sequestration_category_len : felt, sequestration_category : felt*):
    return CarbonableProject.sequestration_category()
end

@view
func background_color{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (background_color_len : felt, background_color : felt*):
    return CarbonableProject.background_color()
end

@view
func animation_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (animation_url_len : felt, animation_url : felt*):
    return CarbonableProject.animation_url()
end

@view
func youtube_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (youtube_url_len : felt, youtube_url : felt*):
    return CarbonableProject.youtube_url()
end

#
# Externals
#

@external
func set_image_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(image_url_len : felt, image_url : felt*) -> ():
    return CarbonableProject.set_image_url(image_url_len, image_url)
end

@external
func set_external_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(external_url_len : felt, external_url : felt*):
    return CarbonableProject.set_external_url(external_url_len, external_url)
end

@external
func set_description{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(description_len : felt, description : felt*):
    return CarbonableProject.set_description(description_len, description)
end

@external
func set_holder{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(holder_len : felt, holder : felt*):
    return CarbonableProject.set_holder(holder_len, holder)
end

@external
func set_certifier{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(certifier_len : felt, certifier : felt*):
    return CarbonableProject.set_certifier(certifier_len, certifier)
end

@external
func set_land{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(land_len : felt, land : felt*):
    return CarbonableProject.set_land(land_len, land)
end

@external
func set_unit_land_surface{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(unit_land_surface_len : felt, unit_land_surface : felt*):
    return CarbonableProject.set_unit_land_surface(unit_land_surface_len, unit_land_surface)
end

@external
func set_country{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(country_len : felt, country : felt*):
    return CarbonableProject.set_country(country_len, country)
end

@external
func set_expiration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(expiration_len : felt, expiration : felt*):
    return CarbonableProject.set_expiration(expiration_len, expiration)
end

@external
func set_total_co2_sequestration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(total_co2_sequestration_len : felt, total_co2_sequestration : felt*):
    return CarbonableProject.set_total_co2_sequestration(total_co2_sequestration_len, total_co2_sequestration)
end

@external
func set_unit_co2_sequestration{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(unit_co2_sequestration_len : felt, unit_co2_sequestration : felt*):
    return CarbonableProject.set_unit_co2_sequestration(unit_co2_sequestration_len, unit_co2_sequestration)
end

@external
func set_sequestration_color{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(sequestration_color_len : felt, sequestration_color : felt*):
    return CarbonableProject.set_sequestration_color(sequestration_color_len, sequestration_color)
end

@external
func set_sequestration_type{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(sequestration_type_len : felt, sequestration_type : felt*):
    return CarbonableProject.set_sequestration_type(sequestration_type_len, sequestration_type)
end

@external
func set_sequestration_category{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(sequestration_category_len : felt, sequestration_category : felt*):
    return CarbonableProject.set_sequestration_category(sequestration_category_len, sequestration_category)
end

@external
func set_background_color{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(background_color_len : felt, background_color : felt*):
    return CarbonableProject.set_background_color(background_color_len, background_color)
end

@external
func set_animation_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(animation_url_len : felt, animation_url : felt*):
    return CarbonableProject.set_animation_url(animation_url_len, animation_url)
end

@external
func set_youtube_url{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}(youtube_url_len : felt, youtube_url : felt*):
    return CarbonableProject.set_youtube_url(youtube_url_len, youtube_url)
end
