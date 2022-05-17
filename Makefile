.PHONY: build test

build:
	protostar build

test:
	protostar test src -m '.*$(match).*'
	
date:
	date

format:
	black scripts
	cairo-format -i src/**/*.cairo