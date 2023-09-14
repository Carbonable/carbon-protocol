#!/bin/bash
source ../.env

SIERRA_FILE=../target/dev/carbon_Project.sierra.json
NAME=Carbonable
SYMBOL="CARBON"
DECIMALS=6
OWNER=0x063675fa1ecea10063722e61557ed7f49ed2503d6cdd74f4b31e9770b473650c
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