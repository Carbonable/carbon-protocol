
View
====
  
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
{% swagger method = "view" path = " " baseUrl = " " summary = "uri" %}  
{% swagger-description %}  
Return the URI corresponding to the specified token id (OpenSea)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="uri_len ( felt )" description="URI array length" %}  
{% endswagger-response %}  
{% swagger-response status="uri ( felt* )" description="The URI characters" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "contractURI" %}  
{% swagger-description %}  
Return the contract uri (OpenSea)  
{% endswagger-description %}  
{% swagger-response status="uri_len ( felt )" description="URI array length" %}  
{% endswagger-response %}  
{% swagger-response status="uri ( felt* )" description="The URI characters" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
Get the balance of multiple account/token pairs (EIP 1155)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
The addresses of the token holder  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="The account-s balance of the token types requested (i-e balance for each (owner, id) pair)" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOfBatch" %}  
{% swagger-description %}  
Get the balance of multiple account/token pairs (EIP 1155)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="accounts_len" %}  
Accounts array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="accounts" %}  
The addresses of the token holders  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
Token ids array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
Token ids  
{% endswagger-parameter %}  
{% swagger-response status="balances_len ( felt )" description="The balances array length" %}  
{% endswagger-response %}  
{% swagger-response status="balances ( Uint256* )" description="The accounts balance of the token types requested (i-e balance for each (account, id) pair)" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
Queries the approval status of an operator for a given owner (EIP 1155)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
The owner of the tokens  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
Address of authorized operator  
{% endswagger-parameter %}  
{% swagger-response status="isApproved ( felt )" description="1 if the operator is approved, 0 if not" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
Return the contract owner  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="The owner address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
A descriptive name for a collection of NFTs in this contract (OpenSea)  
{% endswagger-description %}  
{% swagger-response status="name ( felt )" description="The contract name" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "locked" %}  
{% swagger-description %}  
Return the locked status of a token id  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="is_locked ( felt )" description="1 if locked else 0" %}  
{% endswagger-response %}  
{% endswagger %}