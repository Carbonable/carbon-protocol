// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// Project dependencies
from cairopen.string.ASCII import StringCodec

// Local dependencies
from interfaces.project import ICarbonableProject
from tests.library import assert_string

//
// Functions
//

func setup{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/project/config.yml", context)

        # Admin account deployment
        context.admin_account_contract = deploy_contract(
            context.sources.account,
            {
                "public_key": context.signers.admin,
            },
        ).contract_address

        # Anyone account deployment
        context.anyone_account_contract = deploy_contract(
            context.sources.account,
            {
                "public_key": context.signers.anyone,
            },
        ).contract_address

        # Carbonable project deployment
        context.carbonable_project_contract = deploy_contract(
            context.sources.project,
            {
                "name": context.project.name,
                "symbol": context.project.symbol,
                "owner": context.admin_account_contract,
            },
        ).contract_address
    %}

    return ();
}

namespace carbonable_project_instance {
    // Internals

    func deployed() -> (carbonable_project_contract: felt) {
        tempvar carbonable_project_contract;
        %{ ids.carbonable_project_contract = context.carbonable_project_contract %}
        return (carbonable_project_contract,);
    }

    // Getters

    func image_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (image_url_len: felt, image_url: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.image_url(carbonable_project);
        return (len, array);
    }

    func external_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (external_url_len: felt, external_url: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.external_url(carbonable_project);
        return (len, array);
    }

