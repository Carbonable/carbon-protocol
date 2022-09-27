
External
========
  
<details>
  
<summary>approve</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*): 
syscall_ptr(felt*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
to(felt): 
tokenId(Uint256): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>setApprovalForAll</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
operator(felt): 
approved(felt): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>transferFrom</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*): 
syscall_ptr(felt*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
from_(felt): 
to(felt): 
tokenId(Uint256): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>safeTransferFrom</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*): 
syscall_ptr(felt*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
from_(felt): 
to(felt): 
tokenId(Uint256): 
data_len(felt): 
data(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>mint</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*): 
syscall_ptr(felt*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
to(felt): 
tokenId(Uint256): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>burn</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*): 
syscall_ptr(felt*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
tokenId(Uint256): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>setTokenURI</summary>

  
  
**Implicit args**

```rust
pedersen_ptr(HashBuiltin*): 
syscall_ptr(felt*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
tokenId(Uint256): 
tokenURI(felt): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>transferOwnership</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
newOwner(felt): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>renounceOwnership</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_image_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
image_url_len(felt): 
image_url(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_image_data</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
image_data_len(felt): 
image_data(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_external_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
external_url_len(felt): 
external_url(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_description</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
description_len(felt): 
description(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_holder</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
holder_len(felt): 
holder(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_certifier</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
certifier_len(felt): 
certifier(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_land</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
land_len(felt): 
land(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_unit_land_surface</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
unit_land_surface_len(felt): 
unit_land_surface(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_country</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
country_len(felt): 
country(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_expiration</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
expiration_len(felt): 
expiration(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_total_co2_sequestration</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
total_co2_sequestration_len(felt): 
total_co2_sequestration(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_unit_co2_sequestration</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
unit_co2_sequestration_len(felt): 
unit_co2_sequestration(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_sequestration_color</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
sequestration_color_len(felt): 
sequestration_color(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_sequestration_type</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
sequestration_type_len(felt): 
sequestration_type(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_sequestration_category</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
sequestration_category_len(felt): 
sequestration_category(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_background_color</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
background_color_len(felt): 
background_color(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_animation_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
animation_url_len(felt): 
animation_url(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_youtube_url</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
youtube_url_len(felt): 
youtube_url(felt*): 
```  
  
**Returns**

```rust

```  
</details>
