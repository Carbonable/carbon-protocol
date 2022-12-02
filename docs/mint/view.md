
View
====
  
{% swagger method = "view" path = " " baseUrl = " " summary = "getImplementationHash" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="implementation ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "getAdmin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-response status="admin ( felt )" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "carbonable_project_address" %}  
{% swagger-description %}  
Return the associated carbonable project  
{% endswagger-description %}  
{% swagger-response status="carbonable_project_address ( felt )" description="Address of the corresponding Carbonable project" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "payment_token_address" %}  
{% swagger-description %}  
Return the associated payment token  
{% endswagger-description %}  
{% swagger-response status="payment_token_address ( felt )" description="Address of the ERC20 token that will be used during sales" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "whitelisted_sale_open" %}  
{% swagger-description %}  
Return the whitelisted sale status  
{% endswagger-description %}  
{% swagger-response status="whitelisted_sale_open ( felt )" description="1 if presale is open, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "public_sale_open" %}  
{% swagger-description %}  
Return the public sale status  
{% endswagger-description %}  
{% swagger-response status="public_sale_open ( felt )" description="1 if public sale is open, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "max_buy_per_tx" %}  
{% swagger-description %}  
Return the max amount that can be purchased in a single tx  
{% endswagger-description %}  
{% swagger-response status="max_buy_per_tx ( felt )" description="Max amount per tx" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "unit_price" %}  
{% swagger-description %}  
Return the unit price per token  
{% endswagger-description %}  
{% swagger-response status="unit_price ( Uint256 )" description="Unit price" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "reserved_supply_for_mint" %}  
{% swagger-description %}  
Return the reserved supply available for airdrops  
{% endswagger-description %}  
{% swagger-response status="reserved_supply_for_mint ( Uint256 )" description="Reserved supply" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "max_supply_for_mint" %}  
{% swagger-description %}  
Return the max supply available  
{% endswagger-description %}  
{% swagger-response status="max_supply_for_mint ( Uint256 )" description="Max supply" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "whitelist_merkle_root" %}  
{% swagger-description %}  
Return the whitelist merkle root, 0 means it has not been set yet  
{% endswagger-description %}  
{% swagger-response status="whitelist_merkle_root ( felt )" description="The merkle root" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "whitelisted_slots" %}  
{% swagger-description %}  
Return the whitelist merkle root, 0 means it has not been set yet  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
Account associated to slots  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="slots" %}  
Associated slots recorded in the merkle root  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proof_len" %}  
proof array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proof" %}  
Merkle proof associated to the account and slots  
{% endswagger-parameter %}  
{% swagger-response status="slots ( felt )" description="0 if not whitelisted, amount of slots otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "claimed_slots" %}  
{% swagger-description %}  
Return the slots already minted by an account using whitelist slots  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="account" %}  
Account address  
{% endswagger-parameter %}  
{% swagger-response status="slots ( felt )" description="amount of claimed slots" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "view" path = " " baseUrl = " " summary = "sold_out" %}  
{% swagger-description %}  
Return the sold out status  
{% endswagger-description %}  
{% swagger-response status="status ( felt )" description="1 if sold out else 0" %}  
{% endswagger-response %}  
{% endswagger %}