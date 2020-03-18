export CGO_ENABLED=0
export GO111MODULE=on

.PHONY: build

ONOS_HELM_CHARTS_TESTS_VERSION := latest

test: # @HELP run the unit tests and source code validation
test: images
	onit test --image onosproject/onos-helm-charts-tests:${ONOS_HELM_CHARTS_TESTS_VERSION}

onos-helm-charts-tests-docker: # @HELP build onos-helm-charts-tests Docker image
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o build/_output/bin/onos-helm-charts-tests ./build/cmd
	docker build . -f build/Dockerfile -t onosproject/onos-helm-charts-tests:${ONOS_HELM_CHARTS_TESTS_VERSION}

images: # @HELP build all Docker images
images: onos-helm-charts-tests-docker

kind: # @HELP build Docker images and add them to the currently configured kind cluster
kind: images
	@if [ "`kind get clusters`" = '' ]; then echo "no kind cluster found" && exit 1; fi
	kind load docker-image onosproject/onos-helm-charts-tests:${ONOS_HELM_CHARTS_TESTS_VERSION}

clean: # @HELP remove all the build artifacts
	rm -rf ./build/_output

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '
