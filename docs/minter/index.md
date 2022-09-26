



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
owner(felt)
carbonable_project_address(felt)
payment_token_address(felt)
public_sale_open(felt)
max_buy_per_tx(felt)
unit_price(Uint256)
max_supply_for_mint(Uint256)
reserved_supply_for_mint(Uint256)

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## carbonable_project_address




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
carbonable_project_address(felt)
```  
{% endtab %}  
{% endtabs %}


## payment_token_address




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
payment_token_address(felt)
```  
{% endtab %}  
{% endtabs %}


## whitelisted_sale_open




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
whitelisted_sale_open(felt)
```  
{% endtab %}  
{% endtabs %}


## public_sale_open




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
public_sale_open(felt)
```  
{% endtab %}  
{% endtabs %}


## max_buy_per_tx




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
max_buy_per_tx(felt)
```  
{% endtab %}  
{% endtabs %}


## unit_price




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
unit_price(Uint256)
```  
{% endtab %}  
{% endtabs %}


## reserved_supply_for_mint




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
reserved_supply_for_mint(Uint256)
```  
{% endtab %}  
{% endtabs %}


## max_supply_for_mint




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
max_supply_for_mint(Uint256)
```  
{% endtab %}  
{% endtabs %}


## whitelist_merkle_root




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
whitelist_merkle_root(felt)
```  
{% endtab %}  
{% endtabs %}


## whitelisted_slots




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
slots(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## claimed_slots




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
account(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
slots(felt)
```  
{% endtab %}  
{% endtabs %}


## set_whitelist_merkle_root




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
whitelist_merkle_root(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_public_sale_open




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
public_sale_open(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_max_buy_per_tx




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
max_buy_per_tx(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## set_unit_price




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
unit_price(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## decrease_reserved_supply_for_mint




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
slots(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## airdrop




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
to(felt)
quantity(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}


## withdraw




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}


## transfer




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
token_address(felt)
recipient(felt)
amount(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}


## whitelist_buy




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
success(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## public_buy




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
quantity(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}

