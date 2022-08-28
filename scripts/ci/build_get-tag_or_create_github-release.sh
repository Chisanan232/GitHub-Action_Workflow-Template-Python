#!/usr/bin/env bash

#set -ex

# Check whether it has 'release-notes.md' or 'release-title.md' in the target directory '.github'.
has_auto_release_flag=$(ls .github | grep -E "release-auto-flag.txt")
if [ "$has_auto_release_flag" == "" ]; then
    echo "It should have *release-auto-flag.txt* in '.github' directory of your project in HitHub."
    exit 0
else
    auto_release_flag=$(cat .github/release-auto-flag.txt)
    if [ "$auto_release_flag" == false ]; then
        echo "Auto-release flag is 'false' so it won't build git tag or create GitHub release."
        exit 0
    fi
fi

has_release_notes=$(ls .github | grep -E "release-notes.md")
has_release_title=$(ls .github | grep -E "release-title.md")
if [ "$has_release_notes" == "" ]; then
    echo "It should have *release-notes.md* in '.github' directory of your project in HitHub."
    exit 1
fi
if [ "$has_release_title" == "" ]; then
    echo "It should have *release-title.md* in '.github' directory of your project in HitHub."
    exit 1
fi


# # # # python-package or github-action-reusable-workflow
release_type=$1

if [ "$release_type" == 'python-package' ]; then
    # # # # The name of Python package
    python_pkg_name=$2
    # # # # For development and troubleshooting
    debug_mode=$4
elif [ "$release_type" == 'github-action-reusable-workflow' ]; then
    python_pkg_name=""
    debug_mode=$2
else
    echo "Currently, it only has 2 release type: 'python-package' or 'github-action-reusable-workflow'."
    exit 1
fi

if [ "$release_type" == "" ]; then
    echo "The argument 'release_type' (first argument) cannot be empty."
    exit 1
fi


# # # # From the PEP440: Software version style rule
# # #
# # # The version setting 1: version format
# # Simple “major.minor” versioning: (general-2)
# 0.1,   0.2,   0.3,   1.0,   1.1
# # Simple “major.minor.micro” versioning: (general-3)
# 1.0.0,   1.0.1,   1.0.2,   1.1.0
# # Date based releases, using an incrementing serial within each year, skipping zero: (date-based)
# 2012.1,   2012.2,  ...,   2012.15,   2013.1,   2013.2
# # # The version setting 2: version evolution
# # “major.minor” versioning with alpha, beta and candidate pre-releases: (sema)
# 0.9,   1.0a1,   1.0a2,   1.0b1,   1.0rc1,   1.0
# # “major.minor” versioning with developmental releases, release candidates and post-releases for minor corrections: (dev)
# 0.9,   1.0.dev1,   1.0.dev2,   1.0.dev3,   1.0c1,   1.0,   1.0.post1,   1.1.dev1
software_version_format=$3

declare version_reg
declare software_version_reg
declare python_version_reg

if [ "$release_type" == 'python-package' ]; then

    if [ "$python_pkg_name" == "" ]; then
        echo "The argument 'python_pkg_name' (second argument) cannot be empty if option 'release_type' (first argument) is 'python-package'."
        exit 1
    fi

    if [ "$software_version_format" == "general-2" ]; then
        version_reg="[0-9]\.[0-9]"
    elif [ "$software_version_format" == "general-3" ]; then
        version_reg="[0-9]\.[0-9]\.[0-9]"
    elif [ "$software_version_format" == "date-based" ]; then
        version_reg="[0-9]{4}\.([0-9]{1,})+"
    else
        # Default value
        version_reg="[0-9]\.[0-9]\.[0-9]"
    fi

    software_version_reg="$version_reg*([\.,-]*([a-zA-Z]{1,})*([0-9]{0,})*){0,}"
    python_version_reg="__version__ = \"$software_version_reg\""

fi

#if [ "$release_type" == 'python-package' ]; then
#    if [ "$software_version_evolution" == "sema" ]; then
#        echo "*-*([a-zA-Z]{1,})*([0-9]{0,})"
#    elif [ "$software_version_evolution" == "dev" ]; then
#        echo "*[\.,-]*([a-zA-Z]{1,})*([0-9]{0,})"
#    else
#        # Default value
#        echo ""
#    fi
#fi


