// SPDX-License-Identifier: MIT

%lang starknet

@contract_interface
namespace ICarbonableProject {
    func owner() -> (owner: felt) {
    }

    func transferOwnership(newOwner: felt) {
    }

    func image_url() -> (image_url_len: felt, image_url: felt*) {
    }

    func image_data() -> (image_data_len: felt, image_data: felt*) {
    }

    func external_url() -> (external_url_len: felt, external_url: felt*) {
    }

    func description() -> (description_len: felt, description: felt*) {
    }

    func holder() -> (holder_len: felt, holder: felt*) {
    }

    func certifier() -> (certifier_len: felt, certifier: felt*) {
    }

    func land() -> (land_len: felt, land: felt*) {
    }

    func unit_land_surface() -> (unit_land_surface_len: felt, unit_land_surface: felt*) {
    }

    func country() -> (country_len: felt, country: felt*) {
    }

    func expiration() -> (expiration_len: felt, expiration: felt*) {
    }

    func total_co2_sequestration() -> (
        total_co2_sequestration_len: felt, total_co2_sequestration: felt*
    ) {
    }

    func unit_co2_sequestration() -> (
        unit_co2_sequestration_len: felt, unit_co2_sequestration: felt*
    ) {
    }

    func sequestration_color() -> (sequestration_color_len: felt, sequestration_color: felt*) {
    }

    func sequestration_type() -> (sequestration_type_len: felt, sequestration_type: felt*) {
    }

    func sequestration_category() -> (
        sequestration_category_len: felt, sequestration_category: felt*
    ) {
    }

    func background_color() -> (background_color_len: felt, background_color: felt*) {
    }

    func animation_url() -> (animation_url_len: felt, animation_url: felt*) {
    }

    func youtube_url() -> (youtube_url_len: felt, youtube_url: felt*) {
    }

    func set_image_url(image_url_len: felt, image_url: felt*) -> () {
    }

    func set_image_data(image_data_len: felt, image_data: felt*) -> () {
    }

    func set_external_url(external_url_len: felt, external_url: felt*) {
    }

    func set_description(description_len: felt, description: felt*) {
    }

    func set_holder(holder_len: felt, holder: felt*) {
    }

    func set_certifier(certifier_len: felt, certifier: felt*) {
    }

    func set_land(land_len: felt, land: felt*) {
    }

    func set_unit_land_surface(unit_land_surface_len: felt, unit_land_surface: felt*) {
    }

    func set_country(country_len: felt, country: felt*) {
    }

    func set_expiration(expiration_len: felt, expiration: felt*) {
    }

    func set_total_co2_sequestration(
        total_co2_sequestration_len: felt, total_co2_sequestration: felt*
    ) {
    }

    func set_unit_co2_sequestration(
        unit_co2_sequestration_len: felt, unit_co2_sequestration: felt*
    ) {
    }

    func set_sequestration_color(sequestration_color_len: felt, sequestration_color: felt*) {
    }

    func set_sequestration_type(sequestration_type_len: felt, sequestration_type: felt*) {
    }

    func set_sequestration_category(
        sequestration_category_len: felt, sequestration_category: felt*
    ) {
    }

    func set_background_color(background_color_len: felt, background_color: felt*) {
    }

    func set_animation_url(animation_url_len: felt, animation_url: felt*) {
    }

    func set_youtube_url(youtube_url_len: felt, youtube_url: felt*) {
    }
}
