#!/bin/bash
source ../.env

SIERRA_FILE=../target/dev/carbon_Yielder.sierra.json
PROJECT=0x0448922595c703bde016aa4726d7e04c87517d756b5866d9e93b8711944932d9
SLOT=1
ERC20=0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426
OWNER=0x063675fa1ecea10063722e61557ed7f49ed2503d6cdd74f4b31e9770b473650c

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

contract_address=$(deploy)
echo $contract_address