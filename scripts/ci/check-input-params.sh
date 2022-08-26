#!/usr/bin/env bash

#set -ex
upload_report_to_platform_flag=$1
platform_token=$2

echo "🔍 Start to check input parameters ..."
if [ "$upload_report_to_platform_flag" = true ]; then
    echo "✅ This using flag of uploading platform is true."
    if [ "$platform_token" = "" ]; then
        echo "⚠️️  The using flag of uploading to platform is true but it has no Token of it."
        echo "❌ It needs a Token to let CI could use it authenticates and uploads report to the platform. Please configure a Token to it."
        exit 1
    else
        echo "🍻 It has a Token!"
    fi
else
    echo "💤 It doesn't upload report to this platform."
fi
