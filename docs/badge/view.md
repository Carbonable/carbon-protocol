
View
====
  
<details>
  
<summary>supportsInterface</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
interfaceId(felt): 
```  
  
**Returns**

```rust
success(felt): 
```  
</details>
  
<details>
  
<summary>uri</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
id(Uint256): 
```  
  
**Returns**

```rust
uri_len(felt): 
uri(felt*): 
```  
</details>
  
<details>
  
<summary>contractURI</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
bitwise_ptr(BitwiseBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust

```  
  
**Returns**

```rust
uri_len(felt): 
uri(felt*): 
```  
</details>
  
<details>
  
<summary>balanceOf</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
account(felt): 
id(Uint256): 
```  
  
**Returns**

```rust
balance(Uint256): 
```  
</details>
  
<details>
  
<summary>balanceOfBatch</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
accounts_len(felt): 
accounts(felt*): 
ids_len(felt): 
ids(Uint256*): 
```  
  
**Returns**

```rust
balances_len(felt): 
balances(Uint256*): 
```  
</details>
  
<details>
  
<summary>isApprovedForAll</summary>

  
  
**Implicit args**

```rust
syscall_ptr(felt*): 
pedersen_ptr(HashBuiltin*): 
range_check_ptr: 
```  
  
**Explicit args**

```rust
account(felt): 
operator(felt): 
```  
  
**Returns**

```rust
isApproved(felt): 
```  
</details>
  
<details>
  
<summary>owner</summary>

  
  
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
owner(felt): 
```  
</details>
  
<details>
  
<summary>name</summary>

  
  
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
name(felt): 
```  
</details>
  
<details>
  
<summary>locked</summary>

  
  
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
is_locked(felt): 
```  
</details>
