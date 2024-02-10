#! /bin/bash

# Define regular expression to match version numbers with optional build number and suffix
RE='v([0-9]+)\.([0-9]+)\.([0-9]+)\+?([0-9]+)?-?([a-zA-Z0-9]+)?'

lastVersion="$1"

if [ -z "$2" ]; then
    nextVersion=$lastVersion
else
    nextVersion="$2"
fi

# Extract the last build number
LAST_UAT_BUILD_NUMBER=$(echo "$lastVersion" | sed -E "s/$RE/\4/")
echo "lastVersion: $lastVersion"
echo "lastUatBuildNumber: $LAST_UAT_BUILD_NUMBER"

# Extract major, minor, and patch components from nextVersion
NEXT_VERSION_MAJOR=$(echo "$nextVersion" | sed -E "s/$RE/\1/")
NEXT_VERSION_MINOR=$(echo "$nextVersion" | sed -E "s/$RE/\2/")
NEXT_VERSION_PATCH=$(echo "$nextVersion" | sed -E "s/$RE/\3/")

# Increment the last build number by 1
((LAST_UAT_BUILD_NUMBER++))

# Print the next version number
echo "$NEXT_VERSION_MAJOR.$NEXT_VERSION_MINOR.$NEXT_VERSION_PATCH+$LAST_UAT_BUILD_NUMBER"
