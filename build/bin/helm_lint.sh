#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2024 Intel Corporation

exit_code=0

for dir in $(find . -maxdepth 1 -mindepth 1 -type d); do
	if [[ -f "$dir/Chart.yaml" ]]; then
	  helm lint "$dir"
    if [ $? == 1 ]
    then
      exit_code=2
    fi
	fi
done
exit $exit_code