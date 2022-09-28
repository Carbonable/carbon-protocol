
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "totalSupply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="totalSupply(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenByIndex" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="tokenId(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenOfOwnerByIndex" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="tokenId(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="interfaceId(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="name(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "symbol" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="symbol(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "ownerOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="owner(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getApproved" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="approved(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="isApproved(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="tokenId(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="tokenURI(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="owner(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="image_url_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="image_url(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="image_data_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="image_data(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "external_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="external_url_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="external_url(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "description" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="description_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="description(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "holder" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="holder_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="holder(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "certifier" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="certifier_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="certifier(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "land" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="land_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="land(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_land_surface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="unit_land_surface_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="unit_land_surface(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "country" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="country_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="country(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "expiration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="expiration_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="expiration(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_co2_sequestration_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_co2_sequestration(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="unit_co2_sequestration_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="unit_co2_sequestration(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_color_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_color(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_type" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_type_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_type(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_category_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_category(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "background_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="background_color_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="background_color(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "animation_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="animation_url_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="animation_url(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "youtube_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="youtube_url_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="youtube_url(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}