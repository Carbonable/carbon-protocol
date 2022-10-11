// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Project dependencies
from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable

// Local dependencies
from src.project.library import CarbonableProject

//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt, owner: felt
) {
    // Desc:
    //   Initialize the contract with the given name, symbol and owner -
    //   This constructor uses the standard OZ ERC721 initializer,
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
    // Returns:
    //   None
    ERC721.initializer(name, symbol);
    ERC721Enumerable.initializer();
    Ownable.initializer(owner);
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
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (tokenURI: felt) {
    // Desc:
    //   A distinct Uniform Resource Identifier (URI) for a given asset (EIP 721 - Metadata extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): The NFT to find the URI for
    // Returns:
    //   tokenURI(felt): The URI associated to the specified NFT
    // Raises:
    //   tokenId: tokenId is not a valid NFT
    let (tokenURI: felt) = ERC721.token_uri(tokenId);
    return (tokenURI=tokenURI);
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

@view
func image_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (image_url_len: felt, image_url: felt*) {
    return CarbonableProject.image_url();
}

@view
func image_data{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (image_data_len: felt, image_data: felt*) {
    return CarbonableProject.image_data();
}

@view
func external_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (external_url_len: felt, external_url: felt*) {
    return CarbonableProject.external_url();
}

@view
func description{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (description_len: felt, description: felt*) {
    return CarbonableProject.description();
}

@view
func holder{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (holder_len: felt, holder: felt*) {
    return CarbonableProject.holder();
}

@view
func certifier{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (certifier_len: felt, certifier: felt*) {
    return CarbonableProject.certifier();
}

@view
func land{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (land_len: felt, land: felt*) {
    return CarbonableProject.land();
}

@view
func unit_land_surface{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (unit_land_surface_len: felt, unit_land_surface: felt*) {
    return CarbonableProject.unit_land_surface();
}

@view
func country{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (country_len: felt, country: felt*) {
    return CarbonableProject.country();
}

@view
func expiration{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (expiration_len: felt, expiration: felt*) {
    return CarbonableProject.expiration();
}

@view
func total_co2_sequestration{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (total_co2_sequestration_len: felt, total_co2_sequestration: felt*) {
    return CarbonableProject.total_co2_sequestration();
}

@view
func unit_co2_sequestration{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (unit_co2_sequestration_len: felt, unit_co2_sequestration: felt*) {
    return CarbonableProject.unit_co2_sequestration();
}

@view
func sequestration_color{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (sequestration_color_len: felt, sequestration_color: felt*) {
    return CarbonableProject.sequestration_color();
}

@view
func sequestration_type{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (sequestration_type_len: felt, sequestration_type: felt*) {
    return CarbonableProject.sequestration_type();
}

@view
func sequestration_category{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (sequestration_category_len: felt, sequestration_category: felt*) {
    return CarbonableProject.sequestration_category();
}

@view
func background_color{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (background_color_len: felt, background_color: felt*) {
    return CarbonableProject.background_color();
}

@view
func animation_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (animation_url_len: felt, animation_url: felt*) {
    return CarbonableProject.animation_url();
}

@view
func youtube_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() -> (youtube_url_len: felt, youtube_url: felt*) {
    return CarbonableProject.youtube_url();
}

//
// Externals
//

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
    Ownable.assert_only_owner();
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
    //   Set the token URI of the specified token id (EIP 721 - Metadata extension)
    // Implicit args:
    //   syscall_ptr(felt*)
    //   pedersen_ptr(HashBuiltin*)
    //   range_check_ptr
    // Explicit args:
    //   tokenId(Uint256): Token id
    //   tokenURI(felt): The Uri to set
    // Raises:
    //   tokenId: tokenId does not exist
    Ownable.assert_only_owner();
    ERC721._set_token_uri(tokenId, tokenURI);
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

@external
func set_image_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(image_url_len: felt, image_url: felt*) -> () {
    return CarbonableProject.set_image_url(image_url_len, image_url);
}

@external
func set_image_data{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(image_data_len: felt, image_data: felt*) -> () {
    return CarbonableProject.set_image_data(image_data_len, image_data);
}

@external
func set_external_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(external_url_len: felt, external_url: felt*) {
    return CarbonableProject.set_external_url(external_url_len, external_url);
}

@external
func set_description{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(description_len: felt, description: felt*) {
    return CarbonableProject.set_description(description_len, description);
}

@external
func set_holder{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(holder_len: felt, holder: felt*) {
    return CarbonableProject.set_holder(holder_len, holder);
}

@external
func set_certifier{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(certifier_len: felt, certifier: felt*) {
    return CarbonableProject.set_certifier(certifier_len, certifier);
}

@external
func set_land{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(land_len: felt, land: felt*) {
    return CarbonableProject.set_land(land_len, land);
}

@external
func set_unit_land_surface{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(unit_land_surface_len: felt, unit_land_surface: felt*) {
    return CarbonableProject.set_unit_land_surface(unit_land_surface_len, unit_land_surface);
}

@external
func set_country{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(country_len: felt, country: felt*) {
    return CarbonableProject.set_country(country_len, country);
}

@external
func set_expiration{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(expiration_len: felt, expiration: felt*) {
    return CarbonableProject.set_expiration(expiration_len, expiration);
}

@external
func set_total_co2_sequestration{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(total_co2_sequestration_len: felt, total_co2_sequestration: felt*) {
    return CarbonableProject.set_total_co2_sequestration(
        total_co2_sequestration_len, total_co2_sequestration
    );
}

@external
func set_unit_co2_sequestration{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(unit_co2_sequestration_len: felt, unit_co2_sequestration: felt*) {
    return CarbonableProject.set_unit_co2_sequestration(
        unit_co2_sequestration_len, unit_co2_sequestration
    );
}

@external
func set_sequestration_color{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(sequestration_color_len: felt, sequestration_color: felt*) {
    return CarbonableProject.set_sequestration_color(sequestration_color_len, sequestration_color);
}

@external
func set_sequestration_type{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(sequestration_type_len: felt, sequestration_type: felt*) {
    return CarbonableProject.set_sequestration_type(sequestration_type_len, sequestration_type);
}

@external
func set_sequestration_category{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(sequestration_category_len: felt, sequestration_category: felt*) {
    return CarbonableProject.set_sequestration_category(
        sequestration_category_len, sequestration_category
    );
}

@external
func set_background_color{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(background_color_len: felt, background_color: felt*) {
    return CarbonableProject.set_background_color(background_color_len, background_color);
}

@external
func set_animation_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(animation_url_len: felt, animation_url: felt*) {
    return CarbonableProject.set_animation_url(animation_url_len, animation_url);
}

@external
func set_youtube_url{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}(youtube_url_len: felt, youtube_url: felt*) {
    return CarbonableProject.set_youtube_url(youtube_url_len, youtube_url);
}
