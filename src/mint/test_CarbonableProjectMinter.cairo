%lang starknet

from starkware.cairo.common.uint256 import Uint256

from interfaces.ICarbonableMinter import ICarbonableMinter

const PROJECT_NFT_ADDRESS = 0x056d4ffea4ca664ffe1256af4b029998014471a87dec8036747a927ab3320b46
const PAYMENT_TOKEN_ADDRESS = 0x073314940630fd6dcda0d772d4c972c4e0a9946bef9dabf4ef84eda8ef542b82

@external
func test_buy_nominal_case{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_address = PROJECT_NFT_ADDRESS
    tempvar payment_token_address = PAYMENT_TOKEN_ADDRESS

    local minter_address : felt
    %{
        ids.minter_address = deploy_contract(
            "./src/mint/CarbonableMinter.cairo",
            [
                1, # Owner,
                ids.project_nft_address, # Project NFT contract address
                ids.payment_token_address, # Payment ERC20 token address
                1, # Is whitelisted sale open
                1, # Is public sale open
                5, # Max buy per transaction
                100, 0, # Unit price
                10, 0 # Max supply for mint
            ]
        ).contract_address
    %}
    %{ mock_call(ids.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.payment_token_address, "transferFrom", [1]) %}
    let quantity = Uint256(2, 0)
    ICarbonableMinter.buy(minter_address, quantity)
    return ()
end

@external
func test_buy_revert_not_enough_nfts_available{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_address = PROJECT_NFT_ADDRESS
    tempvar payment_token_address = PAYMENT_TOKEN_ADDRESS

    local minter_address : felt
    %{
        ids.minter_address = deploy_contract(
            "./src/mint/CarbonableMinter.cairo",
            [
                1, # Owner,
                ids.project_nft_address, # Project NFT contract address
                ids.payment_token_address, # Payment ERC20 token address
                1, # Is whitelisted sale open
                1, # Is public sale open
                5, # Max buy per transaction
                100, 0, # Unit price
                10, 0 # Max supply for mint
            ]
        ).contract_address
    %}
    %{ mock_call(ids.project_nft_address, "totalSupply", [10, 0]) %}
    %{ mock_call(ids.payment_token_address, "transferFrom", [1]) %}
    let quantity = Uint256(2, 0)
    %{ expect_revert(error_message="CarbonableMinter: not enough available NFTs") %}
    ICarbonableMinter.buy(minter_address, quantity)
    return ()
end

@external
func test_buy_revert_transfer_failed{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_address = PROJECT_NFT_ADDRESS
    tempvar payment_token_address = PAYMENT_TOKEN_ADDRESS

    local minter_address : felt
    %{
        ids.minter_address = deploy_contract(
            "./src/mint/CarbonableMinter.cairo",
            [
                1, # Owner,
                ids.project_nft_address, # Project NFT contract address
                ids.payment_token_address, # Payment ERC20 token address
                1, # Is whitelisted sale open
                1, # Is public sale open
                5, # Max buy per transaction
                100, 0, # Unit price
                10, 0 # Max supply for mint
            ]
        ).contract_address
    %}
    %{ mock_call(ids.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.payment_token_address, "transferFrom", [0]) %}
    let quantity = Uint256(2, 0)
    %{ expect_revert(error_message="CarbonableMinter: transfer failed") %}
    ICarbonableMinter.buy(minter_address, quantity)
    return ()
end

@external
func test_buy_revert_mint_not_open{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_address = PROJECT_NFT_ADDRESS
    tempvar payment_token_address = PAYMENT_TOKEN_ADDRESS

    local minter_address : felt
    %{
        ids.minter_address = deploy_contract(
            "./src/mint/CarbonableMinter.cairo",
            [
                1, # Owner,
                ids.project_nft_address, # Project NFT contract address
                ids.payment_token_address, # Payment ERC20 token address
                0, # Is whitelisted sale open
                0, # Is public sale open
                5, # Max buy per transaction
                100, 0, # Unit price
                10, 0 # Max supply for mint
            ]
        ).contract_address
    %}
    %{ mock_call(ids.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.payment_token_address, "transferFrom", [1]) %}
    let quantity = Uint256(2, 0)
    %{ expect_revert(error_message="CarbonableMinter: mint is not open") %}
    ICarbonableMinter.buy(minter_address, quantity)
    return ()
end

@external
func test_buy_revert_not_whitelisted{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_address = PROJECT_NFT_ADDRESS
    tempvar payment_token_address = PAYMENT_TOKEN_ADDRESS

    local minter_address : felt
    %{
        ids.minter_address = deploy_contract(
            "./src/mint/CarbonableMinter.cairo",
            [
                1, # Owner,
                ids.project_nft_address, # Project NFT contract address
                ids.payment_token_address, # Payment ERC20 token address
                1, # Is whitelisted sale open
                0, # Is public sale open
                5, # Max buy per transaction
                100, 0, # Unit price
                10, 0 # Max supply for mint
            ]
        ).contract_address
    %}
    %{ mock_call(ids.project_nft_address, "totalSupply", [5, 0]) %}
    %{ mock_call(ids.payment_token_address, "transferFrom", [1]) %}
    let quantity = Uint256(2, 0)
    %{ expect_revert(error_message="CarbonableMinter: no whitelisted slot available") %}
    ICarbonableMinter.buy(minter_address, quantity)
    return ()
end
