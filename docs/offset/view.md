
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "getImplementationHash" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAdmin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "carbonable_project_address" %}  
{% swagger-description %}  
Return the associated carbonable project  
{% endswagger-description %}  
{% swagger-response status="carbonable_project_address ( felt )" description="Address of the corresponding Carbonable project" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "is_locked" %}  
{% swagger-description %}  
Return the locked status of deposits and withdrawals  
{% endswagger-description %}  
{% swagger-response status="status ( felt )" description="Locked status (1 if locked else 0)" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_offsetable" %}  
{% swagger-description %}  
Return the total offsetable balance of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
address  
{% endswagger-parameter %}  
{% swagger-response status="total_offsetable ( Uint256 )" description="Total offsetable balance" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_offseted" %}  
{% swagger-description %}  
Return the total offseted balance of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
address  
{% endswagger-parameter %}  
{% swagger-response status="total_offseted ( Uint256 )" description="Total offseted balance" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_locked" %}  
{% swagger-description %}  
Return the current number of tokens locked in the contract  
{% endswagger-description %}  
{% swagger-response status="balance ( Uint256 )" description="Total balance of locked tokens" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balance_of" %}  
{% swagger-description %}  
Return the current balance of a specified address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
Address  
{% endswagger-parameter %}  
{% swagger-response status="balance ( Uint256 )" description="Balance associated to the address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "registred_owner_of" %}  
{% swagger-description %}  
Return the registred owner of a token id (0 if token is not locked in the contract)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="address ( felt )" description="Registred owner address" %}  
{% endswagger-response %}  
{% endswagger %}