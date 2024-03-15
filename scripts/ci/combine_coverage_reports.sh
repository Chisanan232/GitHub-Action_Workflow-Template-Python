#!/usr/bin/env bash

set -ex

test_type=$1

coveragedatafile=".coverage.$test_type"

if [ "$test_type" == "unit-test" ] || [ "$test_type" == "integration-test" ] || [ "$test_type" == "system-test" ];
then
  coverage combine --data-file="$coveragedatafile" .coverage."$test_type".*
elif [ "$test_type" == "all-test" ];
then
  coverage combine --data-file="$coveragedatafile" .coverage.*
else
  echo "❌ It doesn't support $test_type currently. Please change to use options 'unit-test', 'integration-test', 'system-test' or 'all-test'." && exit 1
fi

coverage report -m --data-file="$coveragedatafile"
coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type".xml
cp "$coveragedatafile" .coverage
echo "✅ All processing done." && exit 0
