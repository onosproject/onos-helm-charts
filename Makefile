export CGO_ENABLED=0
export GO111MODULE=on

.PHONY: build

ONOS_HELM_CHARTS_TESTS_VERSION := latest

test: # @HELP run the unit tests and source code validation
test: images
	helmit test ./test

clean: # @HELP remove all the build artifacts
	rm -rf ./build/_output

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '
