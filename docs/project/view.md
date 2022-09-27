
View
====
  
{% swagger method = "view" path = "totalSupply" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="totalSupply(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "tokenByIndex" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "tokenOfOwnerByIndex" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "supportsInterface" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="interfaceId(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="success(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "name" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="name(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "symbol" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="symbol(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "balanceOf" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="balance(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "ownerOf" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "getApproved" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="approved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "isApprovedForAll" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="isApproved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "tokenURI" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="tokenURI(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "owner" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "image_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="image_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="image_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "image_data" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="image_data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="image_data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "external_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="external_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="external_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "description" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="description_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="description(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "holder" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="holder_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="holder(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "certifier" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="certifier_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="certifier(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "land" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="land_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="land(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "unit_land_surface" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="unit_land_surface_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="unit_land_surface(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "country" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="country_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="country(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "expiration" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="expiration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="expiration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "total_co2_sequestration" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="total_co2_sequestration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="total_co2_sequestration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "unit_co2_sequestration" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="unit_co2_sequestration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="unit_co2_sequestration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "sequestration_color" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="sequestration_color_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="sequestration_color(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "sequestration_type" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="sequestration_type_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="sequestration_type(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "sequestration_category" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="sequestration_category_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="sequestration_category(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "background_color" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="background_color_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="background_color(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "animation_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="animation_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="animation_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }  
{% swagger method = "view" path = "youtube_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="youtube_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="youtube_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger % }