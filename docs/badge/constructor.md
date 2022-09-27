
Constructor
===========
  
{% swagger method = "c0nstruct0r" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
Initialize the contract  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="uri_len(felt)" %}  
uri array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="uri(felt*)" %}  
uri characters as a felt array  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="name(felt)" %}  
name of the badge collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="owner(felt)" %}  
owner address  
{% endswagger-parameter %}  
{% endswagger %}