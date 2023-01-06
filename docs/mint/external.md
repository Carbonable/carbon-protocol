
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
{% swagger method = "external" path = " " baseUrl = " " summary = "setWhitelistMerkleRoot" %}  
{% swagger-description %}  
Set a new merkle root, providing a not null merkle root opens the whitelist sale  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="whitelist_merkle_root" %}  
New merkle root  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setPublicSaleOpen" %}  
{% swagger-description %}  
Set a new public sale status (1 to open, 0 otherwise)  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="public_sale_open" %}  
Public sale status  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setMaxBuyPerTx" %}  
{% swagger-description %}  
Set a new max amount per tx during purchase  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="max_buy_per_tx" %}  
Max amount per tx  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "setUnitPrice" %}  
{% swagger-description %}  
Set a new unit price per token  
{% endswagger-description %}  
{% swagger-parameter in="path" type="Uint256" name="unit_price" %}  
Unit price  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "external" path = " " baseUrl = " " summary = "decreaseReservedSupplyForMint" %}  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "whitelistBuy" %}  
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
{% swagger method = "external" path = " " baseUrl = " " summary = "publicBuy" %}  
{% swagger-description %}  
Purchase -quantity- tokens while public sale is open  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="quantity" %}  
Quantity of tokens to buy  
{% endswagger-parameter %}  
{% swagger-response status="success ( felt )" description="1 if it succeeded, 0 otherwise" %}  
{% endswagger-response %}  
{% endswagger %}