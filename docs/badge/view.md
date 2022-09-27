



# View
  
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
<summary>uri</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
bitwise_ptr(BitwiseBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
id(Uint256)
```  
**Returns**

```python
uri_len(felt)
uri(felt)
```  
</details>

  
<details>  
<summary>contractURI</summary>  
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
uri_len(felt)
uri(felt)
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
account(felt)
id(Uint256)
```  
**Returns**

```python
balance(Uint256)
```  
</details>

  
<details>  
<summary>balanceOfBatch</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
balances_len
balances
```  
**Returns**

```python

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
account(felt)
operator(felt)
```  
**Returns**

```python
isApproved(felt)
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
<summary>locked</summary>  
**Implicit args**

```python
syscall_ptr(felt*)
pedersen_ptr(HashBuiltin*)
range_check_ptr
```  
**Explicit args**

```python
id(Uint256)
```  
**Returns**

```python
is_locked(felt)
```  
</details>

