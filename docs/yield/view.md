
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
{% swagger method = "view" path = " " baseUrl = " " summary = "getCarbonableOffseterAddress" %}  
{% swagger-description %}  
Return the associated carbonable offseter  
{% endswagger-description %}  
{% swagger-response status="carbonable_offseter_address ( felt )" description="Address of the corresponding Carbonable offseter" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getCarbonableVesterAddress" %}  
{% swagger-description %}  
Return the associated carbonable vester  
{% endswagger-description %}  
{% swagger-response status="carbonable_vester_address ( felt )" description="Address of the corresponding Carbonable vester" %}  
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
Address  
{% endswagger-parameter %}  
{% swagger-response status="claimable ( felt )" description="Total claimable" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getClaimedOf" %}  
{% swagger-description %}  
Return the total claimed balance of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
Address  
{% endswagger-parameter %}  
{% swagger-response status="claimed ( felt )" description="Total claimed" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getSnapshotedOf" %}  
{% swagger-description %}  
Return the snapshoted absorption of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
Address  
{% endswagger-parameter %}  
{% swagger-response status="absorption ( felt )" description="Snapshoted absorption" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getSnapshotedOffseterOf" %}  
{% swagger-description %}  
Return the snapshoted absorption of the provided address for offseter contract  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
Address  
{% endswagger-parameter %}  
{% swagger-response status="absorption ( felt )" description="Snapshoted absorption" %}  
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
{% swagger method = "view" path = " " baseUrl = " " summary = "getRegisteredTokensOf" %}  
{% swagger-description %}  
Return the registered tokens of the provided address  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="address" %}  
Token id  
{% endswagger-parameter %}  
{% swagger-response status="tokens_len ( felt )" description="Tokens array length" %}  
{% endswagger-response %}  
{% swagger-response status="tokens ( Uint256* )" description="Tokens deposited by the provided address" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getSnapshotedTime" %}  
{% swagger-description %}  
Return the associated carbonable vester  
{% endswagger-description %}  
{% swagger-response status="time ( felt )" description="The last snapshot time" %}  
{% endswagger-response %}  
{% endswagger %}