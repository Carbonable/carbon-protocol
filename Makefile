.PHONY: build test

build:
	protostar build

test:
	protostar test src
	
date:
	date

format:
	black scripts
	cairo-format -i src/**/*.cairo