#current_branch=$(git branch --show-current)
echo "Verify the git branch info"
git branch --list
echo "Get the current git branch info"
current_branch=$(git branch --list | cat | grep -E '\* ([a-zA-Z0-9]{1,16})' | grep -E -o '([a-zA-Z0-9]{1,16})')
echo "Current git branch: $current_branch"


declare new_ver

build_git_tag_or_github_release() {
    # Generate the new version from previous tag
    current_ver=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]" | grep -E -o '[0-9]\.[0-9]\.[0-9]' | head -n1 | cut -d "." -f1)
    if [ "$current_ver" == "" ]; then
        current_ver=0
    fi
    new_ver=$(( current_ver + 1 ))
    new_tag='v'$new_ver'.0.0'

    # git event: push
    # all branch -> Build tag
    # master branch -> Build tag and create release

    if [ "$debug_mode" == true ]; then
        echo " 🔍👀[DEBUG MODE] Build git tag $new_tag in git branch '$current_branch'."
    else
        git tag -a "$new_tag" -m "$new_tag"
        git push -u origin --tags
    fi

    echo "Build git tag which named '$new_tag' with current branch '$current_branch' successfully!"
    if [ "$current_branch" == "master" ]; then
        release_title=$(cat .github/release-title.md)

        if [ "$debug_mode" == true ]; then
            echo " 🔍👀[DEBUG MODE] Create GitHub release with tag '$new_tag' and title '$release_title' in git branch '$current_branch'."
        else
            gh release create "$new_tag" --title "$release_title" --notes-file .github/release-notes.md
        fi

        echo "Create GitHub release with title '$release_title' successfully!"
    fi
}


