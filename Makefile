# SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

.PHONY: all test clean

all: test

build-tools:=$(shell if [ ! -d "./build/build-tools" ]; then cd build && git clone https://github.com/onosproject/build-tools.git; fi)
include ./build/build-tools/make/onf-common.mk

jenkins-test: jenkins_version_check deps # @HELP run the jenkins verification tests
	docker pull quay.io/helmpack/chart-testing:v2.4.0
	docker run --rm --name ct --volume `pwd`:/charts quay.io/helmpack/chart-testing:v3.0.0-beta.1 sh -c "ct lint --charts charts/onos-config,charts/onos-topo,charts/onos-cli,charts/onos-gui,charts/device-simulator --debug --validate-maintainers=false"

test: # @HELP run the integration tests
test: version_check deps
	(kubectl delete ns onos-topo || exit 0) && kubectl create ns onos-topo && helmit test -n onos-topo ./test -c . --suite onos-topo
	(kubectl delete ns onos-config || exit 0) && kubectl create ns onos-config && helmit test -n onos-config ./test -c . --suite onos-config
	(kubectl delete ns onos-umbrella || exit 0) && kubectl create ns onos-umbrella && helmit test -n onos-umbrella ./test -c . --suite onos-umbrella

version_check: # @HELP run the version checker on the charts
	COMPARISON_BRANCH=master ./build/build-tools/chart_version_check

jenkins_version_check: # @HELP run the version checker on the charts
	export COMPARISON_BRANCH=origin/master && export WORKSPACE=`pwd` && ./../build-tools/chart_version_check

jenkins-publish: # @HELP publish version on github
	cd .. && GO111MODULE=on go get github.com/mikefarah/yq/v4@v4.16.2
	./../build-tools/release-chart-merge-commit https://charts.onosproject.org ${WEBSITE_USER} ${WEBSITE_PASSWORD}

clean:: # @HELP clean up temporary files.
	rm -rf onos-umbrella/charts onos-umbrella/Chart.lock

deps: # @HELP build dependencies for local charts.
deps: clean license
	helm dep build onos-umbrella

