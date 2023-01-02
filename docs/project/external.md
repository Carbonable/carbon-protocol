
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initialize the contract with the given name, symbol and owner - This constructor uses the standard OZ Proxy initializer, the standard OZ ERC721 initializer, the standard OZ ERC721Enumerable initializer and the OZ Ownable initializer  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="name" %}  
Name of the collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="symbol" %}  
Symbol of the collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner and Admin address  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "upgrade" %}  
{% swagger-description %}  
Upgrade the contract to the new implementation  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_implementation" %}  
New implementation class hash  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setAdmin" %}  
{% swagger-description %}  
Transfer admin rights to a new admin  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
Address of the new admin  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "setURI" %}  
{% swagger-description %}  
Set the contract base URI  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="uri_len" %}  
URI array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="uri" %}  
URI characters  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "addMinter" %}  
{% swagger-description %}  
Add new minter  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="minter" %}  
Minter address  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setTimes" %}  
{% swagger-description %}  
Set new time values  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="times_len" %}  
Array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="times" %}  
Time values  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setAbsorptions" %}  
{% swagger-description %}  
Set new absorption values  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="absorptions_len" %}  
Array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="absorptions" %}  
Absorption values  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ton_equivalent" %}  
Absorption ton equivalent  
{% endswagger-parameter %}  
{% endswagger %}