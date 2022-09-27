



# View
  
<details>  
<summary>totalSupply</summary>  
**Implicit args**

```python
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
totalSupply(Uint256)
```  
</details>

  
<details>  
<summary>tokenByIndex</summary>  
**Implicit args**

```python
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
**Explicit args**

```python
index(Uint256)
```  
**Returns**

```python
tokenId(Uint256)
```  
</details>

  
<details>  
<summary>tokenOfOwnerByIndex</summary>  
**Implicit args**

```python
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
**Explicit args**

```python
owner(felt)
index(Uint256)
```  
**Returns**

```python
tokenId(Uint256)
```  
</details>

  
<details>  
<summary>supportsInterface</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
interfaceId(felt)
```  
**Returns**

```python
success(felt)
```  
</details>

  
<details>  
<summary>name</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
name(felt)
```  
</details>

  
<details>  
<summary>symbol</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
symbol(felt)
```  
</details>

  
<details>  
<summary>balanceOf</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
owner(felt)
```  
**Returns**

```python
balance(Uint256)
```  
</details>

  
<details>  
<summary>ownerOf</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
tokenId(Uint256)
```  
**Returns**

```python
owner(felt)
```  
</details>

  
<details>  
<summary>getApproved</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
tokenId(Uint256)
```  
**Returns**

```python
approved(felt)
```  
</details>

  
<details>  
<summary>isApprovedForAll</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
owner(felt)
operator(felt)
```  
**Returns**

```python
isApproved(felt)
```  
</details>

  
<details>  
<summary>tokenURI</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
tokenId(Uint256)
```  
**Returns**

```python
tokenURI(felt)
```  
</details>

  
<details>  
<summary>owner</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
owner(felt)
```  
</details>

  
<details>  
<summary>image_url</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
image_url_len(felt)
image_url(felt)
```  
</details>

  
<details>  
<summary>image_data</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
image_data_len(felt)
image_data(felt)
```  
</details>

  
<details>  
<summary>external_url</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
external_url_len(felt)
external_url(felt)
```  
</details>

  
<details>  
<summary>description</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
description_len(felt)
description(felt)
```  
</details>

  
<details>  
<summary>holder</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
holder_len(felt)
holder(felt)
```  
</details>

  
<details>  
<summary>certifier</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
certifier_len(felt)
certifier(felt)
```  
</details>

  
<details>  
<summary>land</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
land_len(felt)
land(felt)
```  
</details>

  
<details>  
<summary>unit_land_surface</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
unit_land_surface_len(felt)
unit_land_surface(felt)
```  
</details>

  
<details>  
<summary>country</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
country_len(felt)
country(felt)
```  
</details>

  
<details>  
<summary>expiration</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
expiration_len(felt)
expiration(felt)
```  
</details>

  
<details>  
<summary>total_co2_sequestration</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
total_co2_sequestration_len(felt)
total_co2_sequestration(felt)
```  
</details>

  
<details>  
<summary>unit_co2_sequestration</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
unit_co2_sequestration_len(felt)
unit_co2_sequestration(felt)
```  
</details>

  
<details>  
<summary>sequestration_color</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
sequestration_color_len(felt)
sequestration_color(felt)
```  
</details>

  
<details>  
<summary>sequestration_type</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
sequestration_type_len(felt)
sequestration_type(felt)
```  
</details>

  
<details>  
<summary>sequestration_category</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
sequestration_category_len(felt)
sequestration_category(felt)
```  
</details>

  
<details>  
<summary>background_color</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
background_color_len(felt)
background_color(felt)
```  
</details>

  
<details>  
<summary>animation_url</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
animation_url_len(felt)
animation_url(felt)
```  
</details>

  
<details>  
<summary>youtube_url</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python

```  
**Returns**

```python
youtube_url_len(felt)
youtube_url(felt)
```  
</details>

