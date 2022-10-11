
Constructor
===========
  
{% swagger method = "c0nstruct0r" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
Initialize the contract with the given parameters - This constructor uses a dedicated initializer that mainly stores the inputs  
{% endswagger-description %}  
{% swagger-parameter in="path" type="felt" name="owner" %}  
Owner address  
{% endswagger-parameter %}  
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
{% endswagger %}