    func description{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (description_len: felt, description: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.description(carbonable_project);
        return (len, array);
    }

    func holder{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (holder_len: felt, holder: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.holder(carbonable_project);
        return (len, array);
    }

    func certifier{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (certifier_len: felt, certifier: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.certifier(carbonable_project);
        return (len, array);
    }

    func land{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (land_len: felt, land: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.land(carbonable_project);
        return (len, array);
    }

    func unit_land_surface{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (unit_land_surface_len: felt, unit_land_surface: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.unit_land_surface(carbonable_project);
        return (len, array);
    }

    func country{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (country_len: felt, country: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.country(carbonable_project);
        return (len, array);
    }

    func expiration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (expiration_len: felt, expiration: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.expiration(carbonable_project);
        return (len, array);
    }

    func total_co2_sequestration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (total_co2_sequestration_len: felt, total_co2_sequestration: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.total_co2_sequestration(carbonable_project);
        return (len, array);
    }

    func unit_co2_sequestration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (unit_co2_sequestration_len: felt, unit_co2_sequestration: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.unit_co2_sequestration(carbonable_project);
        return (len, array);
    }

    func sequestration_color{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (sequestration_color_len: felt, sequestration_color: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.sequestration_color(carbonable_project);
        return (len, array);
    }

    func sequestration_type{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (sequestration_type_len: felt, sequestration_type: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.sequestration_type(carbonable_project);
        return (len, array);
    }

    func sequestration_category{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (sequestration_category_len: felt, sequestration_category: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.sequestration_category(carbonable_project);
        return (len, array);
    }

    func background_color{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (background_color_len: felt, background_color: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.background_color(carbonable_project);
        return (len, array);
    }

    func animation_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (animation_url_len: felt, animation_url: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.animation_url(carbonable_project);
        return (len, array);
    }

    func youtube_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }() -> (youtube_url_len: felt, youtube_url: felt*) {
        alloc_locals;
        let (len, array) = ICarbonableProject.youtube_url(carbonable_project);
        return (len, array);
    }

    // Externals

    func set_image_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(image_url_len: felt, image_url: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_image_url(carbonable_project, image_url_len, image_url);
        %{ stop_prank() %}
        return ();
    }

    func set_external_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(external_url_len: felt, external_url: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_external_url(carbonable_project, external_url_len, external_url);
        %{ stop_prank() %}
        return ();
    }

    func set_description{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(description_len: felt, description: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_description(carbonable_project, description_len, description);
        %{ stop_prank() %}
        return ();
    }

    func set_holder{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(holder_len: felt, holder: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_holder(carbonable_project, holder_len, holder);
        %{ stop_prank() %}
        return ();
    }

    func set_certifier{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(certifier_len: felt, certifier: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_certifier(carbonable_project, certifier_len, certifier);
        %{ stop_prank() %}
        return ();
    }

    func set_land{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(land_len: felt, land: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_land(carbonable_project, land_len, land);
        %{ stop_prank() %}
        return ();
    }

    func set_unit_land_surface{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(unit_land_surface_len: felt, unit_land_surface: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_unit_land_surface(
            carbonable_project, unit_land_surface_len, unit_land_surface
        );
        %{ stop_prank() %}
        return ();
    }

    func set_country{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(country_len: felt, country: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_country(carbonable_project, country_len, country);
        %{ stop_prank() %}
        return ();
    }

    func set_expiration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(expiration_len: felt, expiration: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_expiration(carbonable_project, expiration_len, expiration);
        %{ stop_prank() %}
        return ();
    }

    func set_total_co2_sequestration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(total_co2_sequestration_len: felt, total_co2_sequestration: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_total_co2_sequestration(
            carbonable_project, total_co2_sequestration_len, total_co2_sequestration
        );
        %{ stop_prank() %}
        return ();
    }

    func set_unit_co2_sequestration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(unit_co2_sequestration_len: felt, unit_co2_sequestration: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_unit_co2_sequestration(
            carbonable_project, unit_co2_sequestration_len, unit_co2_sequestration
        );
        %{ stop_prank() %}
        return ();
    }

    func set_sequestration_color{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(sequestration_color_len: felt, sequestration_color: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_sequestration_color(
            carbonable_project, sequestration_color_len, sequestration_color
        );
        %{ stop_prank() %}
        return ();
    }

    func set_sequestration_type{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(sequestration_type_len: felt, sequestration_type: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_sequestration_type(
            carbonable_project, sequestration_type_len, sequestration_type
        );
        %{ stop_prank() %}
        return ();
    }

    func set_sequestration_category{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(sequestration_category_len: felt, sequestration_category: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_sequestration_category(
            carbonable_project, sequestration_category_len, sequestration_category
        );
        %{ stop_prank() %}
        return ();
    }

    func set_background_color{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(background_color_len: felt, background_color: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_background_color(
            carbonable_project, background_color_len, background_color
        );
        %{ stop_prank() %}
        return ();
    }

    func set_animation_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(animation_url_len: felt, animation_url: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_animation_url(carbonable_project, animation_url_len, animation_url);
        %{ stop_prank() %}
        return ();
    }

    func set_youtube_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
        carbonable_project: felt,
    }(youtube_url_len: felt, youtube_url: felt*, caller: felt) {
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.carbonable_project) %}
        ICarbonableProject.set_youtube_url(carbonable_project, youtube_url_len, youtube_url);
        %{ stop_prank() %}
        return ();
    }
}

namespace admin_instance {
    // Internals

    func get_address() -> (address: felt) {
        tempvar admin;
        %{ ids.admin = context.admin_account_contract %}
        return (admin,);
    }

    // Externals

    func set_image_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(image_url: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(image_url);

        with carbonable_project {
            carbonable_project_instance.set_image_url(
                image_url_len=str.len, image_url=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.image_url();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_external_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(external_url: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(external_url);

        with carbonable_project {
            carbonable_project_instance.set_external_url(
                external_url_len=str.len, external_url=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.external_url();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_description{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(description: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(description);

        with carbonable_project {
            carbonable_project_instance.set_description(
                description_len=str.len, description=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.description();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_holder{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(holder: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(holder);

        with carbonable_project {
            carbonable_project_instance.set_holder(
                holder_len=str.len, holder=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.holder();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_certifier{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(certifier: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(certifier);

        with carbonable_project {
            carbonable_project_instance.set_certifier(
                certifier_len=str.len, certifier=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.certifier();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_land{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(land: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(land);

        with carbonable_project {
            carbonable_project_instance.set_land(land_len=str.len, land=str.data, caller=caller);
            let (len, array) = carbonable_project_instance.land();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_unit_land_surface{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(unit_land_surface: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(unit_land_surface);

        with carbonable_project {
            carbonable_project_instance.set_unit_land_surface(
                unit_land_surface_len=str.len, unit_land_surface=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.unit_land_surface();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_country{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(country: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(country);

        with carbonable_project {
            carbonable_project_instance.set_country(
                country_len=str.len, country=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.country();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_expiration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(expiration: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(expiration);

        with carbonable_project {
            carbonable_project_instance.set_expiration(
                expiration_len=str.len, expiration=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.expiration();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_total_co2_sequestration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(total_co2_sequestration: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(total_co2_sequestration);

        with carbonable_project {
            carbonable_project_instance.set_total_co2_sequestration(
                total_co2_sequestration_len=str.len, total_co2_sequestration=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.total_co2_sequestration();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_unit_co2_sequestration{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(unit_co2_sequestration: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(unit_co2_sequestration);

        with carbonable_project {
            carbonable_project_instance.set_unit_co2_sequestration(
                unit_co2_sequestration_len=str.len, unit_co2_sequestration=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.unit_co2_sequestration();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_sequestration_color{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(sequestration_color: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(sequestration_color);

        with carbonable_project {
            carbonable_project_instance.set_sequestration_color(
                sequestration_color_len=str.len, sequestration_color=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.sequestration_color();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_sequestration_type{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(sequestration_type: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(sequestration_type);

        with carbonable_project {
            carbonable_project_instance.set_sequestration_type(
                sequestration_type_len=str.len, sequestration_type=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.sequestration_type();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_sequestration_category{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(sequestration_category: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(sequestration_category);

        with carbonable_project {
            carbonable_project_instance.set_sequestration_category(
                sequestration_category_len=str.len, sequestration_category=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.sequestration_category();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_background_color{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(background_color: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(background_color);

        with carbonable_project {
            carbonable_project_instance.set_background_color(
                background_color_len=str.len, background_color=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.background_color();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_animation_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(animation_url: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(animation_url);

        with carbonable_project {
            carbonable_project_instance.set_animation_url(
                animation_url_len=str.len, animation_url=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.animation_url();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }

    func set_youtube_url{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        bitwise_ptr: BitwiseBuiltin*,
        range_check_ptr,
    }(youtube_url: felt) {
        alloc_locals;

        let (carbonable_project) = carbonable_project_instance.deployed();
        let (caller) = admin_instance.get_address();
        let (str) = StringCodec.ss_to_string(youtube_url);

        with carbonable_project {
            carbonable_project_instance.set_youtube_url(
                youtube_url_len=str.len, youtube_url=str.data, caller=caller
            );
            let (len, array) = carbonable_project_instance.youtube_url();
            let (returned_str) = StringCodec.ss_arr_to_string(len, array);
            assert_string(returned_str, str);
        }

        return ();
    }
}
