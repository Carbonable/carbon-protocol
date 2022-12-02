
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initialize the contract with the given parameters - This constructor uses a dedicated initializer that mainly stores the inputs  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="carbonable_project_address" %}  
Address of the corresponding Carbonable project  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy_admin" %}  
Admin address  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "upgrade" %}  
{% swagger-description %}  
Renounce ownership  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_implementation" %}  
new contract implementation  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setAdmin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "offset" %}  
{% swagger-description %}  
Offset the current total offsetable of the caller address  
{% endswagger-description %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "snapshot" %}  
{% swagger-description %}  
Snapshot deposits  
{% endswagger-description %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "start_period" %}  
{% swagger-description %}  
Start a new period (erase the current one)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="unlocked_duration" %}  
Unlocked duration in seconds  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="period_duration" %}  
Period duration in seconds  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="absorption" %}  
Carbon absorption in ng of CO2  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "stop_period" %}  
{% swagger-description %}  
Stop the current period  
{% endswagger-description %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "deposit" %}  
{% swagger-description %}  
Deposit the specified token id into the contract (lock)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "withdraw" %}  
{% swagger-description %}  
Withdraw the specified token id into the contract  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}