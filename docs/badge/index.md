



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor


Initialize the contract


### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - felt</font>


### returns
  
<font color="blue">  - uri array length</font>


## supportsInterface





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - interfaceId(felt)</font>


### returns
  
<font color="blue">  - success(felt)</font>


## uri





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - id(Uint256)</font>


### returns
  
<font color="blue">  - uri_len(felt)</font>  
<font color="blue">  - uri(felt)</font>


## contractURI





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - uri_len(felt)</font>  
<font color="blue">  - uri(felt)</font>


## balanceOf





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - account(felt)</font>  
<font color="orange">  - id(Uint256)</font>


### returns
  
<font color="blue">  - balance(Uint256)</font>


## balanceOfBatch





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - balances_len</font>  
<font color="orange">  - balances</font>


### returns



## isApprovedForAll





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - account(felt)</font>  
<font color="orange">  - operator(felt)</font>


### returns
  
<font color="blue">  - isApproved(felt)</font>


## owner





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - owner(felt)</font>


## name





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - name(felt)</font>


## locked





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - id(Uint256)</font>


### returns
  
<font color="blue">  - is_locked(felt)</font>


## setURI





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## setLocked





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - id(Uint256)</font>


### returns



## setUnlocked





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - id(Uint256)</font>


### returns



## setApprovalForAll





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - operator(felt)</font>  
<font color="orange">  - approved(felt)</font>


### returns



## safeTransferFrom





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## safeBatchTransferFrom





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## mint





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## mintBatch





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## burn





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - from_(felt)</font>  
<font color="orange">  - id(Uint256)</font>  
<font color="orange">  - amount(Uint256)</font>


### returns



## burnBatch





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## transferOwnership





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - newOwner(felt)</font>


### returns



## renounceOwnership





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns


