# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Project dependencies
from cairopen.string.ASCII import StringCodec

# Local dependencies
from interfaces.project import ICarbonableProject
from tests.library import assert_string

func setup{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    %{
        # Load config
        import sys
        sys.path.append('.')
        from tests import load
        load("./tests/integrations/project/config.yml", context)

        # ERC-721 deployment
        context.project_nft_contract = deploy_contract(
            context.sources.project,
            {
                "name": context.project.name,
                "symbol": context.project.symbol,
                "owner": context.signers.admin,
            },
        ).contract_address
    %}

    return ()
end

namespace project_nft_instance:
    # Internals

    func deployed() -> (project_nft_contract : felt):
        tempvar project_nft_contract
        %{ ids.project_nft_contract = context.project_nft_contract %}
        return (project_nft_contract)
    end

    # Getters

    func image_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (image_url_len : felt, image_url : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.image_url(project_nft)
        return (len, array)
    end

    func external_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (external_url_len : felt, external_url : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.external_url(project_nft)
        return (len, array)
    end

    func description{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (description_len : felt, description : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.description(project_nft)
        return (len, array)
    end

    func holder{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (holder_len : felt, holder : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.holder(project_nft)
        return (len, array)
    end

    func certifier{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (certifier_len : felt, certifier : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.certifier(project_nft)
        return (len, array)
    end

    func land{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (land_len : felt, land : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.land(project_nft)
        return (len, array)
    end

    func unit_land_surface{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (unit_land_surface_len : felt, unit_land_surface : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.unit_land_surface(project_nft)
        return (len, array)
    end

    func country{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (country_len : felt, country : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.country(project_nft)
        return (len, array)
    end

    func expiration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (expiration_len : felt, expiration : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.expiration(project_nft)
        return (len, array)
    end

    func total_co2_sequestration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (total_co2_sequestration_len : felt, total_co2_sequestration : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.total_co2_sequestration(project_nft)
        return (len, array)
    end

    func unit_co2_sequestration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (unit_co2_sequestration_len : felt, unit_co2_sequestration : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.unit_co2_sequestration(project_nft)
        return (len, array)
    end

    func sequestration_color{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (sequestration_color_len : felt, sequestration_color : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.sequestration_color(project_nft)
        return (len, array)
    end

    func sequestration_type{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (sequestration_type_len : felt, sequestration_type : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.sequestration_type(project_nft)
        return (len, array)
    end

    func sequestration_category{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (sequestration_category_len : felt, sequestration_category : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.sequestration_category(project_nft)
        return (len, array)
    end

    func background_color{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (background_color_len : felt, background_color : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.background_color(project_nft)
        return (len, array)
    end

    func animation_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (animation_url_len : felt, animation_url : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.animation_url(project_nft)
        return (len, array)
    end

    func youtube_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }() -> (youtube_url_len : felt, youtube_url : felt*):
        alloc_locals
        let (len, array) = ICarbonableProject.youtube_url(project_nft)
        return (len, array)
    end

    # Externals

    func set_image_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(image_url_len : felt, image_url : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_image_url(project_nft, image_url_len, image_url)
        %{ stop_prank() %}
        return ()
    end

    func set_external_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(external_url_len : felt, external_url : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_external_url(project_nft, external_url_len, external_url)
        %{ stop_prank() %}
        return ()
    end

    func set_description{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(description_len : felt, description : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_description(project_nft, description_len, description)
        %{ stop_prank() %}
        return ()
    end

    func set_holder{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(holder_len : felt, holder : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_holder(project_nft, holder_len, holder)
        %{ stop_prank() %}
        return ()
    end

    func set_certifier{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(certifier_len : felt, certifier : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_certifier(project_nft, certifier_len, certifier)
        %{ stop_prank() %}
        return ()
    end

    func set_land{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(land_len : felt, land : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_land(project_nft, land_len, land)
        %{ stop_prank() %}
        return ()
    end

    func set_unit_land_surface{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(unit_land_surface_len : felt, unit_land_surface : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_unit_land_surface(
            project_nft, unit_land_surface_len, unit_land_surface
        )
        %{ stop_prank() %}
        return ()
    end

    func set_country{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(country_len : felt, country : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_country(project_nft, country_len, country)
        %{ stop_prank() %}
        return ()
    end

    func set_expiration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(expiration_len : felt, expiration : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_expiration(project_nft, expiration_len, expiration)
        %{ stop_prank() %}
        return ()
    end

    func set_total_co2_sequestration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(total_co2_sequestration_len : felt, total_co2_sequestration : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_total_co2_sequestration(
            project_nft, total_co2_sequestration_len, total_co2_sequestration
        )
        %{ stop_prank() %}
        return ()
    end

    func set_unit_co2_sequestration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(unit_co2_sequestration_len : felt, unit_co2_sequestration : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_unit_co2_sequestration(
            project_nft, unit_co2_sequestration_len, unit_co2_sequestration
        )
        %{ stop_prank() %}
        return ()
    end

    func set_sequestration_color{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(sequestration_color_len : felt, sequestration_color : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_sequestration_color(
            project_nft, sequestration_color_len, sequestration_color
        )
        %{ stop_prank() %}
        return ()
    end

    func set_sequestration_type{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(sequestration_type_len : felt, sequestration_type : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_sequestration_type(
            project_nft, sequestration_type_len, sequestration_type
        )
        %{ stop_prank() %}
        return ()
    end

    func set_sequestration_category{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(sequestration_category_len : felt, sequestration_category : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_sequestration_category(
            project_nft, sequestration_category_len, sequestration_category
        )
        %{ stop_prank() %}
        return ()
    end

    func set_background_color{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(background_color_len : felt, background_color : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_background_color(project_nft, background_color_len, background_color)
        %{ stop_prank() %}
        return ()
    end

    func set_animation_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(animation_url_len : felt, animation_url : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_animation_url(project_nft, animation_url_len, animation_url)
        %{ stop_prank() %}
        return ()
    end

    func set_youtube_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
        project_nft : felt,
    }(youtube_url_len : felt, youtube_url : felt*, caller : felt):
        %{ stop_prank = start_prank(caller_address=ids.caller, target_contract_address=ids.project_nft) %}
        ICarbonableProject.set_youtube_url(project_nft, youtube_url_len, youtube_url)
        %{ stop_prank() %}
        return ()
    end
end

namespace admin_instance:
    # Internals

    func get_address() -> (address : felt):
        tempvar admin
        %{ ids.admin = context.signers.admin %}
        return (admin)
    end

    # Externals

    func set_image_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(image_url : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(image_url)

        with project_nft:
            project_nft_instance.set_image_url(
                image_url_len=str.len, image_url=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.image_url()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_external_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(external_url : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(external_url)

        with project_nft:
            project_nft_instance.set_external_url(
                external_url_len=str.len, external_url=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.external_url()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_description{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(description : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(description)

        with project_nft:
            project_nft_instance.set_description(
                description_len=str.len, description=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.description()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_holder{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(holder : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(holder)

        with project_nft:
            project_nft_instance.set_holder(holder_len=str.len, holder=str.data, caller=caller)
            let (len, array) = project_nft_instance.holder()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_certifier{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(certifier : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(certifier)

        with project_nft:
            project_nft_instance.set_certifier(
                certifier_len=str.len, certifier=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.certifier()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_land{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(land : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(land)

        with project_nft:
            project_nft_instance.set_land(land_len=str.len, land=str.data, caller=caller)
            let (len, array) = project_nft_instance.land()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_unit_land_surface{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(unit_land_surface : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(unit_land_surface)

        with project_nft:
            project_nft_instance.set_unit_land_surface(
                unit_land_surface_len=str.len, unit_land_surface=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.unit_land_surface()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_country{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(country : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(country)

        with project_nft:
            project_nft_instance.set_country(country_len=str.len, country=str.data, caller=caller)
            let (len, array) = project_nft_instance.country()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_expiration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(expiration : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(expiration)

        with project_nft:
            project_nft_instance.set_expiration(
                expiration_len=str.len, expiration=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.expiration()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_total_co2_sequestration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(total_co2_sequestration : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(total_co2_sequestration)

        with project_nft:
            project_nft_instance.set_total_co2_sequestration(
                total_co2_sequestration_len=str.len, total_co2_sequestration=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.total_co2_sequestration()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_unit_co2_sequestration{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(unit_co2_sequestration : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(unit_co2_sequestration)

        with project_nft:
            project_nft_instance.set_unit_co2_sequestration(
                unit_co2_sequestration_len=str.len, unit_co2_sequestration=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.unit_co2_sequestration()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_sequestration_color{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(sequestration_color : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(sequestration_color)

        with project_nft:
            project_nft_instance.set_sequestration_color(
                sequestration_color_len=str.len, sequestration_color=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.sequestration_color()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_sequestration_type{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(sequestration_type : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(sequestration_type)

        with project_nft:
            project_nft_instance.set_sequestration_type(
                sequestration_type_len=str.len, sequestration_type=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.sequestration_type()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_sequestration_category{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(sequestration_category : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(sequestration_category)

        with project_nft:
            project_nft_instance.set_sequestration_category(
                sequestration_category_len=str.len, sequestration_category=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.sequestration_category()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_background_color{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(background_color : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(background_color)

        with project_nft:
            project_nft_instance.set_background_color(
                background_color_len=str.len, background_color=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.background_color()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_animation_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(animation_url : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(animation_url)

        with project_nft:
            project_nft_instance.set_animation_url(
                animation_url_len=str.len, animation_url=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.animation_url()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end

    func set_youtube_url{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        bitwise_ptr : BitwiseBuiltin*,
        range_check_ptr,
    }(youtube_url : felt):
        alloc_locals

        let (project_nft) = project_nft_instance.deployed()
        let (caller) = admin_instance.get_address()
        let (str) = StringCodec.ss_to_string(youtube_url)

        with project_nft:
            project_nft_instance.set_youtube_url(
                youtube_url_len=str.len, youtube_url=str.data, caller=caller
            )
            let (len, array) = project_nft_instance.youtube_url()
            let (returned_str) = StringCodec.ss_arr_to_string(len, array)
            assert_string(returned_str, str)
        end

        return ()
    end
end
