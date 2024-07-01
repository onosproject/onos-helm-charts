#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright 2024 Intel Corporation

INPUT=$1

COMPARISON_BRANCH="${COMPARISON_BRANCH:-master}"

function is_valid_format() {
    # check if version format is matched to SemVer
    VER_REGEX='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
    if [[ ! $(echo $1 | tr -d '\n' | sed s/-dev//) =~ $VER_REGEX ]]
    then
      echo Version $1 is not in SemVer
      return 1
    fi
    return 0
}

function get_changed_charts() {
    while IFS= read -r -d '' chart
    do
      chart_dir=$(dirname $chart)
      chart_dir=$(basename $chart_dir)
      chart_diff=$(git diff -p $COMPARISON_BRANCH --name-only ./$chart_dir)
      if [ -n "$chart_diff" ]
      then
          echo $chart_dir
      fi
    done < <(find . -name Chart.yaml -print0)
}

function is_unique_version() {
    echo "comparison branch $COMPARISON_BRANCH"

    while IFS= read -r -d '' chart
    do
      chart_dir=$(dirname $chart)
      chart_dir=$(basename $chart_dir)
      chart_diff=$(git diff -p $COMPARISON_BRANCH --name-only ./$chart_dir)

      if [ -n "$chart_diff" ]
      then
          chart_ver=$(yq e '.version' ${chart_dir}/Chart.yaml)

          is_valid_format $chart_ver
          if [ $? == 1 ]
          then
            echo $chart_dir does not have SemVer formatted version $chart_ver
            return 1
          fi

          for t in $(git tag | grep $chart_dir | cat)
          do
              pure_t=$(echo $t | sed s/$chart_dir-//)
              if [ "$pure_t" == "$chart_ver" ]
              then
                echo Chart $chart_dir version duplicated $chart_ver=$pure_t
                return 1
              fi
          done
      fi
    done < <(find . -name Chart.yaml -print0)
    return 0
}

case $INPUT in
  all)
    is_unique_version
    ;;

  get_changed_charts)
    get_changed_charts
    ;;

  *)
    echo -n "unknown input"
    exit 2
    ;;
esac

