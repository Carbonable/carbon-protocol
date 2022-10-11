#!/bin/bash

SCRIPT_DIR=`readlink -f $0 | xargs dirname`
ROOT=`readlink -f $SCRIPT_DIR/..`
BUILD_DIR=`readlink -f $ROOT/build`
OUTPUT_DIR=`readlink -f $SCRIPT_DIR/callgraphs`

# create compiled files
cd $ROOT
protostar install
protostar build

# create images
mkdir -p $OUTPUT_DIR
for FILE in ./build/*.json
do
    thoth -f $FILE -call -format svg -view False -output_callgraph_folder $OUTPUT_DIR
done
