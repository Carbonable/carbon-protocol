
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initialize the contract with the given parameters - This constructor uses a dedicated initializer that mainly stores the inputs  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="carbonable_project_address" %}  
Address of the Carbonable project  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="carbonable_offseter_address" %}  
Address of the Carbonable offseter  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="carbonable_vester_address" %}  
Address of the Carbonable vester  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "snapshot" %}  
{% swagger-description %}  
Snapshot the current state of claimable and claimed per user  
{% endswagger-description %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "createVestings" %}  
{% swagger-description %}  
The Yielder goes through all assets that are deposited, during the current period, to create a vesting for each of the assets, on the starkvest smart contract, by allocating shares of the total amount collected from selling carbon credit  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="total_amount" %}  
amount, in ERC-20 value, of carbon credit sold for the current period  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="cliff_delta" %}  
duration in seconds of the cliff in which tokens will begin to vest  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="start" %}  
start time of the vesting period  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="duration" %}  
duration in seconds of the period in which the tokens will vest  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="slice_period_seconds" %}  
duration of a slice period for the vesting in seconds  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="revocable" %}  
whether the vesting is revocable or not  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="Success status" %}  
{% endswagger-response %}  
{% endswagger %}