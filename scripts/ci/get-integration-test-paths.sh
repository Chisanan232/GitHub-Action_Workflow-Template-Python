#!/usr/bin/env bash

set -ex
runtime_os=$1

declare -a base_tests

getalltests() {
    declare -a testpatharray=( $(ls -F "$1" | grep -v '/$' | grep -v '__init__.py' | grep -v 'test_config.py' | grep -v -E '^_[a-z_]{1,64}.py' | grep -v '__pycache__'))

    declare -a alltestpaths
    for (( i = 0; i < ${#testpatharray[@]}; i++ )) ; do
        alltestpaths[$i]=$1${testpatharray[$i]}
    done

    base_tests=("${alltestpaths[@]}")
}

base_path=test/integration_test/

getalltests $base_path

dest=( "${base_tests[@]}" )


if echo "$runtime_os" | grep -q "windows";
then
    printf '%s\n' "${dest[@]}" | jq -R .
elif echo "$runtime_os" | grep -q "unix";
then
    printf '%s\n' "${dest[@]}" | jq -R . | jq -cs .
else
    printf 'error' | jq -R .
fi
