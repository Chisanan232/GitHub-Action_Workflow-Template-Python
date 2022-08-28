#!/usr/bin/env bash

debug_mode=$1

final_release_type=$RELEASE_TYPE
if [ "$final_release_type" == "Pre" ]; then
    echo "It detects Pre-Release flag."
else
    echo "It detects Official-Release flag."
    if [ "$debug_mode" == true ]; then
        echo " 🔍👀[DEBUG MODE] Create new git branch for the new version."
    else
        echo "Add git remote reference."
        git remote add github-action_workflow-template https://github.com/Chisanan232/GitHub-Action-Template-Python.git
        echo "Check all git remote reference."
        git remote -v
        echo "Create a new git branch as version."
        git checkout -b "v$final_release_type"
        echo "Push the source code as a branch with one specific version to the GitHub."
        git push -u github-action_workflow-template "v$final_release_type"
    fi
fi

echo "Done!"
