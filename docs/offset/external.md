
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initialize the contract with the given parameters - This constructor uses a dedicated initializer that mainly stores the inputs  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="carbonable_project_address" %}  
Address of the Carbonable project  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="min_claimable" %}  
Minimum threshold of claimable to allow a claim  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "setMinClaimable" %}  
{% swagger-description %}  
Set the minimum claimable quantity (must be consistent with project absorption unit)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="min_claimable" %}  
New minimum claimable  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "claim" %}  
{% swagger-description %}  
Claim all the claimable balance of the caller address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="quantity" %}  
Quantity to claim  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "claimAll" %}  
{% swagger-description %}  
Claim all the total claimable of the caller address  
{% endswagger-description %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "deposit" %}  
{% swagger-description %}  
Deposit the specified token id into the contract (lock)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "withdraw" %}  
{% swagger-description %}  
Withdraw the specified token id into the contract  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}