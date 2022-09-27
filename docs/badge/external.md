
External
========
  
<details>
  
<summary>setURI</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
uri_len(felt): 
uri(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>setLocked</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
id(Uint256): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>setUnlocked</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
id(Uint256): 
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
  
<summary>safeTransferFrom</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
from_(felt): 
to(felt): 
id(Uint256): 
amount(Uint256): 
data_len(felt): 
data(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>safeBatchTransferFrom</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
from_(felt): 
to(felt): 
ids_len(felt): 
ids(Uint256*): 
amounts_len(felt): 
amounts(Uint256*): 
data_len(felt): 
data(felt*): 
: 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>mint</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
to(felt): 
id(Uint256): 
amount(Uint256): 
data_len(felt): 
data(felt*): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>mintBatch</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
to(felt): 
ids_len(felt): 
ids(Uint256*): 
amounts_len(felt): 
amounts(Uint256*): 
data_len(felt): 
data(felt*): 
: 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>burn</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
from_(felt): 
id(Uint256): 
amount(Uint256): 
```  
  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>burnBatch</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
from_(felt): 
ids_len(felt): 
ids(Uint256*): 
amounts_len(felt): 
amounts(Uint256*): 
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
