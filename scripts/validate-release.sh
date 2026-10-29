#!/usr/bin/env bash
set -euo pipefail

release_tag=${1:?Usage: validate-release.sh vX.Y.Z}
if [[ ! "$release_tag" =~ ^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
    echo 'Release tags must use vX.Y.Z without prerelease suffixes.' >&2
    exit 1
fi

read -r base_image < Dockerfile
if [[ "$base_image" != "FROM golang:${release_tag#v}-trixie" ]]; then
    echo "Dockerfile must pin golang:${release_tag#v}-trixie for this release." >&2
    exit 1
fi

if ! git merge-base --is-ancestor HEAD refs/remotes/origin/main; then
    echo 'The release commit must be merged into main before tagging.' >&2
    exit 1
fi

echo "Release $release_tag validated"
