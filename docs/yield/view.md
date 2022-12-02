
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
{% swagger method = "view" path = " " baseUrl = " " summary = "get_start_time" %}  
{% swagger-description %}  
Return the start time of the current period  
{% endswagger-description %}  
{% swagger-response status="start_time ( felt )" description="absolute unix time" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_lock_time" %}  
{% swagger-description %}  
Return the lock time of the current period  
{% endswagger-description %}  
{% swagger-response status="lock_time ( felt )" description="absolute unix time" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "get_end_time" %}  
{% swagger-description %}  
Return the end time of the current period  
{% endswagger-description %}  
{% swagger-response status="end_time ( felt )" description="absolute unix time" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "is_locked" %}  
{% swagger-description %}  
Return the locked status of deposits and withdrawals  
{% endswagger-description %}  
{% swagger-response status="status ( felt )" description="Locked status (1 if locked else 0)" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "total_locked" %}  
{% swagger-description %}  
Return the current number of tokens locked in the contract  
{% endswagger-description %}  
{% swagger-response status="balance ( Uint256 )" description="Total balance of locked tokens" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "shares_of" %}  
{% swagger-description %}  
Return the current share of a specified address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
Address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="precision" %}  
Decimal of the returned share  
{% endswagger-parameter %}  
{% swagger-response status="shares ( Uint256 )" description="" %}  
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