
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
Return the ability status to support the provided interface (EIP  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="interfaceId" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "uri" %}  
{% swagger-description %}  
Return the URI per token  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="uri_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="uri ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "contractURI" %}  
{% swagger-description %}  
Return the contract  
{% endswagger-description %}  
{% swagger-response status="uri_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="uri ( felt* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOfBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="accounts_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="accounts" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balances_len ( felt )" description="" %}  
{% endswagger-response %}  
{% swagger-response status="balances ( Uint256* )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="isApproved ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="name ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "locked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="is_locked ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}