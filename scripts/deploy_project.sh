#!/bin/bash

### CONSTANTS
SCRIPT_DIR=`readlink -f $0 | xargs dirname`
ROOT=`readlink -f $SCRIPT_DIR/..`
CACHE_FILE=$ROOT/build/deployed_contracts.txt
STARKNET_ACCOUNTS_FILE=$HOME/.starknet_accounts/starknet_open_zeppelin_accounts.json
PROTOSTAR_TOML_FILE=$ROOT/protostar.toml
NETWORK=

### FUNCTIONS
. $SCRIPT_DIR/library.sh # Logging utilities

# print the script usage
usage() {
    print "$0 [-a ACCOUNT_ADDRESS] [-p PROFILE] [-n NETWORK] [-x ADMIN_ADDRESS] [-w WALLET]"
}

# build the protostar project
build() {
    log_info "Building project to generate latest version of the ABI"
    execute protostar build
    if [ $? -ne 0 ]; then exit_error "Problem during build"; fi
}

# Deploy all contracts and log the deployed addresses in the cache file
deploy_all_contracts() {
    [ -f $CACHE_FILE ] && {
        source $CACHE_FILE
        log_info "Found those deployed accounts:"
        cat $CACHE_FILE
        ask "Do you want to deploy missing contracts and initialize them" || return 
    }

    print Profile: $PROFILE
    print Account alias: $ACCOUNT
    print Admin address: $ADMIN_ADDRESS
    print Network: $NETWORK

    ask "Are you OK to deploy with those parameters" || return 

    [ ! -z $PROFILE ] && PROFILE_OPT="--profile $PROFILE"

    # Deploy ERC-721 token contract
    if [ -z $ERC721_ADDRESS ]; then
        erc721_name=$(str_to_hex "$ERC721_NAME")
        erc721_symbol=$(str_to_hex "$ERC721_SYMBOL")
        log_info "Deploying ERC-721 contract..."
        ERC721_ADDRESS=`send_transaction "protostar $PROFILE_OPT deploy ./build/CarbonableProject.json --inputs $erc721_name $erc721_symbol $ADMIN_ADDRESS" "$NETWORK"` || exit_error
    fi

    # Deploy Minter contract
    if [ -z $MINTER_ADDRESS ]; then
        owner=$ADMIN_ADDRESS
        project_nft_address=$ERC721_ADDRESS
        log_info "Deploying Minter contract..."
        MINTER_ADDRESS=`send_transaction "protostar $PROFILE_OPT deploy ./build/CarbonableMinter.json --inputs $owner $project_nft_address $PAYMENT_TOKEN_ADDRESS $PUBLIC_SALE_OPEN $MAX_BUY_PER_TX $UNIT_PRICE $MAX_SUPPLY_FOR_MINT $RESERVED_SUPPLY_FOR_MINT" "$NETWORK"` || exit_error
        # Transfer ownership
        log_info "Transfer ERC-721 contract ownership..."
        ERC721_ADDRESS=`send_transaction "starknet invoke --address $ERC721_ADDRESS --abi ./build/CarbonableProject_abi.json --function transferOwnership --inputs $MINTER_ADDRESS --network $NETWORK --account $ACCOUNT --wallet $WALLET" "$NETWORK"` || exit_error
        # Set uri
        erc721_len=${#ERC721_URI}
        erc721_uri=$(str_to_hexs "$ERC721_URI")
        log_info "Set ERC-721 contract uri..."
        ERC721_ADDRESS=`send_transaction "starknet invoke --address $ERC721_ADDRESS --abi ./build/CarbonableProject_abi.json --function setURI --inputs $erc721_len $erc721_uri --network $NETWORK --account $ACCOUNT --wallet $WALLET" "$NETWORK"` || exit_error
    fi    

    # Save values in cache file
    (
        echo "ERC721_ADDRESS=$ERC721_ADDRESS"
        echo "MINTER_ADDRESS=$MINTER_ADDRESS"
    ) | tee >&2 $CACHE_FILE
}

### ARGUMENT PARSING
while getopts a:p:h option
do
    case "${option}"
    in
        a) ACCOUNT=${OPTARG};;
        x) ADMIN_ADDRESS=${OPTARG};;
        p) PROFILE=${OPTARG};;
        n) NETWORK=${OPTARG};;
        w) WALLET=${OPTARG};;
        h) usage; exit_success;;
        \?) usage; exit_error;;
    esac
done

CONFIG_FILE=$ROOT/scripts/configs/$PROFILE.config
[ -f $CONFIG_FILE ] && source $CONFIG_FILE || exit_error "$CONFIG_FILE file not found"

[ -z $ADMIN_ADDRESS ] && ADMIN_ADDRESS=`get_account_address $ACCOUNT $STARKNET_ACCOUNTS_FILE`
[ -z $ADMIN_ADDRESS ] && exit_error "Unable to determine account address"

[[ -z $NETWORK && ! -z $PROFILE ]] && NETWORK=`get_network $PROFILE $PROTOSTAR_TOML_FILE`
[ -z $NETWORK ] && exit_error "Unable to determine network"

### PRE_CONDITIONS
check_wallet
check_starknet

### BUSINESS LOGIC

# build # Need to generate ABI and compiled contracts
deploy_all_contracts

exit_success