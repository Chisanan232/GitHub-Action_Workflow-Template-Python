#!/usr/bin/env bash

#set -ex

test_type=$1
#os=$2
#calculate_all_finally=$2

#IFS=',' read -ra allosarray <<< "$os"

# shellcheck disable=SC2145
#echo "This is all OS array: ${allosarray[@]}"

coveragedatafile=".coverage.$test_type"

if [ "$test_type" == "unit-test" ] || [ "$test_type" == "integration-test" ];
then
#  for oneos in "${allosarray[@]}" ;
#  do
  coverage combine --data-file="$coveragedatafile" .coverage."$test_type".*
#  done
elif [ "$test_type" == "all-test" ];
then
#  for oneos in "${allosarray[@]}" ;
#  do
  coverage combine --data-file="$coveragedatafile" .coverage.*
#  done
else
  echo "❌ It doesn't support $test_type currently. Please change to use options 'unit-test', 'integration-test' or 'all-test'." && exit 1
fi

coverage report -m --data-file="$coveragedatafile"
coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type".xml
cp coveragedatafile .coverage
echo "✅ All processing done." && exit 0

#if [ "$calculate_all_finally" == "false" ]; then
#  echo "✅ All processing done." && exit 0
#else
#  coverage combine .coverage.*
#  coverage xml
#  echo "✅ All processing done." && exit 0
#fi
