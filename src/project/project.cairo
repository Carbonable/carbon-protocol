// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

// Project dependencies
from openzeppelin.access.accesscontrol.library import AccessControl
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.project.library import CarbonableProject
from src.utils.access.library import CarbonableAccessControl

//
// Initializer
//

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt, owner: felt, proxy_admin: felt
) {
    // Desc:
    //   Initialize the contract with the given name, symbol and owner -
    //   This constructor uses the standard OZ Proxy initializer,
    //   the standard OZ ERC721 initializer,
    //   the standard OZ ERC721Enumerable initializer and
    //   the OZ Ownable initializer
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   name(felt): Name of the collection
    //   symbol(felt): Symbol of the collection
    //   owner(felt): Owner address
    //   proxy_admin(felt): Admin address
    // Returns:
    //   None
    ERC721.initializer(name, symbol);
    ERC721Enumerable.initializer();
    Ownable.initializer(owner);
    CarbonableAccessControl.initializer();
    Proxy.initializer(proxy_admin);
    return ();
}

@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    // Desc:
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    // Explicit args:
    //   new_implementation(felt): new contract implementation
    // Raises:
    //   caller: caller is not a contract admin
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}

//
// Getters
//

@view
func totalSupply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
    totalSupply: Uint256
) {
    // Desc:
    //   Count NFTs tracked by this contract (EIP 721 - Enumeration extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   totalSupply(Uint256): A count of valid NFTs tracked by this contract, where each one of them has an assigned and queryable owner not equal to the zero address
    let (totalSupply: Uint256) = ERC721Enumerable.total_supply();
    return (totalSupply=totalSupply);
}

@view
func tokenByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    index: Uint256
) -> (tokenId: Uint256) {
    // Desc:
    //   Enumerate valid NFTs (EIP 721 - Enumeration extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   index(Uint256): A counter less than -totalSupply()-
    // Returns:
    //   tokenId(Uint256): The token identifier for the -index-th NFT (sort order not specified)
    // Raises:
    //   index: index ge than totalSupply
    let (tokenId: Uint256) = ERC721Enumerable.token_by_index(index);
    return (tokenId=tokenId);
}

@view
func tokenOfOwnerByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    owner: felt, index: Uint256
) -> (tokenId: Uint256) {
    // Desc:
    //   Enumerate NFTs assigned to an owner (EIP 721 - Enumeration extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   owner(felt): An address where we are interested in NFTs owned by them
    //   index(Uint256): A counter less than -balanceOf(owner)-
    // Returns:
    //   tokenId(Uint256): The token identifier for the -index-th NFT assigned to -owner- (sort order not specified)
    // Raises:
    //   index: index ge than balanceOf(owner)
    //   owner: owner is the zero address, representing invalid NFTs
    let (tokenId: Uint256) = ERC721Enumerable.token_of_owner_by_index(owner, index);
    return (tokenId=tokenId);
}

@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    // Desc:
    //   Return the ability status to support the provided interface (EIP 165)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   interfaceId(felt): Interface id
    // Returns:
    //   success(felt): 1 if supported else 0
    return ERC165.supports_interface(interfaceId);
}

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    // Desc:
    //   A descriptive name for a collection of NFTs in this contract (EIP 721 - Metadata extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   name(felt): The contract name
    return ERC721.name();
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    // Desc:
    //   An abbreviated name for NFTs in this contract (EIP 721 - Metadata extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   symbol(felt): The contract symbol
    return ERC721.symbol();
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    // Desc:
    //   Count all NFTs assigned to an owner (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   owner(felt): An address for whom to query the balance
    // Returns:
    //   balance(Uint256): The number of NFTs owned by -owner-, possibly zero
    // Raises:
    //   owner: owner is null address
    return ERC721.balance_of(owner);
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    // Desc:
    //   Find the owner of an NFT (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): The identifier for an NFT
    // Returns:
    //   owner(felt): The address of the owner of the NFT
    return ERC721.owner_of(tokenId);
}

@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (approved: felt) {
    // Desc:
    //   Get the approved address for a single NFT (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): The NFT to find the approved address for
    // Returns:
    //   approved(felt): The approved address for this NFT, or the zero address if there is none
    // Raises:
    //   tokenId: tokenId is not a valid NFT
    return ERC721.get_approved(tokenId);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (isApproved: felt) {
    // Desc:
    //   Query if an address is an authorized operator for another address (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   owner(felt): The address that owns the NFTs
    //   operator(felt): The address that acts on behalf of the owner
    // Returns:
    //   isApproved(felt): 1 if -operator- is an approved operator for -owner-, 0 otherwise
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved=isApproved);
}

