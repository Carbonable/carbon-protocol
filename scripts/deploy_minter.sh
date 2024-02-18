#!/bin/bash
source ../.env
# Check if --debug parameter is passed
debug="false"
for arg in "$@"
do
    if [ "$arg" == "--debug" ]
    then
        debug="true"
    fi
done

SIERRA_FILE=../target/dev/carbon_Minter.sierra.json
PROJECT=0x007afb15db3fb57839fec89c20754eb59f8d7e3f87d953ee68b0a99b6f527b3e
SLOT=1
ERC20=0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426
PUBLIC_SALE_OPEN=0
ENABLE_MAX_PER_TX=0
MIN_VALUE_PER_TX=1000000
MAX_VALUE_PER_TX=5000000
MAX_VALUE=100000000
UNIT_PRICE=1
RESERVED_VALUE=10000000
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
    if [[ $debug == "true" ]]; then
        printf "declare %s\n" "$SIERRA_FILE" > debug_minter.log
    fi
    output=$(starkli declare $SIERRA_FILE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    # Check if ggrep is available
    if command -v ggrep >/dev/null 2>&1; then
        address=$(echo -e "$output" | ggrep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    else
        # If ggrep is not available, use grep
        address=$(echo -e "$output" | grep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    fi
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
    class_hash=$(declare)
    sleep 5    

    if [[ $debug == "true" ]]; then        
        printf "deploy %s %s %s %s %s %s %s %s %s %s %s %s \n" "$class_hash" "$PROJECT" "$SLOT" "$ERC20" "$PUBLIC_SALE_OPEN" "$ENABLE_MAX_PER_TX" "$MAX_VALUE_PER_TX" "$MIN_VALUE_PER_TX" "$MAX_VALUE" "$UNIT_PRICE" "$RESERVED_VALUE" "$OWNER" >> debug_minter.log
    fi
    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" "$ERC20" "$PUBLIC_SALE_OPEN" "$ENABLE_MAX_PER_TX" u256:"$MAX_VALUE_PER_TX" u256:"$MIN_VALUE_PER_TX" u256:"$MAX_VALUE" u256:"$UNIT_PRICE" u256:"$RESERVED_VALUE" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    # Check if ggrep is available
    if command -v ggrep >/dev/null 2>&1; then
        address=$(echo -e "$output" | ggrep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    else
        # If ggrep is not available, use grep
        address=$(echo -e "$output" | grep -oP '0x[0-9a-fA-F]+' | tail -n 1) 
    fi
    echo $address
}

setup() {
    contract=$(deploy)
    sleep 5

    if [[ $debug == "true" ]]; then
        printf "invoke %s add_minter %s %s \n" "$PROJECT" "$SLOT" "$contract" >> debug_minter.log
    fi
    output=$(starkli invoke $PROJECT add_minter u256:$SLOT $contract --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    echo $contract
}

contract_address=$(setup)
echo $contract_address