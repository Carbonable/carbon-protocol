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

SIERRA_FILE=../target/dev/carbon_Project.sierra.json
NAME=0x436172626f6e5f54657374
SYMBOL="CARBT"
DECIMALS=6
OWNER=0x01e2F67d8132831f210E19c5Ee0197aA134308e16F7f284bBa2c72E28FC464D2
SLOT=1
PROJECT_VALUE=17600000000
TIMES="24 1667314458 1698850458 1730472858 1762008858 1793544858 1825080858 1856703258 1888239258 1919775258 1951311258 1982933658 2046005658 2109164058 2172236058 2235394458 2266930458 2330002458 2361624858 2393160858 2424696858 2456232858 2487855258 2582463258 2614085658"
ABSORPTIONS=" 24 0 4719000 12584000 25168000 40898000 64493000 100672000 147862000 202917000 265837000 333476000 478192000 629200000 773916000 915486000 983125000 1108965000 1164020000 1223794000 1280422000 1335477000 1387386000 1528956000 1573000000"
TON_EQUIVALENT=1000000

# build the solution
build() {
    output=$(scarb build 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi
}

# declare the contract
declare() {
    build
    if [[ $debug == "true" ]]; then
        printf "declare %s\n" "$SIERRA_FILE" > debug_project.log
    fi
    output=$(starkli declare $SIERRA_FILE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi

    # Check if ggrep is available
    if command -v ggrep >/dev/null 2>&1; then
        address=$(echo -e "$output" | ggrep -oP '0x[0-9a-fA-F]+')
    else
        # If ggrep is not available, use grep
        address=$(echo -e "$output" | grep -oP '0x[0-9a-fA-F]\+')
    fi
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
    
    if [[ $debug == "true" ]]; then
        printf "deploy %s %s %s %s %s \n" "$class_hash" "$NAME" "$SYMBOL" "$DECIMALS" "$OWNER" >> debug_project.log
    fi

    output=$(starkli deploy $class_hash "$NAME" str:"$SYMBOL" "$DECIMALS" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
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
        printf "invoke %s set_project_value %s %s \n" "$contract" "$SLOT" "$PROJECT_VALUE" >> debug_project.log
    fi

    output=$(starkli invoke $contract set_project_value u256:$SLOT u256:$PROJECT_VALUE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi

    if [[ $debug == "true" ]]; then
        printf "invoke %s set_certifier %s %s \n" "$contract" "$SLOT" "$OWNER" >> debug_project.log
    fi

    output=$(starkli invoke $contract set_certifier u256:$SLOT $OWNER --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi

    if [[ $debug == "true" ]]; then
        printf "invoke %s set_absorptions u256:%s %s %s %s \n" "$contract" "$SLOT" "$TIMES" "$ABSORPTIONS" "$TON_EQUIVALENT" >> debug_project.log
    fi

    output=$(starkli invoke $contract set_absorptions u256:$SLOT $TIMES $ABSORPTIONS $TON_EQUIVALENT --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)
    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi

    echo $contract
}

contract_address=$(setup)
echo $contract_address