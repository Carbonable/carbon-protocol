



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor


Initialize the contract

  
{% tabs %}  
{% tab title="Implicit args_253" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_254" %}

```cairo
felt
```  
{% endtab %}  
{% tab title="Returns_255" %}

```cairo
uri array length
```  
{% endtab %}  
{% endtabs %}


## supportsInterface




  
{% tabs %}  
{% tab title="Implicit args_256" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_257" %}

```cairo
interfaceId(felt)
```  
{% endtab %}  
{% tab title="Returns_258" %}

```cairo
success(felt)
```  
{% endtab %}  
{% endtabs %}


## uri




  
{% tabs %}  
{% tab title="Implicit args_259" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_260" %}

```cairo
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns_261" %}

```cairo
uri_len(felt)
uri(felt)
```  
{% endtab %}  
{% endtabs %}


## contractURI




  
{% tabs %}  
{% tab title="Implicit args_262" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_263" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_264" %}

```cairo
uri_len(felt)
uri(felt)
```  
{% endtab %}  
{% endtabs %}


## balanceOf




  
{% tabs %}  
{% tab title="Implicit args_265" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_266" %}

```cairo
account(felt)
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns_267" %}

```cairo
balance(Uint256)
```  
{% endtab %}  
{% endtabs %}


## balanceOfBatch




  
{% tabs %}  
{% tab title="Implicit args_268" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_269" %}

```cairo
balances_len
balances
```  
{% endtab %}  
{% tab title="Returns_270" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## isApprovedForAll




  
{% tabs %}  
{% tab title="Implicit args_271" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_272" %}

```cairo
account(felt)
operator(felt)
```  
{% endtab %}  
{% tab title="Returns_273" %}

```cairo
isApproved(felt)
```  
{% endtab %}  
{% endtabs %}


## owner




  
{% tabs %}  
{% tab title="Implicit args_274" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_275" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_276" %}

```cairo
owner(felt)
```  
{% endtab %}  
{% endtabs %}


## name




  
{% tabs %}  
{% tab title="Implicit args_277" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_278" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_279" %}

```cairo
name(felt)
```  
{% endtab %}  
{% endtabs %}


## locked




  
{% tabs %}  
{% tab title="Implicit args_280" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_281" %}

```cairo
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns_282" %}

```cairo
is_locked(felt)
```  
{% endtab %}  
{% endtabs %}


## setURI




  
{% tabs %}  
{% tab title="Implicit args_283" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_284" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_285" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setLocked




  
{% tabs %}  
{% tab title="Implicit args_286" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_287" %}

```cairo
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns_288" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setUnlocked




  
{% tabs %}  
{% tab title="Implicit args_289" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_290" %}

```cairo
id(Uint256)
```  
{% endtab %}  
{% tab title="Returns_291" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setApprovalForAll




  
{% tabs %}  
{% tab title="Implicit args_292" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_293" %}

```cairo
operator(felt)
approved(felt)
```  
{% endtab %}  
{% tab title="Returns_294" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## safeTransferFrom




  
{% tabs %}  
{% tab title="Implicit args_295" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_296" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_297" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## safeBatchTransferFrom




  
{% tabs %}  
{% tab title="Implicit args_298" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_299" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_300" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## mint




  
{% tabs %}  
{% tab title="Implicit args_301" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_302" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_303" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## mintBatch




  
{% tabs %}  
{% tab title="Implicit args_304" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_305" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_306" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## burn




  
{% tabs %}  
{% tab title="Implicit args_307" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_308" %}

```cairo
from_(felt)
id(Uint256)
amount(Uint256)
```  
{% endtab %}  
{% tab title="Returns_309" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## burnBatch




  
{% tabs %}  
{% tab title="Implicit args_310" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_311" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_312" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## transferOwnership




  
{% tabs %}  
{% tab title="Implicit args_313" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_314" %}

```cairo
newOwner(felt)
```  
{% endtab %}  
{% tab title="Returns_315" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## renounceOwnership




  
{% tabs %}  
{% tab title="Implicit args_316" %}

```cairo
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args_317" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns_318" %}

```cairo

```  
{% endtab %}  
{% endtabs %}

