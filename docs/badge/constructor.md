
Constructor
===========
  
{% swagger method = "c0nstruct0r" path = "constructor" baseUrl = " " summary = "Initialize the contract" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="uri_len(felt)" %}  
uri array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="uri(felt*)" %}  
uri characters as a felt array  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="name(felt)" %}  
name of the badge collection  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="owner(felt)" %}  
owner address  
{% endswagger-parameter %}  
{% endswagger % }