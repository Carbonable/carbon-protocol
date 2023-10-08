#!/bin/bash
source ../.env

SIERRA_FILE=../target/dev/carbon_Project.sierra.json
NAME=0x436172626f6e5f54657374
SYMBOL="CARBT"
DECIMALS=6
OWNER=0x05bB7458b87FaaA41303A69B771ae26235F28b79aBD5FA1C451C43461DFE1438
SLOT=1
PROJECT_VALUE=100000000
TIMES="2 1688169600 1719792000"
ABSORPTIONS="2 0 2746197000000"
TON_EQUIVALENT=1000000

# build the solution
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
# $1 - Name
# $2 - Symbol
# $3 - Decimals
# $4 - Owner
deploy() {
    class_hash=$(declare | tail -n 1)
    sleep 5
    
    output=$(starkli deploy $class_hash str:"$NAME" str:"$SYMBOL" "$DECIMALS" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    address=$(echo "$output" | grep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    echo $address
}

setup() {
    contract=$(deploy)
    sleep 5

    output=$(starkli invoke $contract set_project_value u256:$SLOT u256:$PROJECT_VALUE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    output=$(starkli invoke $contract set_certifier u256:$SLOT $OWNER --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    output=$(starkli invoke $contract set_absorptions u256:$SLOT $TIMES $ABSORPTIONS $TON_EQUIVALENT --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    echo $contract
}

contract_address=$(setup)
echo $contract_address