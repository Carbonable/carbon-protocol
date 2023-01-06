
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "getImplementationHash" %}  
{% swagger-description %}  
Return the current implementation hash  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="Implementation class hash" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAdmin" %}  
{% swagger-description %}  
Return the admin address  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="The admin address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
Return the contract owner  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="The owner address" %}  
{% endswagger-response %}  
{% endswagger %}  
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
{% swagger-response status="uri_len ( felt )" description="URI array length" %}  
{% endswagger-response %}  
{% swagger-response status="uri ( felt* )" description="The URI characters associated to the specified NFT" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "contractURI" %}  
{% swagger-description %}  
Return the contract uri (OpenSea)  
{% endswagger-description %}  
{% swagger-response status="uri_len ( felt )" description="URI array length" %}  
{% endswagger-response %}  
{% swagger-response status="uri ( felt* )" description="URI characters" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getStartTime" %}  
{% swagger-description %}  
Return the stored start time  
{% endswagger-description %}  
{% swagger-response status="time ( felt )" description="Start time" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getFinalTime" %}  
{% swagger-description %}  
Return the computed final time  
{% endswagger-description %}  
{% swagger-response status="time ( felt )" description="Final time" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getTimes" %}  
{% swagger-description %}  
Return the stored times  
{% endswagger-description %}  
{% swagger-response status="times_len ( felt )" description="Array length" %}  
{% endswagger-response %}  
{% swagger-response status="times ( felt* )" description="timestamps" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAbsorptions" %}  
{% swagger-description %}  
Return the stored absorptions  
{% endswagger-description %}  
{% swagger-response status="absorptions_len ( felt )" description="Array length" %}  
{% endswagger-response %}  
{% swagger-response status="absorptions ( felt* )" description="absorption values" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAbsorption" %}  
{% swagger-description %}  
Return the computed absorption based on the current timestamp  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="time" %}  
Time to compute the absorption  
{% endswagger-parameter %}  
{% swagger-response status="absorption ( felt )" description="absorption" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getCurrentAbsorption" %}  
{% swagger-description %}  
Return the computed absorption based on the current timestamp  
{% endswagger-description %}  
{% swagger-response status="absorption ( felt )" description="current absorption" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getFinalAbsorption" %}  
{% swagger-description %}  
Return the expected total absorption based on the final timestamp  
{% endswagger-description %}  
{% swagger-response status="absorption ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getTonEquivalent" %}  
{% swagger-description %}  
Return the ton equivalent in absorption unit  
{% endswagger-description %}  
{% swagger-response status="ton_equivalent ( felt )" description="Ton equivalent" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isSetup" %}  
{% swagger-description %}  
Return the setup status of the contract  
{% endswagger-description %}  
{% swagger-response status="status ( felt )" description="1 if setup else 0" %}  
{% endswagger-response %}  
{% endswagger %}