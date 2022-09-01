#!/usr/bin/env bash

#set -ex

release_version=$(echo $RELEASE_TYPE)
if [ "$release_version" != "" ]; then
    echo "📬🎉🍻 It gets data which is release version info!"
    exit 0
else
    echo "📭🙈 It doesn't get any data which is release version info."
    exit 1
fi
