# SPDX-FileCopyrightText: 2022 2020-present Open Networking Foundation <info@opennetworking.org>
#
# SPDX-License-Identifier: Apache-2.0

.PHONY: all test clean version-check

COMPARISON_BRANCH ?= master

all: deps

lint: # @HELP run helm lint
	./build/bin/helm_lint.sh

check-version: # @HELP run the version checker on the charts
	COMPARISON_BRANCH=${COMPARISON_BRANCH} ./build/bin/version_check.sh all

test: # @HELP run the integration tests
test: deps license lint

clean:: # @HELP clean up temporary files.
	rm -rf onos-umbrella/charts onos-umbrella/Chart.lock

deps: # @HELP build dependencies for local charts.
deps: clean license
	helm dep build onos-umbrella
	helm dep build scale-sim
	helm dep build onos-operator

license: # @HELP run license checks
	rm -rf venv
	python3 -m venv venv
	. ./venv/bin/activate;\
	python3 -m pip install --upgrade pip;\
	python3 -m pip install reuse;\
	reuse lint