#!/bin/bash
source ../.env

SIERRA_FILE=../target/dev/carbon_Offseter.sierra.json
PROJECT=0x007afb15db3fb57839fec89c20754eb59f8d7e3f87d953ee68b0a99b6f527b3e
SLOT=1
MIN_CLAIMABLE=1
OWNER=0x05bB7458b87FaaA41303A69B771ae26235F28b79aBD5FA1C451C43461DFE1438

# build the contract
build() {
    output=$(scarb build 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi
}

# declare the contract
declare() {
    build
    output=$(starkli declare $SIERRA_FILE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    address=$(echo "$output" | grep -oP '0x[0-9a-fA-F]+')
    echo $address
}

# deploy the contract
# $1 - Project
# $2 - Slot
# $3 - Min Claimable
# $4 - Owner
deploy() {
    class_hash=$(declare | tail -n 1)
    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" u256:"$MIN_CLAIMABLE" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    
    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    address=$(echo "$output" | grep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    echo $address
}

contract_address=$(deploy)
echo $contract_address