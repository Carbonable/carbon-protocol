
Constructor
===========
  
{% swagger method = "c0nstruct0r" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
Initialize the contract with the given uri, name and owner - This constructor ignores the standard OZ ERC1155 initializer (which require the uri only as single felt) in favor of a dedicated initialize handling the uri (as a felt*) and a name to be compliant with most markplaces, finally the OZ Ownable initializer is used  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="uri_len" %}  
URI array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="uri" %}  
URI characters  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="name" %}  
Name of the badge collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner address  
{% endswagger-parameter %}  
{% endswagger %}