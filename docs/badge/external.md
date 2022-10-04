
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "setURI" %}  
{% swagger-description %}  
Set the contract base URI  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="uri_len" %}  
Uri array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="uri" %}  
Uri characters  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setLocked" %}  
{% swagger-description %}  
Lock the corresponding token id  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id to lock  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setUnlocked" %}  
{% swagger-description %}  
Unock the corresponding token id  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id to unlock  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setApprovalForAll" %}  
{% swagger-description %}  
Enable or disable approval for a third party (operator) to manage all of the caller-s tokens (EIP 1155)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
Address to add to the set of authorized operators  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="approved" %}  
1 if the operator is approved, 0 to revoke approval  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeTransferFrom" %}  
{% swagger-description %}  
Transfer an amount of token id from address to a target (EIP 1155)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
Source address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
Target address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
Transfer amount  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
Data array len  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
Additional data with no specified format  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeBatchTransferFrom" %}  
{% swagger-description %}  
Transfer amounts of token ids from the from address to the to address specified (with safety call) (EIP 1155)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
Source address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
Target address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
Token ids array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
Token ids of each token type (order and length must match amounts array)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="amounts_len" %}  
Amounts array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="amounts" %}  
Transfer amounts per token type (order and length must match ids array)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
Data array len  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
Additional data with no specified format  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
Mint amount of token id to the -to- address specified  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
Target address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
Mint amount  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
Data array len  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
Additional data with no specified format  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mintBatch" %}  
{% swagger-description %}  
Mint amounts of token ids to the -to- address specified  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
Target address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
Token ids array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
Token ids of each token type (order and length must match amounts array)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="amounts_len" %}  
Amounts array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="amounts" %}  
Mint amounts per token type (order and length must match ids array)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
Data array len  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
Additional data with no specified format  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
Burn amount of token id from the -from_- address specified  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
Address of the token holder  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
Burn amount  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burnBatch" %}  
{% swagger-description %}  
Burn amounts of token ids from the -from_- address specified  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
Address of the token holder  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
Token ids array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
Token ids of each token type (order and length must match amounts array)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="amounts_len" %}  
Amounts array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="amounts" %}  
Burn amounts per token type (order and length must match ids array)  
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