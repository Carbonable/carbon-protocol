
Internal
========
  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "carbonable_project_address_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "payment_token_address_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "public_sale_open_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "max_buy_per_tx_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "unit_price_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "max_supply_for_mint_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "reserved_supply_for_mint_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="res(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "whitelist_merkle_root_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="whitelist_merkle_root(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "st0rage_var" path = " " baseUrl = " " summary = "claimed_slots_" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="slots(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "constructor" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="owner(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="carbonable_project_address(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="payment_token_address(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="public_sale_open(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="max_buy_per_tx(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="unit_price(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="max_supply_for_mint(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="reserved_supply_for_mint(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "carbonable_project_address" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="carbonable_project_address(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "payment_token_address" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="payment_token_address(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "whitelisted_sale_open" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="whitelisted_sale_open(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "public_sale_open" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="public_sale_open(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "max_buy_per_tx" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="max_buy_per_tx(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "unit_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="unit_price(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "max_supply_for_mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="max_supply_for_mint(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "reserved_supply_for_mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="reserved_supply_for_mint(Uint256)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "whitelist_merkle_root" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="whitelist_merkle_root(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "whitelisted_slots" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slots(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="proof_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="proof(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="slots(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "claimed_slots" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="account(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="slots(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "set_whitelist_merkle_root" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="whitelist_merkle_root(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "set_public_sale_open" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="public_sale_open(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "set_max_buy_per_tx" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="max_buy_per_tx(felt)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "set_unit_price" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="unit_price(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "decrease_reserved_supply_for_mint" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slots(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "airdrop" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="quantity(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "withdraw" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "transfer" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="token_address(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="recipient(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="amount(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "whitelist_buy" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="slots(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="proof_len(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="proof(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="quantity(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "public_buy" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="quantity(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "buy" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="quantity(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-response status="success(felt)" description="" %}  
{% endswagger-response %}  
{% endswagger %}  
{% swagger method = "namespace Carb0nableMinter" path = " " baseUrl = " " summary = "mint_n" %}  
{% swagger-description %}  
  
{% endswagger-description %}  
{% swagger-parameter in="path" type="{implicit}" name="syscall_ptr(felt*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="pedersen_ptr(HashBuiltin*)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="{implicit}" name="range_check_ptr" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="nft_contract_address(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="to(felt)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="starting_index(Uint256)" %}  
  
{% endswagger-parameter %}  
{% swagger-parameter in="path" type="" name="quantity(Uint256)" %}  
  
{% endswagger-parameter %}  
{% endswagger %}