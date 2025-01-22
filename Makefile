all: clean install lint format build unit-tests

clean:
	@rm -rf out cache tools/obscurus-cli/dist

install:
	@cd tools/obscurus-cli && npm install

lint:
	@solhint 'src/**/*.sol'

format:
	@forge fmt

build:
	@forge build
	@cd tools/obscurus-cli && tsc

unit-tests:
	@forge test --ffi

.PHONY: clean install lint format build unit-tests
