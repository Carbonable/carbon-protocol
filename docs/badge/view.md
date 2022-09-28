
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="interfaceId" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "uri" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="uri_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="uri" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "contractURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="uri_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="uri" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="balance" description="" %}  
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
{% swagger-response status="balances_len" description="" %}  
{% endswagger-response %}  
{% swagger-response status="balances" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="isApproved" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="owner" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="name" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "locked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="is_locked" description="" %}  
{% endswagger-response %}  
{% endswagger %}