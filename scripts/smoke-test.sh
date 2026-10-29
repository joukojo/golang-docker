#!/bin/sh
set -eu

image=${1:?Usage: smoke-test.sh IMAGE [PLATFORM]}
platform=${2:-}
set -- "$image"
if [ -n "$platform" ]; then
    set -- --platform "$platform" "$image"
fi

docker run --rm -i -e GOTOOLCHAIN=local "$@" sh -eu <<'EOF'
test "$(id -un)" = gopher
test "$(id -u)" -ne 0
test "$PWD" = /app
case "$(go env GOVERSION)" in
    go1.27.*) go version ;;
    *) echo 'Expected Go 1.27.x' >&2; exit 1 ;;
esac
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
