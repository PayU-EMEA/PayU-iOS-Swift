.PHONY: help generate_documentation generate_mocks xcodebuild_test

help: Makefile
	@sed -n "s/^##//p" $<

## ➡️  generate_documentation: Generate `docs` folder with generated `PUSDK.doccarchive`
generate_documentation:
	./dev/generate_documentation.sh

## ➡️  generate_mocks: Generate *.mocks
generate_mocks:
	./dev/generate_mocks.sh

## ➡️  build: Build
build:
	./dev/xcodebuild_build.sh

## ➡️  test: Run all tests
test:
	./dev/xcodebuild_test.sh
