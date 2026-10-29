#!/bin/sh
set -eu

image=${1:?Usage: smoke-test.sh IMAGE [PLATFORM]}
platform=${2:-}
expected_go_version=$(sed -n 's/^FROM golang:\([0-9][0-9.]*\)-trixie$/\1/p' Dockerfile)
test -n "$expected_go_version"
set -- "$image"
if [ -n "$platform" ]; then
    set -- --platform "$platform" "$image"
fi

docker run --rm -i -e GOTOOLCHAIN=local -e EXPECTED_GO_VERSION="$expected_go_version" "$@" sh -eu <<'EOF'
test "$(id -un)" = gopher
test "$(id -u)" -ne 0
test "$PWD" = /app
test "$(go env GOVERSION)" = "go$EXPECTED_GO_VERSION"
go version
git --version
govulncheck -version
test -w /go
test -w /app
smoke_dir=$(mktemp -d /app/smoke.XXXXXX)
trap 'rm -rf "$smoke_dir"' EXIT
cd "$smoke_dir"
cat > main.go <<'GO'
package main

import "fmt"

func main() { fmt.Println("Go smoke test passed") }
GO
go build -o smoke main.go
test "$(./smoke)" = 'Go smoke test passed'
echo 'Image smoke tests passed'
EOF
