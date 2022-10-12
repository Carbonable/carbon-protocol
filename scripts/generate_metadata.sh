#!/bin/bash

### RAW INPUTS
SOURCE_FILE=$1
TIMES=$2
PARENT_DIR="$(dirname "$SOURCE_FILE")"

### GENERATION
echo $TIMES
for (( i=0; i<$TIMES; i++))
do
    cp $SOURCE_FILE $PARENT_DIR/$i.json
done