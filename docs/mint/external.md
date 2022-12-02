
External
========
  
{% swagger method = "external" path = " " baseUrl = " " summary = "initializer" %}  
{% swagger-description %}  
Initialize the contract with the given parameters - This constructor uses a dedicated initializer that mainly stores the inputs  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="carbonable_project_address" %}  
Address of the corresponding Carbonable project  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="payment_token_address" %}  
Address of the ERC20 token that will be used during sales  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="public_sale_open" %}  
1 to open the public sale right after deployment, 0 otherwise  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="max_buy_per_tx" %}  
Max number of NFTs that can be purchased in a single tx  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="unit_price" %}  
Price per token (based on ERC20 token defined as -payment_token_address-)  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="max_supply_for_mint" %}  
Max supply available whatever the way to mint  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="reserved_supply_for_mint" %}  
Supply reserved to be airdropped  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner address  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proxy_admin" %}  
Admin address  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "upgrade" %}  
{% swagger-description %}  
Renounce ownership  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_implementation" %}  
new contract implementation  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setAdmin" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="new_admin" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_whitelist_merkle_root" %}  
{% swagger-description %}  
Set a new merkle root, providing a not null merkle root opens the whitelist sale  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="whitelist_merkle_root" %}  
New merkle root  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_public_sale_open" %}  
{% swagger-description %}  
Set a new public sale status (1 to open, 0 otherwise)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="public_sale_open" %}  
Public sale status  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_max_buy_per_tx" %}  
{% swagger-description %}  
Set a new max amount per tx during purchase  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="max_buy_per_tx" %}  
Max amount per tx  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "set_unit_price" %}  
{% swagger-description %}  
Set a new unit price per token  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="unit_price" %}  
Unit price  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "decrease_reserved_supply_for_mint" %}  
{% swagger-description %}  
Decrease the reserved supply for airdrops by the providing amount of slots  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="slots" %}  
Amount of slots to substract to the reserved supply  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "airdrop" %}  
{% swagger-description %}  
Decrease the reserved supply for airdrops by the providing amount of slots  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="to" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="quantity" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="1 if it succeeded, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "withdraw" %}  
{% swagger-description %}  
Transfer the smart contract balance to the contract owner  
{% endswagger-description %}  
{% swagger-response status="success ( felt )" description="1 if it succeeded, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "transfer" %}  
{% swagger-description %}  
Transfer an amount of tokens specified by -token_address- to -recipient-  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="token_address" %}  
Token address to transfer  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="recipient" %}  
Address to receive tokens  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="Uint256" name="amount" %}  
Amount of token to transfer  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="1 if it succeeded, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "whitelist_buy" %}  
{% swagger-description %}  
Purchase -quantity- tokens while proving the caller is part of the merkle tree while whitelist sale is open  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="slots" %}  
Associated slots recorded in the merkle root  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proof_len" %}  
proof array length  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="proof" %}  
Merkle proof associated to the account and slots  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="felt" name="quantity" %}  
Quantity of tokens to buy  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="1 if it succeeded, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "public_buy" %}  
{% swagger-description %}  
Purchase -quantity- tokens while public sale is open  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="quantity" %}  
Quantity of tokens to buy  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="1 if it succeeded, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}