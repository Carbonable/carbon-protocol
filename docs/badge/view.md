
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "supportsInterface" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="interfaceId(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="success(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "uri" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="uri_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="uri(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "contractURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="uri_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="uri(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOf" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="balance(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "balanceOfBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="accounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="accounts(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="balances_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="balances(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isApprovedForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="isApproved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "name" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="name(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "locked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{returns}" required="false" name="is_locked(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}