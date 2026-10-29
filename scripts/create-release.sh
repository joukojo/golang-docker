#!/usr/bin/env bash
set -euo pipefail

: "${RELEASE_TAG:?RELEASE_TAG is required}"
: "${DOCKERHUB_IMAGE:?DOCKERHUB_IMAGE is required}"
: "${IMAGE_DIGEST:?IMAGE_DIGEST is required}"

# Successful reruns leave an existing published release unchanged.
if existing_draft=$(gh release view "$RELEASE_TAG" --json isDraft --jq '.isDraft'); then
    if [[ "$existing_draft" == false ]]; then
        echo "Release $RELEASE_TAG is already published"
        exit 0
    fi
    echo "A draft release already exists for $RELEASE_TAG; review it before publishing." >&2
    exit 1
fi

notes=$(cat <<EOF
Go ${RELEASE_TAG#v} development image based on Debian Trixie.

### Docker image

\`docker pull ${DOCKERHUB_IMAGE}:${RELEASE_TAG#v}\`

Platforms: \`linux/amd64\`, \`linux/arm64\`.

Published image: \`${DOCKERHUB_IMAGE}@${IMAGE_DIGEST}\`.
EOF
)

gh release create "$RELEASE_TAG" \
    --verify-tag \
    --title "$RELEASE_TAG" \
    --generate-notes \
    --notes "$notes"
