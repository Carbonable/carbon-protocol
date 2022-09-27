
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "setURI" %}  
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
{% swagger-parameter in="path" type="" required="true" name="uri_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="uri(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setLocked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setUnlocked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setApprovalForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="operator(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="approved(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeBatchTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amounts(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mintBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amounts(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="data(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="id(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burnBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="from_(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="ids_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="ids(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amounts_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="amounts(Uint256*)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" required="true" name="newOwner(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "renounceOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% endswagger %}