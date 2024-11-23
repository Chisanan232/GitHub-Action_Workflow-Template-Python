#!/usr/bin/env bash

Input_Arg_Project_Type=$1
Input_Arg_Debug_Mode=$2

release=$(bash ./scripts/ci/build_git-tag_or_create_github-release.sh "$Input_Arg_Project_Type" "$Input_Arg_Debug_Mode")
echo "📄 Release log: $release"

release_version=$(echo "$release" | grep -E "\[GitHub Action - Reusable workflow\] \[Final Running Result\] (Official\-Release and version: ([0-9]{1,}\.[0-9]{1,})|(Pre\-Release))" | grep -E -o "(([0-9]{1,}\.[0-9]{1,})|(Pre\-Release))")
is_first_release_version=$(echo "$release_version" | grep -E -o "([0-9]{1,}\.0\.{0,1}0{0,1})")
if [ "$is_first_release_version" != "" ]; then
    # shellcheck disable=SC2125
    # shellcheck disable=SC2207
    # shellcheck disable=SC2034
    release_version_array=($(echo "$release_version" | grep -E -o "([0-9]{1,})"))
    # shellcheck disable=SC2125
    release_version="${release_version_array[0]}"
fi
echo " 📲 Target version which would be pass to deployment process: $release_version"
