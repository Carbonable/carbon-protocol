
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "getImplementationHash" %}  
{% swagger-description %}  
Return the current implementation hash  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="Implementation class hash" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAdmin" %}  
{% swagger-description %}  
Return the admin address  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="The admin address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "owner" %}  
{% swagger-description %}  
Return the contract owner  
{% endswagger-description %}  
{% swagger-response status="owner ( felt )" description="The owner address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getCarbonableProjectAddress" %}  
{% swagger-description %}  
Return the associated carbonable project  
{% endswagger-description %}  
{% swagger-response status="carbonable_project_address ( felt )" description="Address of the corresponding Carbonable project" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "isOpen" %}  
{% swagger-description %}  
Return the deposits status according to project setup  
{% endswagger-description %}  
{% swagger-response status="status ( felt )" description="Deposits status" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getTotalDeposited" %}  
{% swagger-description %}  
Return the total deposited balance of the project  
{% endswagger-description %}  
{% swagger-response status="balance ( Uint256 )" description="Total deposited" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getTotalClaimed" %}  
{% swagger-description %}  
Return the total claimed absorption of the project  
{% endswagger-description %}  
{% swagger-response status="total_claimed ( felt )" description="Total claimed" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getTotalClaimable" %}  
{% swagger-description %}  
Return the total claimable absorption of the project  
{% endswagger-description %}  
{% swagger-response status="total_claimable ( felt )" description="Total claimable" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getClaimableOf" %}  
{% swagger-description %}  
Return the total claimable balance of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
address  
{% endswagger-parameter %}  
{% swagger-response status="claimable ( felt )" description="Total claimable" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getClaimedOf" %}  
{% swagger-description %}  
Return the total claimed balance of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
address  
{% endswagger-parameter %}  
{% swagger-response status="claimed ( felt )" description="Total claimed" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getRegisteredOwnerOf" %}  
{% swagger-description %}  
Return the registered owner of a token id (0 if token is not owned by the contract)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="address ( felt )" description="Registred owner address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getRegisteredTimeOf" %}  
{% swagger-description %}  
Return the registered time of a token id (0 if token is not owned by the contract)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="token_id" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="time ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}