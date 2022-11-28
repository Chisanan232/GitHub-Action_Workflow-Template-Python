#!/usr/bin/env bash

#set -ex

test_type=$1
os=$2
calculate_all_finally=$3

IFS=',' read -ra allosarray <<< "$os"

# shellcheck disable=SC2145
echo "This is all OS array: ${allosarray[@]}"

if [ "$test_type" == "unit-test" ] || [ "$test_type" == "integration-test" ];
then
  for oneos in "${allosarray[@]}" ;
  do
    coveragedatafile=".coverage.$test_type.$oneos"
    coverage combine --data-file="$coveragedatafile" .coverage."$test_type"."$oneos"*
    coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type"_"$oneos".xml
  done
elif [ "$test_type" == "all-test" ];
then
  for oneos in "${allosarray[@]}" ;
  do
    coveragedatafile=".coverage.$test_type.$oneos"
    coverage combine --data-file="$coveragedatafile" .coverage.*."$oneos"*
    coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type"_"$oneos".xml
  done
else
  echo "❌ It doesn't support $test_type currently. Please change to use options 'unit-test', 'integration-test' or 'all-test'." && exit 1
fi

if [ "$calculate_all_finally" == "false" ]; then
  echo "✅ All processing done." && exit 0
else
  coverage combine .coverage.*
  coverage xml
  echo "✅ All processing done." && exit 0
fi
