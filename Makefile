.PHONY: build test format

build:
	protostar build

install:
	protostar install

test:
	protostar test tests/units/project tests/units/offset