# The truly running implementation of shell script
if [ "$release_type" == 'python-package' ]; then

    # # # # For Python package release
    echo 'do python package release'

    git_tag=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]*" | grep -o '[0-9]\.[0-9]\.[0-9]*')
    github_release=$(curl -s https://api.github.com/repos/Chisanan232/GitHub-Action_Workflow-Template-Python/releases/latest | jq -r '.tag_name')
    # shellcheck disable=SC2002
    pkg_version=$(cat ./"$python_pkg_name"/__pkg_info__.py | grep -E "$python_version_reg" | grep -E -o "$software_version_reg")

    build_git_tag=false
    create_github_release=false

    # 1. Compare the Python source code version and git tag, GitHub release version.
    if [ "$pkg_version" == "$git_tag" ]; then
        echo "Version of git tag info are the same. So it verifies it has built and pushed before."
    else
        echo "Version of git tag info are different. So it verifies it doesn't build and push before."
        build_git_tag=true
    fi

    if [ "$current_branch" == "master" ] && [ "$pkg_version" == "$github_release" ]; then
        echo "Version of GitHub release info are the same. So it verifies it has built and pushed before."
    else
        echo "Version of GitHub release info are different. So it verifies it doesn't build and push before."
        create_github_release=true
    fi

    if [ "$build_git_tag" == true ] || [ "$create_github_release" == true ]; then

        echo "pkg_version: $pkg_version"
#        is_pre_release_version=$(echo $pkg_version | sed -n 's/.*\([a-zA-Z][0-9]*\)/\1/p')
        is_pre_release_version=$(echo $pkg_version | grep -E -o '([\.-]*([a-zA-Z]{1,})+([0-9]{0,})*){1,}')
        echo "is_pre_release_version: $is_pre_release_version"
        if [ "$is_pre_release_version" == "" ]; then
            echo "The version is not a pre-release."
#            build_tag_and_create_release_and_push_pypi=true
            # do different things with different ranches
            # git event: push
            # all branch -> Build tag
            # master branch -> Build tag and create release
            echo "build tag and create GitHub release, also push code to PyPi"
            build_git_tag_or_github_release
            echo "Done! This is Official-Release so please push source code to PyPi."
#            RELEASE_TYPE="Official"; export RELEASE_TYPE
            echo "Official" >> $RELEASE_TYPE
            echo "[Final Running Result] Official-Release"
        else
            echo "The version is a pre-release."
#            build_tag_and_create_release_only=true
            # do different things with different ranches
            # git event: push
            # all branch -> Build tag
            # master branch -> Build tag and create release
            echo "build tag and create GitHub release only"
            build_git_tag_or_github_release
            echo "Done! This is Pre-Release so please don't push this to PyPi."
#            RELEASE_TYPE="Pre"; export RELEASE_TYPE
            echo "Pre" >> $RELEASE_TYPE
            echo "[Final Running Result] Pre-Release"
        fi

    fi

    # 1. -> Same -> 1-1. Does it have built and pushed before?.
    # 1. -> No (In generally, it should no) -> 1-2. Is it a pre-release version in source code?

    # 1-1. Yes, it has built and pushed. -> Doesn't do anything.
    # 1-1. No, it doesn't build and push before. -> Build and push directly.

    # 1-2. Yes, it's pre-release. -> Doesn't build and push. Just build git tag and GitHub release.
    # 1-2. No, it's not pre-release. -> It means that it's official version, e.g., 1.3.2 version. So it should build git tag and GitHub release first, and build and push.

elif [ "$release_type" == 'github-action-reusable-workflow' ]; then

    echo 'do github-action-reusable-workflow release'
    # # # # For GitHub Action reusable workflow template release
    # 1. Compare whether the release-notes.md has different or not.
    # Note 1: Diff a specific file with currently latest tag and previous one commit
    # https://stackoverflow.com/questions/3338126/how-do-i-diff-the-same-file-between-two-different-commits-on-the-same-branch
    # Note 2: Show the output result in stdout directly
    # https://stackoverflow.com/questions/17077973/how-to-make-git-diff-write-to-stdout
    # Note 3: Here code should be considered what git tag on master branch so we need to verify the info on master branch.
    # Note 4: We should initial a git branch 'master' to provide git diff feature working
    echo "Initial and switch to git branch 'master'."
    git checkout -b master
    echo "Switch back to git branch '$current_branch'."
    git switch "$current_branch"
    echo "+++++++++++++++++++++++++++++++++++"
    git diff origin/master "$current_branch" -- .github/release-notes.md | cat
    echo "+++++++++++++++++++++++++++++++++++"
    echo "Check the different between current git branch and master branch."
    release_notes_has_diff=$(git diff master "$current_branch" -- .github/release-notes.md | cat)
    echo "release_notes_has_diff: $release_notes_has_diff"
    if [ "$release_notes_has_diff" != "" ]; then
        # 1. Yes, it has different. -> Build git tag, GitHub release and version branch
        build_git_tag_or_github_release
        echo "Done! This is Official-Release of GitHub Action reusable workflow, please create a version branch of it."
#        RELEASE_TYPE="$new_ver"; export RELEASE_TYPE
        echo "$new_ver" >> $RELEASE_TYPE
        echo "[Final Running Result] Official-Release"

#        current_ver=$(git describe --tag --abbrev=0 --match "v[0-9]\.[0-9]\.[0-9]" | grep -E -o '[0-9]\.[0-9]\.[0-9]' | head -n1 | cut -d "." -f1)
#        if [ "$current_ver" == "" ]; then
#            current_ver=0
#        fi
#        new_ver=$(( current_ver + 1 ))
#        # Return the new version as output
#        # git event: push
#        # all branch -> Build tag
#        # master branch -> Build tag and create release
#        new_tag='v'$new_ver'.0.0'
#        git tag -a "$new_tag" -m "$new_tag"
#        echo "Build git tag which named '$new_tag' with current branch '$current_branch' successfully!"
#        if [ "$current_branch" == "master" ]; then
#            release_title=$(cat .github/release-title.md)
#            gh release create "$new_tag" --title "$release_title" --notes-file .github/release-notes.md
#            echo "Create GitHub release with title '$release_title' successfully!"
#        fi
    else
        # 1. No, do nothing.
        # Return nothing output
        echo "Release note file doesn't change. Don't do anything."
#        RELEASE_TYPE="Pre"; export RELEASE_TYPE
        echo "Pre" >> $RELEASE_TYPE
        echo "[Final Running Result] Pre-Release"
    fi

fi
