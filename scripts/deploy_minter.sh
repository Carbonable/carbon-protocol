#!/bin/bash
source ../.env

SIERRA_FILE=../target/dev/carbon_Minter.sierra.json
PROJECT=0x050da7d4a7815efafaa8b731b30b8b0abdad519a7626f52c602f5ec4b3c4d2ad
SLOT=1
ERC20=0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426
PUBLIC_SALE_OPEN=0
MIN_VALUE_PER_TX=1
MAX_VALUE_PER_TX=5
MAX_VALUE=100
UNIT_PRICE=1
RESERVED_VALUE=10
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
# $4 - Public Sale Open
# $5 - Min Value Per Tx
# $6 - Max Value Per Tx
# $7 - Max Value
# $8 - Unit Price
# $9 - Reserved Value
# $10 - Owner
deploy() {
    class_hash=$(declare | tail -n 1)
    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" "$ERC20" "$PUBLIC_SALE_OPEN" u256:"$MAX_VALUE_PER_TX" u256:"$MIN_VALUE_PER_TX" u256:"$MAX_VALUE" u256:"$UNIT_PRICE" u256:"$RESERVED_VALUE" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    address=$(echo "$output" | grep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    echo $address
}

setup() {
    contract=$(deploy)
    output=$(starkli invoke $PROJECT add_minter u256:$SLOT $contract --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    echo $contract
}

contract_address=$(setup)
echo $contract_address