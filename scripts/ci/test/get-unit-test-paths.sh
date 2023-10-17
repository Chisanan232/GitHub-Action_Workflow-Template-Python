#!/usr/bin/env bash

set -ex
runtime_os=$1

declare base_directory
base_directory=test/unit_test/

declare -a all_test_subpkgs=( "$base_directory" )

get_all_test_subpackage() {
    # Get all test directories (python subpackage)
    # Note: use dept-first search algorithm
    printf "running parameter $1" | jq -R . | jq -cs .
    declare index=0
    if [ "$1" ];
    then
        index=$1
    fi

    declare test_subpkg="${all_test_subpkgs[$index]}"
    if [ "$test_subpkg" != "" ];
    then
        printf "Path '$test_subpkg' is not empty, run to scan directoies." | jq -R . | jq -cs .
        declare test_path="$test_subpkg*/"

        printf "Start to find under path $test_path" | jq -R . | jq -cs .
        printf '%s\n' "${all_test_subpkgs[@]}" | jq -R . | jq -cs .
        declare -a test_subpkg_array=( $(ls -d $test_path | grep -v '__pycache__') )

        echo "[DEBUG in finally] test_subpkg_array: $test_subpkg_array"

        if [ ${#test_subpkg_array[@]} != 0 ];
        then
            printf "No any directory under this path, try to get the test modules" | jq -R . | jq -cs .
            # No any directory under this path, try to get the test modules
            all_test_subpkgs+=( "${test_subpkg_array[@]}" )
            get_all_test_subpackage $(( $index + 1 ))
        else
            printf "Has some directories under this path, keep searching" | jq -R . | jq -cs .
            # Has some directories under this path, keep searching
            if [ ${#all_test_subpkgs[@]} != $index ];
            then
                get_all_test_subpackage $(( $index + 1 ))
            else
                printf "Done to find under path $1" | jq -R . | jq -cs .
            fi
        fi
    else
        printf "Path '$test_subpkg' is empty, ignore to run." | jq -R . | jq -cs .
    fi
}

declare -a all_tests

get_all_test_modules_under_subpkg() {
    # Get all test modules with one specific subpackage (directory has __init__.py file)
    declare -a testpatharray=( $(ls -F "$1" | grep -v '/$' | grep -v '__init__.py' | grep -v 'test_config.py' | grep -v -E '^_[a-z_]{1,64}.py' | grep -v '__pycache__'))

    declare -a alltestpaths
    for test_module_path in ${testpatharray};
    do
        alltestpaths+=("$1$test_module_path")
    done

    all_tests+=("${alltestpaths[@]}")
}

get_all_test_modules() {
    # Get all test modules under these test subpackages
    for test_subpkg in "${all_test_subpkgs[@]}";
    do
        get_all_test_modules_under_subpkg "$test_subpkg"
    done
}

get_all_test_subpackage

printf '%s\n' "${all_test_subpkgs[@]}" | jq -R . | jq -cs .

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
