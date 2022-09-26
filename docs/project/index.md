



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - name(felt)  
  - symbol(felt)  
  - owner(felt)


### returns



## totalSupply





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - totalSupply(Uint256)


## tokenByIndex





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - index(Uint256)


### returns
  
  - tokenId(Uint256)


## tokenOfOwnerByIndex





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - owner(felt)  
  - index(Uint256)


### returns
  
  - tokenId(Uint256)


## supportsInterface





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - interfaceId(felt)


### returns
  
  - success(felt)


## name





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - name(felt)


## symbol





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - symbol(felt)


## balanceOf





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - owner(felt)


### returns
  
  - balance(Uint256)


## ownerOf





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - tokenId(Uint256)


### returns
  
  - owner(felt)


## getApproved





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - tokenId(Uint256)


### returns
  
  - approved(felt)


## isApprovedForAll





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - owner(felt)  
  - operator(felt)


### returns
  
  - isApproved(felt)


## tokenURI





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs
  
  - tokenId(Uint256)


### returns
  
  - tokenURI(felt)


## owner





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - owner(felt)


## image_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - image_url_len(felt)  
  - image_url(felt)


## image_data





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - image_data_len(felt)  
  - image_data(felt)


## external_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - external_url_len(felt)  
  - external_url(felt)


## description





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - description_len(felt)  
  - description(felt)


## holder





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - holder_len(felt)  
  - holder(felt)


## certifier





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - certifier_len(felt)  
  - certifier(felt)


## land





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - land_len(felt)  
  - land(felt)


## unit_land_surface





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - unit_land_surface_len(felt)  
  - unit_land_surface(felt)


## country





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - country_len(felt)  
  - country(felt)


## expiration





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - expiration_len(felt)  
  - expiration(felt)


## total_co2_sequestration





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - total_co2_sequestration_len(felt)  
  - total_co2_sequestration(felt)


## unit_co2_sequestration





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - unit_co2_sequestration_len(felt)  
  - unit_co2_sequestration(felt)


## sequestration_color





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - sequestration_color_len(felt)  
  - sequestration_color(felt)


## sequestration_type





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - sequestration_type_len(felt)  
  - sequestration_type(felt)


## sequestration_category





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - sequestration_category_len(felt)  
  - sequestration_category(felt)


## background_color





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - background_color_len(felt)  
  - background_color(felt)


## animation_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - animation_url_len(felt)  
  - animation_url(felt)


## youtube_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns
  
  - youtube_url_len(felt)  
  - youtube_url(felt)


## approve





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - to(felt)  
  - tokenId(Uint256)


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



## transferFrom





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - from_(felt)  
  - to(felt)  
  - tokenId(Uint256)


### returns



## safeTransferFrom





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs



### returns



## mint





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - to(felt)  
  - tokenId(Uint256)


### returns



## burn





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - tokenId(Uint256)


### returns



## setTokenURI





### implicitArgs
  
  - pedersen_ptr(HashBuiltin*)  
  - syscall_ptr(felt*)  
  - range_check_ptr


### explicitArgs
  
  - tokenId(Uint256)  
  - tokenURI(felt)


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



## set_image_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_image_data





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_external_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_description





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_holder





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_certifier





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_land





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_unit_land_surface





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_country





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_expiration





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_total_co2_sequestration





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_unit_co2_sequestration





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_sequestration_color





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_sequestration_type





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_sequestration_category





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_background_color





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_animation_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns



## set_youtube_url





### implicitArgs
  
  - syscall_ptr(felt*)  
  - pedersen_ptr(HashBuiltin*)  
  - bitwise_ptr(BitwiseBuiltin*)  
  - range_check_ptr


### explicitArgs



### returns


