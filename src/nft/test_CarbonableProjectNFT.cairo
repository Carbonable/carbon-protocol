%lang starknet

@external
func test_deploy{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals

    local project_nft_address : felt
    %{
        ids.project_nft_address = deploy_contract(
            "./src/nft/CarbonableProjectNFT.cairo",
            [
                1, # Name
                2, # Symbol
                3, # Owner
            ]
        ).contract_address
    %}
    
    return ()
end
