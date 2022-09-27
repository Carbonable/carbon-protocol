
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "totalSupply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="totalSupply(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenByIndex" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenOfOwnerByIndex" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="interfaceId(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="success(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="name(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "symbol" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="symbol(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="balance(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "ownerOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getApproved" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="approved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="isApproved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="tokenURI(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="image_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="image_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="image_data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="image_data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "external_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="external_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="external_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "description" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="description_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="description(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "holder" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="holder_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="holder(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "certifier" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="certifier_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="certifier(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "land" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="land_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="land(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_land_surface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="unit_land_surface_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="unit_land_surface(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "country" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="country_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="country(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "expiration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="expiration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="expiration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="total_co2_sequestration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="total_co2_sequestration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="unit_co2_sequestration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="unit_co2_sequestration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="sequestration_color_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="sequestration_color(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_type" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="sequestration_type_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="sequestration_type(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="sequestration_category_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="sequestration_category(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "background_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="background_color_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="background_color(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "animation_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="animation_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="animation_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "youtube_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="youtube_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="youtube_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}