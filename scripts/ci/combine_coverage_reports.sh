#!/usr/bin/env bash

set -ex

test_type=$1

coveragedatafile=".coverage.$test_type"

if [ "$test_type" == "all-test" ];
then
  coverage combine --data-file="$coveragedatafile" .coverage.*
else
  coverage combine --data-file="$coveragedatafile" .coverage."$test_type".*
fi

coverage report -m --data-file="$coveragedatafile"
coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type".xml
cp "$coveragedatafile" .coverage
echo "✅ All processing done." && exit 0
