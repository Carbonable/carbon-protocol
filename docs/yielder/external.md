
External
========
  
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