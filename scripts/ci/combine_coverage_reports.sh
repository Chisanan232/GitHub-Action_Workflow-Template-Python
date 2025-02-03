#!/usr/bin/env bash

set -ex

test_type=$1
test_coverage_report_format=$2

coveragedatafile=".coverage.$test_type"

if [ "$test_type" == "all-test" ];
then
  coverage combine --data-file="$coveragedatafile" "$test_coverage_report_format"*
else
  coverage combine --data-file="$coveragedatafile" "$test_coverage_report_format$test_type"*
fi

coverage report -m --data-file="$coveragedatafile"
coverage xml --data-file="$coveragedatafile" -o coverage_"$test_type".xml
cp "$coveragedatafile" .coverage
echo "✅ All processing done." && exit 0
