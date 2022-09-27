
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "setURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="uri_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="uri(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setLocked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setUnlocked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setApprovalForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="approved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeBatchTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amounts(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mintBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amounts(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burnBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="amounts(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{explicit}" required="True" name="newOwner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "renounceOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="False" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% endswagger %}