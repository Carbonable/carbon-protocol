# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (project.cairo)

%lang starknet

# Project dependencies
from openzeppelin.token.erc721_enumerable.interfaces.IERC721_Enumerable import (
    IERC721,
    IERC721_Enumerable,
)

@contract_interface
namespace ICarbonableProject:
    func owner() -> (owner : felt):
    end

    func transferOwnership(newOwner : felt):
    end

    func image_url() -> (image_url_len : felt, image_url : felt*):
    end

    func image_data() -> (image_data_len : felt, image_data : felt*):
    end

    func external_url() -> (external_url_len : felt, external_url : felt*):
    end

    func description() -> (description_len : felt, description : felt*):
    end

    func holder() -> (holder_len : felt, holder : felt*):
    end

    func certifier() -> (certifier_len : felt, certifier : felt*):
    end

    func land() -> (land_len : felt, land : felt*):
    end

    func unit_land_surface() -> (unit_land_surface_len : felt, unit_land_surface : felt*):
    end

    func country() -> (country_len : felt, country : felt*):
    end

    func expiration() -> (expiration_len : felt, expiration : felt*):
    end

    func total_co2_sequestration() -> (
        total_co2_sequestration_len : felt, total_co2_sequestration : felt*
    ):
    end

    func unit_co2_sequestration() -> (
        unit_co2_sequestration_len : felt, unit_co2_sequestration : felt*
    ):
    end

    func sequestration_color() -> (sequestration_color_len : felt, sequestration_color : felt*):
    end

    func sequestration_type() -> (sequestration_type_len : felt, sequestration_type : felt*):
    end

    func sequestration_category() -> (
        sequestration_category_len : felt, sequestration_category : felt*
    ):
    end

    func background_color() -> (background_color_len : felt, background_color : felt*):
    end

    func animation_url() -> (animation_url_len : felt, animation_url : felt*):
    end

    func youtube_url() -> (youtube_url_len : felt, youtube_url : felt*):
    end

    func set_image_url(image_url_len : felt, image_url : felt*) -> ():
    end

    func set_image_data(image_data_len : felt, image_data : felt*) -> ():
    end

    func set_external_url(external_url_len : felt, external_url : felt*):
    end

    func set_description(description_len : felt, description : felt*):
    end

    func set_holder(holder_len : felt, holder : felt*):
    end

    func set_certifier(certifier_len : felt, certifier : felt*):
    end

    func set_land(land_len : felt, land : felt*):
    end

    func set_unit_land_surface(unit_land_surface_len : felt, unit_land_surface : felt*):
    end

    func set_country(country_len : felt, country : felt*):
    end

    func set_expiration(expiration_len : felt, expiration : felt*):
    end

    func set_total_co2_sequestration(
        total_co2_sequestration_len : felt, total_co2_sequestration : felt*
    ):
    end

    func set_unit_co2_sequestration(
        unit_co2_sequestration_len : felt, unit_co2_sequestration : felt*
    ):
    end

    func set_sequestration_color(sequestration_color_len : felt, sequestration_color : felt*):
    end

    func set_sequestration_type(sequestration_type_len : felt, sequestration_type : felt*):
    end

    func set_sequestration_category(
        sequestration_category_len : felt, sequestration_category : felt*
    ):
    end

    func set_background_color(background_color_len : felt, background_color : felt*):
    end

    func set_animation_url(animation_url_len : felt, animation_url : felt*):
    end

    func set_youtube_url(youtube_url_len : felt, youtube_url : felt*):
    end
end
