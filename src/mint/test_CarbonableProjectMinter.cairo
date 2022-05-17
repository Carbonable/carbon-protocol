%lang starknet

from interfaces.ICarbonableMinter import ICarbonableMinter

const PROJECT_NFT_ADDRESS = 0x056d4ffea4ca664ffe1256af4b029998014471a87dec8036747a927ab3320b46

@external
func test_deploy{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    tempvar project_nft_address = PROJECT_NFT_ADDRESS

    local minter_address : felt
    %{
        ids.minter_address = deploy_contract(
            "./src/mint/CarbonableMinter.cairo",
            [
                1, # Owner,
                ids.project_nft_address, # Project NFT contract address
            ]
        ).contract_address
    %}
    return ()
end
