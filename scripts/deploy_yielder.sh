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

SIERRA_FILE=../target/dev/carbon_Yielder.sierra.json
PROJECT=0x014c6533fec6fd168189b49150907db533e8be3a2e69b0657ae4ec6459a94668
SLOT=1
ERC20=0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426
OWNER=0x5bb7458b87faaa41303a69b771ae26235f28b79abd5fa1c451c43461dfe1438
TIMES="2 1717581600 1720605600"
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

    if [ $debug -eq 1 ]; then
        printf "declare %s\n" "$SIERRA_FILE" > debug_yielder.log
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
# $3 - Owner
deploy() {
    class_hash=$(declare)

    if [ $debug -eq 1 ]; then
        printf "deploy %s %s %s %s %s \n" "$class_hash" "$PROJECT" "$SLOT" "$ERC20" "$OWNER" >> debug_yielder.log
    fi
    output=$(starkli deploy $class_hash "$PROJECT" u256:"$SLOT" "$ERC20" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
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

    if [ $debug -eq 1 ]; then
        printf "invoke %s set_prices %s %s \n" "$contract" "$TIMES" "$PRICE" >> debug_yielder.log
    fi
    output=$(starkli invoke $contract set_prices $TIMES $PRICE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo "Error: $output"
        exit 1
    fi

    echo $contract
}

contract_address=$(setup)
echo $contract_address