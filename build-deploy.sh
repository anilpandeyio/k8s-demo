#!/bin/bash

set -e

IMAGE_NAME="anilpandeyio/k8node"
VERSION_FILE=".version"

# Make sure version file exists
if [ ! -f "$VERSION_FILE" ]; then
    echo "0" > "$VERSION_FILE"
fi

# Read current version
CURRENT_VERSION=$(cat "$VERSION_FILE")

# Increment version
NEW_VERSION=$((CURRENT_VERSION + 1))

echo "Current version: v$CURRENT_VERSION"
echo "New version:     v$NEW_VERSION"

# Build image
docker build \
    -t "${IMAGE_NAME}:v${NEW_VERSION}" \
    .

# Push image
docker push "${IMAGE_NAME}:v${NEW_VERSION}"

# Save new version only after successful push
echo "$NEW_VERSION" > "$VERSION_FILE"

echo
echo "Successfully pushed:"
echo "${IMAGE_NAME}:v${NEW_VERSION}"