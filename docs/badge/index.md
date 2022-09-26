



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor


Initialize the contract

  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
felt
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
uri array length
```  
{% endtab %}  
{% endtabs %}


## supportsInterface




  
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
interfaceId(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}


## uri




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
uri_len(felt)
uri(felt)
```  
{% endtab %}  
{% endtabs %}


## contractURI




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
uri_len(felt)
uri(felt)
```  
{% endtab %}  
{% endtabs %}


## balanceOf




  
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
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
balance(Uint256)
```  
{% endtab %}  
{% endtabs %}


## balanceOfBatch




  
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
balances_len
balances
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## isApprovedForAll




  
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
operator(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
isApproved(felt)
```  
{% endtab %}  
{% endtabs %}


## owner




  
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
owner(felt)
```  
{% endtab %}  
{% endtabs %}


## name




  
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
name(felt)
```  
{% endtab %}  
{% endtabs %}


## locked




  
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
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
is_locked(felt)
```  
{% endtab %}  
{% endtabs %}


## setURI




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setLocked




  
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
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setUnlocked




  
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
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setApprovalForAll




  
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
operator(felt)
approved(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## safeTransferFrom




  
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

```  
{% endtab %}  
{% endtabs %}


## safeBatchTransferFrom




  
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

```  
{% endtab %}  
{% endtabs %}


## mint




  
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

```  
{% endtab %}  
{% endtabs %}


## mintBatch




  
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

```  
{% endtab %}  
{% endtabs %}


## burn




  
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
from_(felt)
id(Uint256)
amount(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## burnBatch




  
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

```  
{% endtab %}  
{% endtabs %}


## transferOwnership




  
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
newOwner(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## renounceOwnership




  
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

```  
{% endtab %}  
{% endtabs %}

