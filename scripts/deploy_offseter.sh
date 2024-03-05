#!/bin/bash
source ../.env
# Check if --debug parameter is passed
debug=0

TEMP=$(getopt -o d --long debug -- "$@")

eval set -- "$TEMP"

while true ; do
    case "$1" in          
        -d|--debug)
            debug=1 ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

SIERRA_FILE=../target/dev/carbon_Offseter.sierra.json
PROJECT=0x014c6533fec6fd168189b49150907db533e8be3a2e69b0657ae4ec6459a94668
SLOT=1
MIN_CLAIMABLE=1000000
OWNER=0x5bb7458b87faaa41303a69b771ae26235f28b79abd5fa1c451c43461dfe1438

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
    if [ $debug -eq 1 ]; then
        printf "declare %s\n" "$SIERRA_FILE" > debug_offseter.log
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
# $3 - Min Claimable
# $4 - Owner
deploy() {
    class_hash=$(declare)
    if [ $debug -eq 1 ]; then
        printf "deploy %s %s %s %s %s \n" "$class_hash" "$PROJECT" "$SLOT" "$MIN_CLAIMABLE" "$OWNER" >> debug_offseter.log
    fi
    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" u256:"$MIN_CLAIMABLE" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    
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

contract_address=$(deploy)
echo $contract_address