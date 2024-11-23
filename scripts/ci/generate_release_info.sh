Input_Arg_Project_Type=$1
Input_Arg_Debug_Mode=$2

release=$(bash ./scripts/ci/build_git-tag_or_create_github-release.sh "$Input_Arg_Project_Type" "$Input_Arg_Debug_Mode")
echo "📄 Release log: $release"

release_version=$(echo "$release" | grep -E "\[GitHub Action - Reusable workflow\] \[Final Running Result\] (Official\-Release and version: ([0-9]{1,}\.[0-9]{1,})|(Pre\-Release))" | grep -E -o "(([0-9]{1,}\.[0-9]{1,})|(Pre\-Release))")
echo " 📲 Target version which would be pass to deployment process: $release_version"
