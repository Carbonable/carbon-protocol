
External
========
  
{% swagger method = "external" path = "approve" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "setApprovalForAll" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="operator(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="approved(felt)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "transferFrom" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="from_(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "safeTransferFrom" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="from_(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "mint" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "burn" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "setTokenURI" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenId(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="tokenURI(felt)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "transferOwnership" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="newOwner(felt)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "renounceOwnership" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_image_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="image_url_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="image_url(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_image_data" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="image_data_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="image_data(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_external_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="external_url_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="external_url(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_description" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="description_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="description(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_holder" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="holder_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="holder(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_certifier" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="certifier_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="certifier(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_land" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="land_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="land(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_unit_land_surface" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="unit_land_surface_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="unit_land_surface(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_country" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="country_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="country(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_expiration" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="expiration_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="expiration(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_total_co2_sequestration" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="total_co2_sequestration_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="total_co2_sequestration(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_unit_co2_sequestration" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="unit_co2_sequestration_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="unit_co2_sequestration(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_sequestration_color" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="sequestration_color_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="sequestration_color(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_sequestration_type" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="sequestration_type_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="sequestration_type(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_sequestration_category" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="sequestration_category_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="sequestration_category(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_background_color" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="background_color_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="background_color(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_animation_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="animation_url_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="animation_url(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "set_youtube_url" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="youtube_url_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="youtube_url(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}