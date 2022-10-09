
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "totalSupply" %}  
{% swagger-description %}  
Count NFTs tracked by this contract (EIP 721 - Enumeration extension)  
{% endswagger-description %}  
{% swagger-response status="totalSupply ( Uint256 )" description="A count of valid NFTs tracked by this contract, where each one of them has an assigned and queryable owner not equal to the zero address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenByIndex" %}  
{% swagger-description %}  
Enumerate valid NFTs (EIP 721 - Enumeration extension)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
A counter less than -totalSupply()-  
{% endswagger-parameter %}  
{% swagger-response status="tokenId ( Uint256 )" description="The token identifier for the -index-th NFT (sort order not specified)" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenOfOwnerByIndex" %}  
{% swagger-description %}  
Enumerate NFTs assigned to an owner (EIP 721 - Enumeration extension)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
An address where we are interested in NFTs owned by them  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="index" %}  
A counter less than -balanceOf(owner)-  
{% endswagger-parameter %}  
{% swagger-response status="tokenId ( Uint256 )" description="The token identifier for the -index-th NFT assigned to -owner- (sort order not specified)" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
Return the ability status to support the provided interface (EIP 165)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="interfaceId" %}  
Interface id  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="1 if supported else 0" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
A descriptive name for a collection of NFTs in this contract (EIP 721 - Metadata extension)  
{% endswagger-description %}  
{% swagger-response status="name ( felt )" description="The contract name" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "symbol" %}  
{% swagger-description %}  
An abbreviated name for NFTs in this contract (EIP 721 - Metadata extension)  
{% endswagger-description %}  
{% swagger-response status="symbol ( felt )" description="The contract symbol" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
Count all NFTs assigned to an owner (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
An address for whom to query the balance  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="The number of NFTs owned by -owner-, possibly zero" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "ownerOf" %}  
{% swagger-description %}  
Find the owner of an NFT (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
The identifier for an NFT  
{% endswagger-parameter %}  
{% swagger-response status="owner ( felt )" description="The address of the owner of the NFT" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getApproved" %}  
{% swagger-description %}  
Get the approved address for a single NFT (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
The NFT to find the approved address for  
{% endswagger-parameter %}  
{% swagger-response status="approved ( felt )" description="The approved address for this NFT, or the zero address if there is none" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
Query if an address is an authorized operator for another address (EIP 721)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
The address that owns the NFTs  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
The address that acts on behalf of the owner  
{% endswagger-parameter %}  
{% swagger-response status="isApproved ( felt )" description="1 if -operator- is an approved operator for -owner-, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "tokenURI" %}  
{% swagger-description %}  
A distinct Uniform Resource Identifier (URI) for a given asset (EIP 721 - Metadata extension)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="tokenId" %}  
The NFT to find the URI for  
{% endswagger-parameter %}  
{% swagger-response status="tokenURI ( felt )" description="The URI associated to the specified NFT" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
Return the contract owner  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="The owner address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="image_url_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="image_url ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "image_data" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="image_data_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="image_data ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "external_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="external_url_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="external_url ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "description" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="description_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="description ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "holder" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="holder_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="holder ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "certifier" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="certifier_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="certifier ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "land" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="land_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="land ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_land_surface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="unit_land_surface_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="unit_land_surface ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "country" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="country_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="country ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "expiration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="expiration_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="expiration ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="total_co2_sequestration_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="total_co2_sequestration ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_co2_sequestration" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="unit_co2_sequestration_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="unit_co2_sequestration ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_color_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_color ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_type" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_type_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_type ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sequestration_category" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="sequestration_category_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="sequestration_category ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "background_color" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="background_color_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="background_color ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "animation_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="animation_url_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="animation_url ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "youtube_url" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="youtube_url_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="youtube_url ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}