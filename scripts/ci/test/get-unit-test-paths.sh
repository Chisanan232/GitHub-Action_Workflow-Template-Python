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
    for test_module_path in ${testpatharray};
    do
        alltestpaths+=("$1$test_module_path")
    done

    all_tests+=("${alltestpaths[@]}")
}

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
    #    declare ls_exit_code=$?

        echo "[DEBUG in finally] test_subpkg_array: $test_subpkg_array"

        if [ ${#test_subpkg_array[@]} != 0 ];
        then
            printf "No any directory under this path, try to get the test modules" | jq -R . | jq -cs .
            # No any directory under this path, try to get the test modules
            all_test_subpkgs+=( "${test_subpkg_array[@]}" )
    #        for test_subpkg in ${all_test_subpkgs};
    #        do
    #            printf "Start to find under path $test_subpkg" | jq -R . | jq -cs .
            get_all_test_subpackage $(( $index + 1 ))
      #            alltestpaths[$i]=$1${testpatharray[$i]}
    #        done
    #        getalltests "$1"
    #    if echo $ls_exit_code | grep -q 1;
    #    then
    #        # No any directory under this path, try to get the test modules
    #        all_test_subpkgs+=("$1")
    #        getalltests "$1"
        else
            printf "Has some directories under this path, keep searching" | jq -R . | jq -cs .
            # Has some directories under this path, keep searching
            if [ ${#all_test_subpkgs[@]} != $index ];
            then
                get_all_test_subpackage $(( $index + 1 ))
            else
                printf "Done to find under path $1" | jq -R . | jq -cs .
            fi
    #        getalltests "$1"
    ##        declare -a alltestpaths
    #        for (( i = 0; i < ${#test_subpkg_array[@]}; i++ )) ; do
    #            get_all_test_subpackage "${test_subpkg_array[$i]}"
    #  #            alltestpaths[$i]=$1${testpatharray[$i]}
    #        done
        fi
    else
        printf "Path '$test_subpkg' is empty, ignore to run." | jq -R . | jq -cs .
    fi

#    all_tests=("${alltestpaths[@]}")
}

#init_path=test/unit_test/

#getalltests $base_directory
get_all_test_subpackage

printf '%s\n' "${all_test_subpkgs[@]}" | jq -R . | jq -cs .

#echo "[DEBUG in finally] all_test_subpkgs: ${all_test_subpkgs}"

# Get all test modules under these test sub-pacakges
for test_subpkg in "${all_test_subpkgs[@]}";
do
    getalltests "$test_subpkg"
done

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
