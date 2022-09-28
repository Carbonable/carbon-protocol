
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "setURI" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="uri_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="uri" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setLocked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setUnlocked" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setApprovalForAll" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="operator" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="approved" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "safeBatchTransferFrom" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="amounts_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="amounts" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "mintBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="amounts_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="amounts" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="data_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt*" name="data" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burn" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="id" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "burnBatch" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="from_" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="ids_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="ids" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="amounts_len" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256*" name="amounts" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transferOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="newOwner" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "renounceOwnership" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% endswagger %}