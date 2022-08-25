# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (library.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

# Project dependencies
from openzeppelin.access.ownable import Ownable

#
# Storage
#

@storage_var
func image_url_(index : felt) -> (char : felt):
end

@storage_var
func image_url_len_() -> (res_len : felt):
end

@storage_var
func external_url_() -> (char : felt):
end

@storage_var
func description_() -> (char : felt):
end

@storage_var
func name_() -> (char : felt):
end

@storage_var
func holder_() -> (char : felt):
end

@storage_var
func certifier_() -> (char : felt):
end

@storage_var
func country_() -> (char : felt):
end

@storage_var
func expiration_() -> (char : felt):
end

@storage_var
func background_color_() -> (res : felt):
end

@storage_var
func youtube_url_() -> (char : felt):
end

namespace CarbonableProject:
    #
    # Getters
    #

    func image_url{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        image_url_len : felt, image_url : felt*
    ):
        alloc_locals

        let (image_url_len) = image_url_len_.read()
        let (image_url : felt*) = alloc()
        image_url_loop(image_url_len, image_url)

        return (image_url_len, image_url)
    end

    #
    # Externals
    #

    func set_image_url{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        image_url_len : felt, image_url : felt*
    ):
        # Ownable.assert_only_owner()
        set_image_url_loop(image_url_len, image_url)
        image_url_len_.write(image_url_len)
        return ()
    end

    #
    # Internals
    #

    func image_url_loop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        image_url_len : felt, image_url : felt*
    ):
        if image_url_len == 0:
            return ()
        end

        let index = image_url_len - 1
        let (char) = image_url_.read(index)
        assert image_url[index] = char

        image_url_loop(index, image_url)
        return ()
    end

    func set_image_url_loop{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        image_url_len : felt, image_url : felt*
    ):
        alloc_locals

        if image_url_len == 0:
            return ()
        end

        let index = image_url_len - 1
        image_url_.write(index, image_url[index])
        set_image_url_loop(index, image_url)
        return ()
    end
end
