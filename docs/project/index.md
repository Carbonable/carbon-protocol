



# Introduction


This is an introduction


# Description


This is a description


# API Documentation

## constructor





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - name(felt)</font>  
<font color="orange">  - symbol(felt)</font>  
<font color="orange">  - owner(felt)</font>


### returns



## totalSupply





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - totalSupply(Uint256)</font>


## tokenByIndex





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - index(Uint256)</font>


### returns
  
<font color="blue">  - tokenId(Uint256)</font>


## tokenOfOwnerByIndex





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - owner(felt)</font>  
<font color="orange">  - index(Uint256)</font>


### returns
  
<font color="blue">  - tokenId(Uint256)</font>


## supportsInterface





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - interfaceId(felt)</font>


### returns
  
<font color="blue">  - success(felt)</font>


## name





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - name(felt)</font>


## symbol





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - symbol(felt)</font>


## balanceOf





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - owner(felt)</font>


### returns
  
<font color="blue">  - balance(Uint256)</font>


## ownerOf





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - tokenId(Uint256)</font>


### returns
  
<font color="blue">  - owner(felt)</font>


## getApproved





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - tokenId(Uint256)</font>


### returns
  
<font color="blue">  - approved(felt)</font>


## isApprovedForAll





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - owner(felt)</font>  
<font color="orange">  - operator(felt)</font>


### returns
  
<font color="blue">  - isApproved(felt)</font>


## tokenURI





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - tokenId(Uint256)</font>


### returns
  
<font color="blue">  - tokenURI(felt)</font>


## owner





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - owner(felt)</font>


## image_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - image_url_len(felt)</font>  
<font color="blue">  - image_url(felt)</font>


## image_data





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - image_data_len(felt)</font>  
<font color="blue">  - image_data(felt)</font>


## external_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - external_url_len(felt)</font>  
<font color="blue">  - external_url(felt)</font>


## description





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - description_len(felt)</font>  
<font color="blue">  - description(felt)</font>


## holder





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - holder_len(felt)</font>  
<font color="blue">  - holder(felt)</font>


## certifier





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - certifier_len(felt)</font>  
<font color="blue">  - certifier(felt)</font>


## land





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - land_len(felt)</font>  
<font color="blue">  - land(felt)</font>


## unit_land_surface





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - unit_land_surface_len(felt)</font>  
<font color="blue">  - unit_land_surface(felt)</font>


## country





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - country_len(felt)</font>  
<font color="blue">  - country(felt)</font>


## expiration





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - expiration_len(felt)</font>  
<font color="blue">  - expiration(felt)</font>


## total_co2_sequestration





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - total_co2_sequestration_len(felt)</font>  
<font color="blue">  - total_co2_sequestration(felt)</font>


## unit_co2_sequestration





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - unit_co2_sequestration_len(felt)</font>  
<font color="blue">  - unit_co2_sequestration(felt)</font>


## sequestration_color





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - sequestration_color_len(felt)</font>  
<font color="blue">  - sequestration_color(felt)</font>


## sequestration_type





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - sequestration_type_len(felt)</font>  
<font color="blue">  - sequestration_type(felt)</font>


## sequestration_category





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - sequestration_category_len(felt)</font>  
<font color="blue">  - sequestration_category(felt)</font>


## background_color





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - background_color_len(felt)</font>  
<font color="blue">  - background_color(felt)</font>


## animation_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - animation_url_len(felt)</font>  
<font color="blue">  - animation_url(felt)</font>


## youtube_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns
  
<font color="blue">  - youtube_url_len(felt)</font>  
<font color="blue">  - youtube_url(felt)</font>


## approve





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - to(felt)</font>  
<font color="orange">  - tokenId(Uint256)</font>


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



## transferFrom





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - from_(felt)</font>  
<font color="orange">  - to(felt)</font>  
<font color="orange">  - tokenId(Uint256)</font>


### returns



## safeTransferFrom





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## mint





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - to(felt)</font>  
<font color="orange">  - tokenId(Uint256)</font>


### returns



## burn





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - tokenId(Uint256)</font>


### returns



## setTokenURI





### implicitArgs
  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs
  
<font color="orange">  - tokenId(Uint256)</font>  
<font color="orange">  - tokenURI(felt)</font>


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



## set_image_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_image_data





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_external_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_description





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_holder





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_certifier





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_land





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_unit_land_surface





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_country





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_expiration





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_total_co2_sequestration





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_unit_co2_sequestration





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_sequestration_color





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_sequestration_type





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_sequestration_category





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_background_color





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_animation_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns



## set_youtube_url





### implicitArgs
  
<font color="green">  - syscall_ptr(felt*)</font>  
<font color="green">  - pedersen_ptr(HashBuiltin*)</font>  
<font color="green">  - bitwise_ptr(BitwiseBuiltin*)</font>  
<font color="green">  - range_check_ptr</font>


### explicitArgs



### returns


