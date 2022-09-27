
View
====
  
<details>
  
<summary>totalSupply</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
totalSupply(Uint256)
```  
</details>
  
<details>
  
<summary>tokenByIndex</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
  
**Explicit args**

```rust
index(Uint256)
```  
  
**Returns**

```rust
tokenId(Uint256)
```  
</details>
  
<details>
  
<summary>tokenOfOwnerByIndex</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*)
syscall_ptr(felt*)
range_check_ptr
```  
  
**Explicit args**

```rust
owner(felt)
index(Uint256)
```  
  
**Returns**

```rust
tokenId(Uint256)
```  
</details>
  
<details>
  
<summary>supportsInterface</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust
interfaceId(felt)
```  
  
**Returns**

```rust
success(felt)
```  
</details>
  
<details>
  
<summary>name</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
name(felt)
```  
</details>
  
<details>
  
<summary>symbol</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
symbol(felt)
```  
</details>
  
<details>
  
<summary>balanceOf</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust
owner(felt)
```  
  
**Returns**

```rust
balance(Uint256)
```  
</details>
  
<details>
  
<summary>ownerOf</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust
tokenId(Uint256)
```  
  
**Returns**

```rust
owner(felt)
```  
</details>
  
<details>
  
<summary>getApproved</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust
tokenId(Uint256)
```  
  
**Returns**

```rust
approved(felt)
```  
</details>
  
<details>
  
<summary>isApprovedForAll</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust
owner(felt)
operator(felt)
```  
  
**Returns**

```rust
isApproved(felt)
```  
</details>
  
<details>
  
<summary>tokenURI</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust
tokenId(Uint256)
```  
  
**Returns**

```rust
tokenURI(felt)
```  
</details>
  
<details>
  
<summary>owner</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
owner(felt)
```  
</details>
  
<details>
  
<summary>image_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
image_url_len(felt)
image_url(felt)
```  
</details>
  
<details>
  
<summary>image_data</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
image_data_len(felt)
image_data(felt)
```  
</details>
  
<details>
  
<summary>external_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
external_url_len(felt)
external_url(felt)
```  
</details>
  
<details>
  
<summary>description</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
description_len(felt)
description(felt)
```  
</details>
  
<details>
  
<summary>holder</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
holder_len(felt)
holder(felt)
```  
</details>
  
<details>
  
<summary>certifier</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
certifier_len(felt)
certifier(felt)
```  
</details>
  
<details>
  
<summary>land</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
land_len(felt)
land(felt)
```  
</details>
  
<details>
  
<summary>unit_land_surface</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
unit_land_surface_len(felt)
unit_land_surface(felt)
```  
</details>
  
<details>
  
<summary>country</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
country_len(felt)
country(felt)
```  
</details>
  
<details>
  
<summary>expiration</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
expiration_len(felt)
expiration(felt)
```  
</details>
  
<details>
  
<summary>total_co2_sequestration</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
total_co2_sequestration_len(felt)
total_co2_sequestration(felt)
```  
</details>
  
<details>
  
<summary>unit_co2_sequestration</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
unit_co2_sequestration_len(felt)
unit_co2_sequestration(felt)
```  
</details>
  
<details>
  
<summary>sequestration_color</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
sequestration_color_len(felt)
sequestration_color(felt)
```  
</details>
  
<details>
  
<summary>sequestration_type</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
sequestration_type_len(felt)
sequestration_type(felt)
```  
</details>
  
<details>
  
<summary>sequestration_category</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
sequestration_category_len(felt)
sequestration_category(felt)
```  
</details>
  
<details>
  
<summary>background_color</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
background_color_len(felt)
background_color(felt)
```  
</details>
  
<details>
  
<summary>animation_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
animation_url_len(felt)
animation_url(felt)
```  
</details>
  
<details>
  
<summary>youtube_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
youtube_url_len(felt)
youtube_url(felt)
```  
</details>
