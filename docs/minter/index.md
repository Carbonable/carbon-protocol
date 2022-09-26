



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - owner(felt)  
  - carbonable_project_address(felt)  
  - payment_token_address(felt)  
  - public_sale_open(felt)  
  - max_buy_per_tx(felt)  
  - unit_price(Uint256)  
  - max_supply_for_mint(Uint256)  
  - reserved_supply_for_mint(Uint256)  
  - 


### returns



## carbonable_project_address





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - 


### returns
  
  - carbonable_project_address(felt)


## payment_token_address





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - payment_token_address(felt)


## whitelisted_sale_open





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - whitelisted_sale_open(felt)


## public_sale_open





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - public_sale_open(felt)


## max_buy_per_tx





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - max_buy_per_tx(felt)


## unit_price





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - unit_price(Uint256)


## reserved_supply_for_mint





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - 


### returns
  
  - reserved_supply_for_mint(Uint256)


## max_supply_for_mint





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - max_supply_for_mint(Uint256)


## whitelist_merkle_root





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - whitelist_merkle_root(felt)


## whitelisted_slots





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - slots(felt)


### returns



## claimed_slots





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - account(felt)


### returns
  
  - slots(felt)


## set_whitelist_merkle_root





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - whitelist_merkle_root(felt)


### returns



## set_public_sale_open





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - public_sale_open(felt)


### returns



## set_max_buy_per_tx





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - max_buy_per_tx(felt)


### returns



## set_unit_price





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - unit_price(Uint256)


### returns



## decrease_reserved_supply_for_mint





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - slots(Uint256)


### returns



## airdrop





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - to(felt)  
  - quantity(felt)


### returns
  
  - success(felt)


## withdraw





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - success(felt)


## transfer





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - token_address(felt)  
  - recipient(felt)  
  - amount(Uint256)


### returns
  
  - success(felt)


## whitelist_buy





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - success(felt)


### returns



## public_buy





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - quantity(felt)


### returns
  
  - success(felt)

