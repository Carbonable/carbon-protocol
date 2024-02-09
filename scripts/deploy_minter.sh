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
PROJECT=0x00130b5a3035eef0470cff2f9a450a7a6856a3c5a4ea3f5b7886c2d03a50d2bf
SLOT=4
ERC20=0x075b439cc965cea7e5ac09d7cf15043ad8fe15447423a51bbcb789f8ec659d8c
PUBLIC_SALE_OPEN=1
MIN_VALUE_PER_TX=1000000
MAX_VALUE_PER_TX=5000000000
MAX_VALUE=1669306640000
UNIT_PRICE=1
RESERVED_VALUE=0
OWNER=0x01e2F67d8132831f210E19c5Ee0197aA134308e16F7f284bBa2c72E28FC464D2

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
        printf "deploy %s %s %s %s %s %s %s %s %s %s %s \n" "$class_hash" "$PROJECT" "$SLOT" "$ERC20" "$PUBLIC_SALE_OPEN" "$MIN_VALUE_PER_TX" "$MAX_VALUE_PER_TX" "$MAX_VALUE" "$UNIT_PRICE" "$RESERVED_VALUE" "$OWNER" >> debug_minter.log
    fi
    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" "$ERC20" "$PUBLIC_SALE_OPEN" u256:"$MAX_VALUE_PER_TX" u256:"$MIN_VALUE_PER_TX" u256:"$MAX_VALUE" u256:"$UNIT_PRICE" u256:"$RESERVED_VALUE" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

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