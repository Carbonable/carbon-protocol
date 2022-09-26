



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor


Initialize the contract


### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - felt


### returns
  
  - uri array length


## supportsInterface





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - interfaceId(felt)


### returns
  
  - success(felt)


## uri





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - id(Uint256)


### returns
  
  - uri_len(felt)  
  - uri(felt)


## contractURI





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - uri_len(felt)  
  - uri(felt)


## balanceOf





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - account(felt)  
  - id(Uint256)


### returns
  
  - balance(Uint256)


## balanceOfBatch





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - balances_len  
  - balances


### returns



## isApprovedForAll





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - account(felt)  
  - operator(felt)


### returns
  
  - isApproved(felt)


## owner





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - owner(felt)


## name





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - name(felt)


## locked





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - id(Uint256)


### returns
  
  - is_locked(felt)


## setURI





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## setLocked





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - id(Uint256)


### returns



## setUnlocked





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - id(Uint256)


### returns



## setApprovalForAll





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - operator(felt)  
  - approved(felt)


### returns



## safeTransferFrom





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## safeBatchTransferFrom





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## mint





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## mintBatch





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## burn





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - from_(felt)  
  - id(Uint256)  
  - amount(Uint256)


### returns



## burnBatch





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## transferOwnership





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - newOwner(felt)


### returns



## renounceOwnership





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns


