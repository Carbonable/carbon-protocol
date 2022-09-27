
External
========
  
{% swagger method = "external" path = "setURI" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="bitwise_ptr(BitwiseBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="uri_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="uri(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "setLocked" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "setUnlocked" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "setApprovalForAll" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="operator(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="approved(felt)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "safeTransferFrom" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="from_(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amount(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "safeBatchTransferFrom" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="from_(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids(Uint256*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amounts_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amounts(Uint256*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "mint" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amount(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data(felt*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "mintBatch" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="to(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids(Uint256*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amounts_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amounts(Uint256*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="data(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "burn" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="from_(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="id(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amount(Uint256)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "burnBatch" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="from_(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="ids(Uint256*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amounts_len(felt)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="amounts(Uint256*)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "transferOwnership" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{explicit}" required="false" name="newOwner(felt)" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}  
{% swagger method = "external" path = "renounceOwnership" baseUrl = " " summary = "" %}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="syscall_ptr(felt*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="pedersen_ptr(HashBuiltin*)" %}  
  
{{% endswagger-parameter %}}  
{% swagger-parameter in="path" type="{implicit}" required="false" name="range_check_ptr" %}  
  
{{% endswagger-parameter %}}  
{{% endswagger % }}