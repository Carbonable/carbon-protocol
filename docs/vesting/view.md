
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "getImplementationHash" %}  
{% swagger-description %}  
Return the current implementation hash  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="Implementation class hash" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAdmin" %}  
{% swagger-description %}  
Return the admin address  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="The admin address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
Return the contract owner  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="The owner address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "releasableOf" %}  
{% swagger-description %}  
Return  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
Account address  
{% endswagger-parameter %}  
{% swagger-response status="amount ( Uint256 )" description="Total amount releasable" %}  
{% endswagger-response %}  
{% endswagger %}