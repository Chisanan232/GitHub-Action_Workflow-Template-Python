#!/usr/bin/env bash

set -ex

base_directory=$1
if [ "$base_directory" == "" ];
then
    base_directory="test/"
fi

runtime_os=$2
if [ "$runtime_os" == "" ];
then
    runtime_os="unix"
fi

declare -a all_test_subpkgs=( "$base_directory" )

get_all_test_subpackage() {
    # Get all test directories (python subpackage)
    # Note: use dept-first search algorithm
    declare index=0
    if [ "$1" ];
    then
        index=$1
    fi

    declare test_subpkg="${all_test_subpkgs[$index]}"
    if [ "$test_subpkg" != "" ];
    then
        # Still has test subpackage won't scan
        declare test_path="$test_subpkg*/"
        # shellcheck disable=SC2086
        declare -a test_subpkg_array=( $(ls -d $test_path | grep -v '__pycache__') )

        if [ ${#test_subpkg_array[@]} != 0 ];
        then
            # No any directory under this path, try to get the test modules
            all_test_subpkgs+=( "${test_subpkg_array[@]}" )
            # shellcheck disable=SC2004
            get_all_test_subpackage $(( $index + 1 ))
        else
            # Has some directories under this path, keep searching
            if [ ${#all_test_subpkgs[@]} != "$index" ];
            then
                # shellcheck disable=SC2004
                get_all_test_subpackage $(( $index + 1 ))
            fi
        fi
    fi
}

declare all_tests

get_all_test_modules_under_subpkg() {
    # Get all test modules with one specific subpackage (directory has __init__.py file)
    declare -a testpatharray=( $(ls -F "$1" | grep -v '/$' | grep -v '__init__.py' | grep -v 'test_config.py' | grep -v -E '^_[a-z_]{1,64}.py' | grep -v '__pycache__'))

    declare -a alltestpaths
    for test_module_path in "${testpatharray[@]}";
    do
        alltestpaths+=("$1$test_module_path")
    done

    # shellcheck disable=SC2124
    # shellcheck disable=SC2178
    all_tests+="${alltestpaths[@]} "
}

get_all_test_modules() {
    # Get all test modules under these test subpackages
    for test_subpkg in "${all_test_subpkgs[@]}";
    do
        get_all_test_modules_under_subpkg "$test_subpkg"
    done
}

# Get all test module paths
get_all_test_subpackage
get_all_test_modules

# Process data as list type value
dest=( "${all_tests[@]}" )


# Output the final result about all test modules
if echo "$runtime_os" | grep -q "windows";
then
    printf "${dest[@]}" | jq -R .
elif echo "$runtime_os" | grep -q "unix";
then
    printf '%s\n' "${dest[@]}" | jq -R . | jq -cs .
else
    printf 'error' | jq -R .
fi