@view
func tokenURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(tokenId: Uint256) -> (uri_len: felt, uri: felt*) {
    // Desc:
    //   A distinct Uniform Resource Identifier (URI) for a given asset (EIP 721 - Metadata extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): The NFT to find the URI for
    // Returns:
    //   uri_len(felt): URI array length
    //   uri(felt*): The URI characters associated to the specified NFT
    // Raises:
    //   tokenId: tokenId is not a valid Uint256
    let (uri_len: felt, uri: felt*) = CarbonableProject.token_uri(tokenId);
    return (uri_len=uri_len, uri=uri);
}

@view
func contractURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (uri_len: felt, uri: felt*) {
    // Desc:
    //   Return the contract uri (OpenSea)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Returns:
    //   uri_len(felt): URI array length
    //   uri(felt*): URI characters
    let (uri_len: felt, uri: felt*) = CarbonableProject.contract_uri();
    return (uri_len=uri_len, uri=uri);
}

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    // Desc:
    //   Return the contract owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   owner(felt): The owner address
    return Ownable.owner();
}

//
// Externals
//

@external
func set_minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(minter: felt) {
    Ownable.assert_only_owner();
    CarbonableAccessControl.set_minter(minter);
    return ();
}

@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    // Desc:
    //   Change or reaffirm the approved address for an NFT (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   to(felt): The new approved NFT controller
    //   tokenId(Uint256): The NFT to approve
    // Raises:
    //   caller: caller is not the current NFT owner, or an authorized operator of the current owner
    ERC721.approve(to, tokenId);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    // Desc:
    //   Enable or disable approval for a third party -operator- to manage all of -caller-s assets (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   operator(felt): Address to add to the set of authorized operators
    //   approved(felt): 1 if the operator is approved, 0 to revoke approval
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

@external
func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    // Desc:
    //   Transfer ownership of an NFT (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   from_(felt): The current owner of the NFT
    //   to(felt): The new owner
    //   tokenId(Uint256): The NFT to transfer
    // Raises:
    //   caller: caller is not the current owner or an authorized operator or the approved address for this NFT
    //   from_: from_ is not the current owner
    //   to: to is the zero address
    //   tokenId: tokenId is not a valid NFT
    ERC721Enumerable.transfer_from(from_, to, tokenId);
    return ();
}

@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    // Desc:
    //   Transfers the ownership of an NFT from one address to another address (EIP 721)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   from_(felt): The current owner of the NFT
    //   to(felt): The new owner
    //   tokenId(Uint256): The NFT to transfer
    //   data_len(felt): The data array length
    //   data(felt*): Additional data with no specified format sent in call to -to-
    // Raises:
    //   caller: caller is not the current owner or an authorized operator or the approved address for this NFT
    //   from_: from_ is not the current owner
    //   to: to is the zero address
    //   tokenId: tokenId is not a valid NFT
    //   to: to is not a contract account neither implements onERC721Received correctly
    ERC721Enumerable.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

@external
func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    // Desc:
    //   Mint the token id to the specified -to- address
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   to(felt): Target address
    //   tokenId(Uint256): Token id
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    //   to: to is the zero address
    //   tokenId: tokenId is not a valid Uint256
    //   tokenId: token already minted
    CarbonableAccessControl.assert_only_minter();
    ERC721Enumerable._mint(to, tokenId);
    return ();
}

@external
func burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(tokenId: Uint256) {
    // Desc:
    //   Burn the specified token
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): Token id
    // Returns:
    //   None
    // Raises:
    //   tokenId: tokenId is not a valid Uint256
    ERC721.assert_only_token_owner(tokenId);
    ERC721Enumerable._burn(tokenId);
    return ();
}

@external
func setTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256, tokenURI: felt
) {
    // Desc:
    //   Set the token URI of the specified token id (EIP 721 - Metadata extension) -
    //   This function is deprecated since the token uri is generated by the contract according
    //   to the token id by default (see the setURI function instead)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): Token id
    //   tokenURI(felt): The URI to set
    // Raises:
    //   tokenId: tokenId does not exist
    Ownable.assert_only_owner();
    // ERC721._set_token_uri(tokenId, tokenURI);
    return ();
}

@external
func setURI{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(uri_len: felt, uri: felt*) {
    // Desc:
    //   Set the contract base URI
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   bitwise_ptr(BitwiseBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   uri_len(felt): URI array length
    //   uri(felt*): URI characters
    Ownable.assert_only_owner();
    CarbonableProject.set_uri(uri_len, uri);
    return ();
}

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    // Desc:
    //   Transfer ownership to a new owner
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   newOwner(felt): Address of the new owner
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    //   newOwner: new owner is the zero address
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Desc:
    //   Renounce ownership
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Returns:
    //   None
    // Raises:
    //   caller: caller is not the contract owner
    Ownable.renounce_ownership();
    return ();
}
