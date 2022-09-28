
Internal
========
  
{% swagger method = "internal" path = " " baseUrl = " " summary = "verify" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="leaf" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="merkle_root" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proof_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="proof" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "internal" path = " " baseUrl = " " summary = "calculate_root" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="curr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proof_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="proof" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res" description="" %}  
{% endswagger-response %}  
{% endswagger %}