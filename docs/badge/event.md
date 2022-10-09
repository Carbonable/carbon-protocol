
Event
=====
  
{% swagger method = "event" path = " " baseUrl = " " summary = "Locked" %}  
{% swagger-description %}  
Emit event when a token id is locked for transfer  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "event" path = " " baseUrl = " " summary = "Unlocked" %}  
{% swagger-description %}  
Emit event when a token id is unlocked for transfer  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% endswagger %}