#!/bin/bash

### CONSTANTS
SCRIPT_DIR=`readlink -f $0 | xargs dirname`
ROOT=`readlink -f $SCRIPT_DIR/..`
CACHE_FILE=$ROOT/build/deployed_contracts.txt
STARKNET_ACCOUNTS_FILE=$HOME/.starknet_accounts/starknet_open_zeppelin_accounts.json
PROTOSTAR_TOML_FILE=$ROOT/protostar.toml
NETWORK=

### FUNCTIONS
. $SCRIPT_DIR/logging.sh # Logging utilities
. $SCRIPT_DIR/tools.sh   # script utilities

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

# get the account address from the account alias in protostar accounts file
# $1 - account alias (optional). __default__ if not provided
get_account_address() {
    [ $# -eq 0 ] && account=__default__ || account=$1
    grep $account $STARKNET_ACCOUNTS_FILE -A3 -m1 | sed -n 's@^.*"address": "\(.*\)".*$@\1@p'
}

# get the network from the profile in protostar config file
# $1 - profile
get_network() {
    profile=$1
    grep profile.$profile $PROTOSTAR_TOML_FILE -A3 -m1 | sed -n 's@^.*[network=|gateway_url=]"\(.*\)".*$@\1@p'
}

# check starknet binary presence
check_starknet() {
    which starknet &> /dev/null
    [ $? -ne 0 ] && exit_error "Unable to locate starknet binary. Did you activate your virtual env ?"
}

# make sure wallet variable is set
check_wallet() {
    [ -z $WALLET ] && exit_error "Please provide the wallet to use (option -w or environment variable STARKNET_WALLET)"
}

# wait for a transaction to be received
# $1 - transaction hash to check
wait_for_acceptance() {
    tx_hash=$1
    while true 
    do
        tx_status=`starknet tx_status --hash $tx_hash --network $NETWORK | sed -n 's@^.*"tx_status": "\(.*\)".*$@\1@p'`
        case "$tx_status"
            in
                NOT_RECEIVED|RECEIVED|PENDING) print -n  $(magenta .);;
                REJECTED) return 1;;
                ACCEPTED_ON_L1|ACCEPTED_ON_L2) return 0; break;;
                *) exit_error "\nUnknown transaction status '$tx_status'";;
            esac
            sleep 2
    done
}

# convert an ASCII string to felt
# $1 - string value
str_to_felt() {
    str_val=$1
    hex_bytes=$(echo $str_val | xxd -p)
    hex_bytes=0x$(echo $hex_bytes | rev | cut -c2- | rev)
    echo $hex_bytes
}

# send a transaction
# $* - command line to execute
# return The contract address
send_transaction() {
    transaction=$*

    while true
    do
        execute $transaction || exit_error "Error when sending transaction"
        
        contract_address=`sed -n 's@Contract address: \(.*\)@\1@p' logs.json`
        tx_hash=`sed -n 's@Transaction hash: \(.*\)@\1@p' logs.json`

        [ $PROFILE != "devnet" ] && wait_for_acceptance $tx_hash || print "Acceptance skipped in $PROFILE profile"

        case $? in
            0) log_success "\nTransaction accepted!"; break;;
            1) log_warning "\nTransaction rejected!"; ask "Do you want to retry";;
        esac
    done || exit_error

    echo $contract_address
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
        erc721_name=$(str_to_felt "$ERC721_NAME")
        erc721_symbol=$(str_to_felt "$ERC721_SYMBOL")
        log_info "Deploying ERC-721 contract..."
        ERC721_ADDRESS=`send_transaction "protostar $PROFILE_OPT deploy ./build/CarbonableProjectNFT.json --inputs $erc721_name $erc721_symbol $ADMIN_ADDRESS"` || exit_error
    fi

    # Deploy Minter contract
    if [ -z $MINTER_ADDRESS ]; then
        owner=$ADMIN_ADDRESS
        project_nft_address=$ERC721_ADDRESS
        log_info "Deploying Minter contract..."
        MINTER_ADDRESS=`send_transaction "protostar $PROFILE_OPT deploy ./build/CarbonableMinter.json --inputs $owner $project_nft_address $PAYMENT_TOKEN_ADDRESS $PUBLIC_SALE_OPEN $MAX_BUY_PER_TX $UNIT_PRICE $MAX_SUPPLY_FOR_MINT $RESERVED_SUPPLY_FOR_MINT"` || exit_error
    fi    

    # Save values in cache file
    (
        echo "MINTER_ADDRESS=$MINTER_ADDRESS"
        echo "ERC721_ADDRESS=$ERC721_ADDRESS"
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

WALLET=$STARKNET_WALLET

[ -z $ADMIN_ADDRESS ] && ADMIN_ADDRESS=`get_account_address $ACCOUNT`
[ -z $ADMIN_ADDRESS ] && exit_error "Unable to determine account address"

[[ -z $NETWORK && ! -z $PROFILE ]] && NETWORK=`get_network $PROFILE`
[ -z $NETWORK ] && exit_error "Unable to determine network"

### PRE_CONDITIONS
check_starknet
check_wallet

### BUSINESS LOGIC

build # Need to generate ABI and compiled contracts
deploy_all_contracts

exit_success