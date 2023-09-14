#!/bin/bash
source ../.env

OWNER=0x063675fa1ecea10063722e61557ed7f49ed2503d6cdd74f4b31e9770b473650c

# build the solution
build() {
    scarb build
}

# declare the project
declare() {
    output=$(starkli declare ../target/dev/protocol_Project.sierra.json --keystore-password $KEYSTORE_PASSWORD 2>&1)
    address=$(echo "$output" | grep -oP '0x[0-9a-fA-F]+')
    echo $address
}

# deploy the project
# $1 - Name
# $2 - Symbol
# $3 - Decimals
# $4 - Owner
deploy() {
    class_hash=$(declare)
    output=$(starkli deploy $class_hash str:$1 str:$2 $3 $OWNER --keystore-password $KEYSTORE_PASSWORD 2>&1)
    address=$(echo "$output" | grep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    echo $address
}
contract_address=$(deploy $1 $2 $3)
echo $contract_address