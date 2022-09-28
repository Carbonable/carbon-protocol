
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "totalSupply" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="totalSupply" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenByIndex" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="tokenId" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenOfOwnerByIndex" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="tokenId" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="interfaceId" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="name" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "symbol" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="symbol" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "ownerOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="owner" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getApproved" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="approved" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="isApproved" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="tokenURI" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="owner" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="image_url_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="image_url" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="image_data_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="image_data" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "external_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="external_url_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="external_url" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "description" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="description_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="description" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "holder" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="holder_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="holder" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "certifier" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="certifier_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="certifier" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "land" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="land_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="land" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_land_surface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="unit_land_surface_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="unit_land_surface" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "country" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="country_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="country" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "expiration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="expiration_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="expiration" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_co2_sequestration_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_co2_sequestration" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="unit_co2_sequestration_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="unit_co2_sequestration" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_color_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_color" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_type" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_type_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_type" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_category_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_category" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "background_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="background_color_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="background_color" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "animation_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="animation_url_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="animation_url" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "youtube_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="youtube_url_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="youtube_url" description="" %}  
{% endswagger-response %}  
{% endswagger %}