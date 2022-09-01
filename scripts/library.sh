#!/bin/bash

# get the account address from the account alias in protostar accounts file
# $1 - account alias
# $2 - starknet account file
get_account_address() {
    account=$1
    starknet_account_file=$2
    grep $account $starknet_account_file -A3 -m1 | sed -n 's@^.*"address": "\(.*\)".*$@\1@p'
}

# get the network from the profile in protostar config file
# $1 - profile
# $2 - protostar toml file
get_network() {
    profile=$1
    protostar_toml_file=$2
    grep profile.$profile $protostar_toml_file -A3 -m1 | sed -n 's@^.*[network=|gateway_url=]"\(.*\)".*$@\1@p'
}

# wait for a transaction to be received
# $1 - transaction hash to check
wait_for_acceptance() {
    tx_hash=$1
    if [[ "$tx_hash" != *"0x"* ]]; then
        tx_hash=$(felt_to_hex "$1")
    fi
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
    hex_bytes=0x$(echo $hex_bytes | rev | cut -c3- | rev)
    echo $hex_bytes
}

# convert hex to felt
# $1 - hex value
hex_to_felt() {
    hex_upper=`echo ${1//0x/} | tr '[:lower:]' '[:upper:]'`
    echo "obase=10; ibase=16; $hex_upper" | BC_LINE_LENGTH=0 bc
}

# convert felt to hex
# $1 - felt value
felt_to_hex() {
    felt=`echo "obase=16; ibase=10; $1" | BC_LINE_LENGTH=0 bc`
    echo 0x$felt
}