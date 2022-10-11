
Constructor
===========
  
{% swagger method = "c0nstruct0r" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
Initialize the contract with the given name, symbol and owner - This constructor uses the standard OZ ERC721 initializer, the standard OZ ERC721Enumerable initializer and the OZ Ownable initializer  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="name" %}  
Name of the collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="symbol" %}  
Symbol of the collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner address  
{% endswagger-parameter %}  
{% endswagger %}