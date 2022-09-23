#!/bin/bash

### CONSTANTS
SCRIPT_DIR=`readlink -f $0 | xargs dirname`
ROOT=`readlink -f $SCRIPT_DIR/..`
STARKNET_ACCOUNTS_FILE=$HOME/.starknet_accounts/starknet_open_zeppelin_accounts.json
PROTOSTAR_TOML_FILE=$ROOT/protostar.toml

### FUNCTIONS
. $SCRIPT_DIR/library.sh # Logging utilities

### RAW INPUTS
PROFILE="testnet"
BADGE_CONTRACT=0x00e3f53dd77369d98903828488de01d60a8e118cfc2e007d663aea6111da44ef
RECIPIENT_FILE=$ROOT/scripts/configs/recipients.txt
TOKEN_ID=0
AMOUNT=1

### SETTINGS
CONFIG_FILE=$ROOT/scripts/configs/$PROFILE.config
[ -f $CONFIG_FILE ] && source $CONFIG_FILE || exit_error "$CONFIG_FILE file not found"

[ -z $ADMIN_ADDRESS ] && ADMIN_ADDRESS=`get_account_address $ACCOUNT $STARKNET_ACCOUNTS_FILE`
[ -z $ADMIN_ADDRESS ] && exit_error "Unable to determine account address"

[[ -z $NETWORK && ! -z $PROFILE ]] && NETWORK=`get_network $PROFILE $PROTOSTAR_TOML_FILE`
[ -z $NETWORK ] && exit_error "Unable to determine network"

### PRE_CONDITIONS
check_wallet
check_starknet

### LAST CHECK
print Profile: $PROFILE
print Account alias: $ACCOUNT
print Admin address: $ADMIN_ADDRESS
print Network: $NETWORK
print Badge contract: $BADGE_CONTRACT
print Recipients: $RECIPIENT_FILE
print Token ID: $TOKEN_ID
print AMOUNT: $AMOUNT
ask "Are you OK to airdrop with those parameters" || return

### AIRDROP
token_id=$(felt_to_uint256 $TOKEN_ID)
amount=$(felt_to_uint256 $AMOUNT)
data_len=1
data=0
for to in $(cat $RECIPIENT_FILE); do
    log_info "Mint $AMOUNT token (id=$TOKEN_ID) to $to"
    send_transaction "starknet invoke --address $BADGE_CONTRACT --abi ./build/CarbonableBadge_abi.json --function mint --inputs $to $token_id $amount $data_len $data --network $NETWORK --account $ACCOUNT --wallet $WALLET" "$NETWORK" || exit_error
done

exit_success