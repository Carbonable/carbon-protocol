


  
<details>
  
<summary>set_whitelist_merkle_root</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
whitelist_merkle_root(felt)
```  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_public_sale_open</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
public_sale_open(felt)
```  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_max_buy_per_tx</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
max_buy_per_tx(felt)
```  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>set_unit_price</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
unit_price(Uint256)
```  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>decrease_reserved_supply_for_mint</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
slots(Uint256)
```  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>airdrop</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
to(felt)
quantity(felt)
```  
**Returns**

```rust
success(felt)
```  
</details>
  
<details>
  
<summary>withdraw</summary>
  
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
success(felt)
```  
</details>
  
<details>
  
<summary>transfer</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
token_address(felt)
recipient(felt)
amount(Uint256)
```  
**Returns**

```rust
success(felt)
```  
</details>
  
<details>
  
<summary>whitelist_buy</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
success(felt)
```  
**Returns**

```rust

```  
</details>
  
<details>
  
<summary>public_buy</summary>
  
**Implicit args**

```rust
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```rust
quantity(felt)
```  
**Returns**

```rust
success(felt)
```  
</details>
