#!/usr/bin/env bash

#set -ex

test_type=$1
os=$2

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
  echo "✅ It's" && exit 0
elif [ "$test_type" == "all-test" ];
then
  for oneos in "${allosarray[@]}" ;
  do
    coveragedatafile=".coverage.$test_type.$oneos"
    coverage combine --data-file="$coveragedatafile" .coverage.*."$oneos"*
    coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type"_"$oneos".xml
  done
  echo "✅ It's" && exit 0
else
  echo "❌ It's" && exit 1
fi
