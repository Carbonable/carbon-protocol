
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "approve" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setApprovalForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="approved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setTokenURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="tokenURI(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="newOwner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "renounceOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_image_url" %}  
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
{% swagger-parameter in="path" type="" required="true" name="image_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="image_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_image_data" %}  
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
{% swagger-parameter in="path" type="" required="true" name="image_data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="image_data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_external_url" %}  
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
{% swagger-parameter in="path" type="" required="true" name="external_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="external_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_description" %}  
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
{% swagger-parameter in="path" type="" required="true" name="description_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="description(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_holder" %}  
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
{% swagger-parameter in="path" type="" required="true" name="holder_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="holder(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_certifier" %}  
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
{% swagger-parameter in="path" type="" required="true" name="certifier_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="certifier(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_land" %}  
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
{% swagger-parameter in="path" type="" required="true" name="land_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="land(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_unit_land_surface" %}  
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
{% swagger-parameter in="path" type="" required="true" name="unit_land_surface_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="unit_land_surface(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_country" %}  
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
{% swagger-parameter in="path" type="" required="true" name="country_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="country(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_expiration" %}  
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
{% swagger-parameter in="path" type="" required="true" name="expiration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="expiration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_total_co2_sequestration" %}  
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
{% swagger-parameter in="path" type="" required="true" name="total_co2_sequestration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="total_co2_sequestration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_unit_co2_sequestration" %}  
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
{% swagger-parameter in="path" type="" required="true" name="unit_co2_sequestration_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="unit_co2_sequestration(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_sequestration_color" %}  
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
{% swagger-parameter in="path" type="" required="true" name="sequestration_color_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="sequestration_color(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_sequestration_type" %}  
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
{% swagger-parameter in="path" type="" required="true" name="sequestration_type_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="sequestration_type(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_sequestration_category" %}  
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
{% swagger-parameter in="path" type="" required="true" name="sequestration_category_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="sequestration_category(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_background_color" %}  
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
{% swagger-parameter in="path" type="" required="true" name="background_color_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="background_color(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_animation_url" %}  
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
{% swagger-parameter in="path" type="" required="true" name="animation_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="animation_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_youtube_url" %}  
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
{% swagger-parameter in="path" type="" required="true" name="youtube_url_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="youtube_url(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}