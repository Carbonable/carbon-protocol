
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="interfaceId(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "uri" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="uri_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="uri(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "contractURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="uri_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="uri(felt*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOfBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="accounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="accounts(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balances_len(felt)" description="" %}  
{% endswagger-response %}  
{% swagger-response status="balances(Uint256*)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="isApproved(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="owner(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="name(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "locked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="is_locked(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}