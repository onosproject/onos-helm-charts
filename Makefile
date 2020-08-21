.PHONY: all test clean

all: test

test: # @HELP run the integration tests
test: version_check
	kubectl create ns onos-topo && helmit test -n onos-topo ./test -c . --suite onos-topo
	kubectl create ns onos-config && helmit test -n onos-config ./test -c . --suite onos-config
	kubectl create ns onos-umbrella && helmit test -n onos-umbrella ./test -c . --suite onos-umbrella

version_check: # @HELP run the version checker on the charts
	COMPARISON_BRANCH=master ./../build-tools/chart_version_check
	./../build-tools/chart_single_check

publish: # @HELP publish version on github
	./../build-tools/publish-version ${VERSION}

bumponosdeps: # @HELP update "onosproject" go dependencies and push patch to git.
	./../build-tools/bump-onos-deps ${VERSION}

clean: # @HELP clean up temporary files.
	rm -rf onos-umbrella/charts onos-umbrella/Chart.lock

deps: # @HELP build dependencies for local charts.
	helm dep build onos-umbrella

help:
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST) \
    | sort \
    | awk ' \
        BEGIN {FS = ": *# *@HELP"}; \
        {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}; \
    '
