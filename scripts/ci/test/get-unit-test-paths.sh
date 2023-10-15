#!/usr/bin/env bash

set -ex
runtime_os=$1

declare base_directory
base_directory=test/unit_test/

declare -a all_tests

getalltests() {
    # Get all test items from the module (.py files)
    declare -a testpatharray=( $(ls -F "$1" | grep -v '/$' | grep -v '__init__.py' | grep -v 'test_config.py' | grep -v -E '^_[a-z_]{1,64}.py' | grep -v '__pycache__'))

    declare -a alltestpaths
    for (( i = 0; i < ${#testpatharray[@]}; i++ )) ; do
        alltestpaths[$i]=$1${testpatharray[$i]}
    done

    all_tests+=("${alltestpaths[@]}")
}

get_all_test_subpackage() {
    # Get all test directories (python subpackage)
    # Note: use dept-first search algorithm
    declare -a testpatharray=( $(ls -d "$1/*/" | grep -v '/$' | grep -v '__init__.py' | grep -v 'test_config.py' | grep -v -E '^_[a-z_]{1,64}.py' | grep -v '__pycache__'))

    if echo ${#testpatharray[@]} | grep -q "0";
    then
        # No any directory under this path, try to get the test modules
        getalltests "$1"
    else
        # Has some directories under this path, keep searching
#        declare -a alltestpaths
        for (( i = 0; i < ${#testpatharray[@]}; i++ )) ; do
            get_all_test_subpackage testpatharray[$i]
#            alltestpaths[$i]=$1${testpatharray[$i]}
        done
    fi

#    all_tests=("${alltestpaths[@]}")
}

#init_path=test/unit_test/

getalltests $base_directory

dest=( "${all_tests[@]}" )


if echo "$runtime_os" | grep -q "windows";
then
    printf "${dest[@]}" | jq -R .
elif echo "$runtime_os" | grep -q "unix";
then
    printf '%s\n' "${dest[@]}" | jq -R . | jq -cs .
else
    printf 'error' | jq -R .
fi
