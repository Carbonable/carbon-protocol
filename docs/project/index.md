



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
name(felt)
symbol(felt)
owner(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## totalSupply




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo

```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
totalSupply(Uint256)
```  
{% endtab %}  
{% endtabs %}


## tokenByIndex




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
index(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% endtabs %}


## tokenOfOwnerByIndex




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
owner(felt)
index(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
tokenId(Uint256)
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


## symbol




  
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
symbol(felt)
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
owner(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
balance(Uint256)
```  
{% endtab %}  
{% endtabs %}


## ownerOf




  
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
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
owner(felt)
```  
{% endtab %}  
{% endtabs %}


## getApproved




  
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
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
approved(felt)
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
owner(felt)
operator(felt)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
isApproved(felt)
```  
{% endtab %}  
{% endtabs %}


## tokenURI




  
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
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo
tokenURI(felt)
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


## image_url




  
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
image_url_len(felt)
image_url(felt)
```  
{% endtab %}  
{% endtabs %}


## image_data




  
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
image_data_len(felt)
image_data(felt)
```  
{% endtab %}  
{% endtabs %}


## external_url




  
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
external_url_len(felt)
external_url(felt)
```  
{% endtab %}  
{% endtabs %}


## description




  
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
description_len(felt)
description(felt)
```  
{% endtab %}  
{% endtabs %}


## holder




  
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
holder_len(felt)
holder(felt)
```  
{% endtab %}  
{% endtabs %}


## certifier




  
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
certifier_len(felt)
certifier(felt)
```  
{% endtab %}  
{% endtabs %}


## land




  
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
land_len(felt)
land(felt)
```  
{% endtab %}  
{% endtabs %}


## unit_land_surface




  
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
unit_land_surface_len(felt)
unit_land_surface(felt)
```  
{% endtab %}  
{% endtabs %}


## country




  
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
country_len(felt)
country(felt)
```  
{% endtab %}  
{% endtabs %}


## expiration




  
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
expiration_len(felt)
expiration(felt)
```  
{% endtab %}  
{% endtabs %}


## total_co2_sequestration




  
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
total_co2_sequestration_len(felt)
total_co2_sequestration(felt)
```  
{% endtab %}  
{% endtabs %}


## unit_co2_sequestration




  
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
unit_co2_sequestration_len(felt)
unit_co2_sequestration(felt)
```  
{% endtab %}  
{% endtabs %}


## sequestration_color




  
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
sequestration_color_len(felt)
sequestration_color(felt)
```  
{% endtab %}  
{% endtabs %}


## sequestration_type




  
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
sequestration_type_len(felt)
sequestration_type(felt)
```  
{% endtab %}  
{% endtabs %}


## sequestration_category




  
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
sequestration_category_len(felt)
sequestration_category(felt)
```  
{% endtab %}  
{% endtabs %}


## background_color




  
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
background_color_len(felt)
background_color(felt)
```  
{% endtab %}  
{% endtabs %}


## animation_url




  
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
animation_url_len(felt)
animation_url(felt)
```  
{% endtab %}  
{% endtabs %}


## youtube_url




  
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
youtube_url_len(felt)
youtube_url(felt)
```  
{% endtab %}  
{% endtabs %}


## approve




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
to(felt)
tokenId(Uint256)
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


## transferFrom




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
from_(felt)
to(felt)
tokenId(Uint256)
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
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
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
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
to(felt)
tokenId(Uint256)
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
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
tokenId(Uint256)
```  
{% endtab %}  
{% tab title="Returns" %}

```cairo

```  
{% endtab %}  
{% endtabs %}


## setTokenURI




  
{% tabs %}  
{% tab title="Implicit args" %}

```cairo
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
{% endtab %}  
{% tab title="Explicit args" %}

```cairo
tokenId(Uint256)
tokenURI(felt)
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


## set_image_url




  
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


## set_image_data




  
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


## set_external_url




  
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


## set_description




  
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


## set_holder




  
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


## set_certifier




  
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


## set_land




  
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


## set_unit_land_surface




  
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


## set_country




  
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


## set_expiration




  
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


## set_total_co2_sequestration




  
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


## set_unit_co2_sequestration




  
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


## set_sequestration_color




  
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


## set_sequestration_type




  
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


## set_sequestration_category




  
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


## set_background_color




  
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


## set_animation_url




  
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


## set_youtube_url




  
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

