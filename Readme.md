# Golang Docker Image

A production-ready Docker image for Go development based on Debian Trixie with enhanced security and developer tools.

## Quick Start

```bash
docker pull joukojo/golang:latest
```

## Docker Hub

This image is available at: [https://hub.docker.com/r/joukojo/golang/tags](https://hub.docker.com/r/joukojo/golang/tags)

## Features

- **Base Image**: golang:1.27.3-trixie (pins the Go patch version)
- **OS**: Debian Trixie
- **Security**: Non-root user (`gopher`) for enhanced security
- **Development Tools**: Git pre-installed
- **Working Directory**: `/app`
- **Up-to-date**: Latest security patches applied

## Image Details

- **Go Version**: 1.27.3
- **User**: gopher (non-root)
- **Working Directory**: /app (owned by gopher user)
- **Pre-installed Tools**:
  - Git
  - govulncheck
  - All standard Go toolchain

## Usage

### Basic Usage

```bash
docker run -it joukojo/golang:latest
```

### Build a Go Application

```bash
# Mount your source code and build
docker run --rm -v "$PWD":/app joukojo/golang:latest go build -o myapp
```

### Run Go Commands

```bash
# Run tests
docker run --rm -v "$PWD":/app joukojo/golang:latest go test ./...

# Format code
docker run --rm -v "$PWD":/app joukojo/golang:latest go fmt ./...

# Run your application
docker run --rm -v "$PWD":/app joukojo/golang:latest go run main.go
```

### Using as a Base Image

```dockerfile
FROM joukojo/golang:latest

COPY . .

RUN go mod download
RUN go build -o myapp

CMD ["./myapp"]
```

### Development Environment

```bash
# Start an interactive shell for development
docker run -it --rm -v "$PWD":/app joukojo/golang:latest /bin/bash
```

## Security Features

- Runs as non-root user (`gopher`) by default
- Regular security updates from Debian
- Minimal attack surface with only essential tools

## Building the Image

If you want to build the image locally:

```bash
git clone https://github.com/joukojo/golang-docker.git
cd golang-docker
docker build --pull -t joukojo/golang:local .
sh scripts/smoke-test.sh joukojo/golang:local
```

### Makefile Commands

Run these commands from the repository root with Docker running. They require
Make and Docker Buildx; building or running another CPU architecture also requires
emulation support, which Docker Desktop provides.

| Command | Behavior |
| --- | --- |
| `make build-amd64` | Build and load `golang-local:amd64` for Linux amd64. |
| `make build-arm64` | Build and load `golang-local:arm64` for Linux arm64. |
| `make run-amd64` | Build the amd64 image, then open an interactive container. |
| `make run-arm64` | Build the arm64 image, then open an interactive container. |
| `make init-builder` | Create and select the optional `multiarch-builder` Buildx builder. |

Both build targets pull the base image and load the result into local Docker.
Each run target depends on its matching build target, uses the matching platform,
and removes the container when you exit. These containers start in `/app` as
`gopher`; the run targets do not mount your local source files.

To smoke-test either local image after building it:

```bash
sh scripts/smoke-test.sh golang-local:amd64 linux/amd64
sh scripts/smoke-test.sh golang-local:arm64 linux/arm64
```

CI builds and smoke-tests the image on Linux amd64 and arm64 before publishing.
The checks verify the pinned Go version, Git, govulncheck, the non-root user, and compilation
in `/app`. Pull requests run these checks without publishing images.

## Releases (Git Flow)

Image releases follow the Go version: `release/v1.27.3` prepares Git tag
`v1.27.3` and Docker image `joukojo/golang:1.27.3`.

1. Create `release/vX.Y.Z` from `develop`. Pin the matching Go version in the
   Dockerfile and update this README. Push the branch for CI validation.
2. Open a PR from the release branch to `main`. Wait for the checks to pass,
   then merge it.
3. Tag the resulting release commit on `main` and push the annotated tag:

   ```bash
   git switch main
   git pull --ff-only origin main
   git tag -a v1.27.3 -m "Release v1.27.3"
   git push origin v1.27.3
   ```

4. Merge the release branch back into `develop` through a PR to retain release
   fixes. Delete the release branch only after both merges are complete.

The tag pipeline accepts stable `vX.Y.Z` tags only. It checks that the version
matches the Dockerfile and the tagged commit is in `main`, smoke-tests both
architectures, and publishes the versioned Docker image and `latest`. Only after
Docker publication succeeds does it publish a GitHub Release with generated
release notes, a pull command, and the published image digest.

Release notes group PRs using the labels configured in `.github/release.yml`:
`enhancement`/`feature`, `bug`, `documentation`, and
`maintenance`/`dependencies`/`ci`. Unlabelled PRs appear under Other changes.
Published GitHub Releases are skipped on reruns. If image publication succeeds
but GitHub Release creation fails, use **Re-run failed jobs** to retry the release
job without rebuilding the image. A manually created draft must be reviewed
before retrying.

Pushes to `develop` publish nightly images. Pushes to `release/*` and pull
requests run validation without publishing. The **Run workflow** button runs
the behavior associated with the selected ref; it does not create a release tag.

## Environment Variables

This image inherits all environment variables from the official Go image, including:

- `GOPATH=/go`
- `PATH=/go/bin:/usr/local/go/bin:$PATH`

## Volumes

The working directory `/app` is suitable for mounting your application source code:

```bash
docker run -v "$PWD":/app joukojo/golang:latest
```

## License

[Specify your license here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues or questions, please open an issue on the GitHub repository.
