#!/bin/bash
source ../.env

SIERRA_FILE=../target/dev/carbon_Yielder.sierra.json
PROJECT=0x04b9f63c40668305ff651677f97424921bcd1b781aafa66d1b4948a87f056d0d
SLOT=1
ERC20=0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426
OWNER=0x05bB7458b87FaaA41303A69B771ae26235F28b79aBD5FA1C451C43461DFE1438
TIMES="2 1688189600 1719792000"
PRICE="2 u256:22 u256:45"

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
# $3 - ERC20
# $3 - Owner
deploy() {
    class_hash=$(declare | tail -n 1)

    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" "$ERC20" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
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

    output=$(starkli invoke $contract set_prices $TIMES $PRICE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    echo $contract
}

contract_address=$(setup)
echo $contract_address