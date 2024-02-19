#!/bin/bash
source ../.env

# Check parameters
debug=0
old_network=0

TEMP=$(getopt -o dg --long goerli,debug -- "$@")

eval set -- "$TEMP"

while true ; do
    case "$1" in
        -g|--goerli)
            old_network=1 ; shift ;;            
        -d|--debug)
            debug=1 ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

SIERRA_FILE=../target/dev/carbon_Project.sierra.json
NAME="Carb_Var_Max_value"
SYMBOL="CARBT"
DECIMALS=6
OWNER=0x5bb7458b87faaa41303a69b771ae26235f28b79abd5fa1c451c43461dfe1438
SLOT=1
PROJECT_VALUE=2139004800000
TIMES="2 1717236000 2442996000"
ABSORPTIONS=" 2 0 410400000000"
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
    if [ $debug -eq 1 ]; then
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
        address=$(echo -e "$output" | grep -oP '0x[0-9a-fA-F]+')
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
    
    if [ $debug -eq 1 ]; then
        printf "deploy %s %s %s %s %s \n" "$class_hash" "$NAME" "$SYMBOL" "$DECIMALS" "$OWNER" >> debug_project.log
    fi

    output=$(starkli deploy $class_hash str:"$NAME" str:"$SYMBOL" "$DECIMALS" "$OWNER" --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

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

    if [ $debug -eq 1 ]; then
        printf "invoke %s set_project_value %s %s \n" "$contract" "$SLOT" "$PROJECT_VALUE" >> debug_project.log
    fi

    output=$(starkli invoke $contract set_project_value u256:$SLOT u256:$PROJECT_VALUE --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi

    if [ $debug -eq 1 ]; then
        printf "invoke %s set_certifier %s %s \n" "$contract" "$SLOT" "$OWNER" >> debug_project.log
    fi
    
    output=$(starkli invoke $contract set_certifier u256:$SLOT $OWNER --keystore-password $KEYSTORE_PASSWORD --watch 2>&1)

    if [[ $output == *"Error"* ]]; then
        echo -e "Error: $output"
        exit 1
    fi

    if [ $debug -eq 1 ]; then
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