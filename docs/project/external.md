
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "approve" %}  
{% swagger-description %}  
Change or reaffirm the approved address for an NFT (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
The new approved NFT controller  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
The NFT to approve  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setApprovalForAll" %}  
{% swagger-description %}  
Enable or disable approval for a third party -operator- to manage all of -caller-s assets (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
Address to add to the set of authorized operators  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="approved" %}  
1 if the operator is approved, 0 to revoke approval  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferFrom" %}  
{% swagger-description %}  
Transfer ownership of an NFT (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
The current owner of the NFT  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
The new owner  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
The NFT to transfer  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeTransferFrom" %}  
{% swagger-description %}  
Transfers the ownership of an NFT from one address to another address (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
The current owner of the NFT  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
The new owner  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
The NFT to transfer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
The data array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
Additional data with no specified format sent in call to -to-  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
Mint the token id to the specified -to- address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
Target address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
Token id  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
Burn the specified token  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
Token id  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setTokenURI" %}  
{% swagger-description %}  
Set the token URI of the specified token id (EIP 721 - Metadata extension)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="tokenURI" %}  
The Uri to set  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferOwnership" %}  
{% swagger-description %}  
Transfer ownership to a new owner  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="newOwner" %}  
Address of the new owner  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "renounceOwnership" %}  
{% swagger-description %}  
Renounce ownership  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_image_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="image_url_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="image_url" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_image_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="image_data_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="image_data" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_external_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="external_url_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="external_url" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_description" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="description_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="description" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_holder" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="holder_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="holder" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_certifier" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="certifier_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="certifier" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_land" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="land_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="land" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_unit_land_surface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="unit_land_surface_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="unit_land_surface" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_country" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="country_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="country" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_expiration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="expiration_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="expiration" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_total_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="total_co2_sequestration_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="total_co2_sequestration" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_unit_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="unit_co2_sequestration_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="unit_co2_sequestration" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_sequestration_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="sequestration_color_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="sequestration_color" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_sequestration_type" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="sequestration_type_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="sequestration_type" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_sequestration_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="sequestration_category_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="sequestration_category" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_background_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="background_color_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="background_color" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_animation_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="animation_url_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="animation_url" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_youtube_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="youtube_url_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="youtube_url" %}  
  
{% endswagger-parameter %}  
{% endswagger %}