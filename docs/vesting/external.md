
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initialize the contract with the given parameters - This constructor uses a dedicated initializer that mainly stores the inputs  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="erc20_address" %}  
Address of the corresponding Carbonable project  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner and Admin address  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "upgrade" %}  
{% swagger-description %}  
Upgrade the contract to the new implementation  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_implementation" %}  
New implementation class hash  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setAdmin" %}  
{% swagger-description %}  
Transfer admin rights to a new admin  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
Address of the new admin  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferOwnership" %}  
{% swagger-description %}  
Transfer ownership to a new owner  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="newOwner" %}  
Address of the new owner  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "renounceOwnership" %}  
{% swagger-description %}  
Renounce ownership  
{% endswagger-description %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "releaseAll" %}  
{% swagger-description %}  
Release all withdrawable amounts of all vestings associated to the caller  
{% endswagger-description %}  
{% endswagger %}