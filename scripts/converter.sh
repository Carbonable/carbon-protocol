#!/bin/bash

# convert an ASCII string to felt
# $1 - string value
str_to_felt() {
    str_val=$1
    hex_bytes=$(echo $str_val | xxd -p)
    hex_bytes=0x$(echo $hex_bytes | rev | cut -c3- | rev)
    echo $hex_bytes
}

# convert hex to felt
# $1 - hex value
hex_to_felt() {
    hex_upper=`echo ${1//0x/} | tr '[:lower:]' '[:upper:]'`
    echo "obase=10; ibase=16; $hex_upper" | BC_LINE_LENGTH=0 bc
}

# convert felt to hex
# $1 - felt value
felt_to_hex() {
    felt=`echo "obase=16; ibase=10; $1" | BC_LINE_LENGTH=0 bc`
    echo 0x$felt
}