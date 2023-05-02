.PHONY: build test format

build:
	protostar build

format:
	protostar format src tests

install:
	protostar install

test:
	protostar test