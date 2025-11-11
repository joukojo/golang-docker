# Golang Docker Image

A production-ready Docker image for Go development based on Debian Trixie with enhanced security and developer tools.

## Quick Start

```bash
docker pull joukojo/golang:latest
```

## Docker Hub

This image is available at: [https://hub.docker.com/r/joukojo/golang/tags](https://hub.docker.com/r/joukojo/golang/tags)

## Features

- **Base Image**: golang:1.25-trixie
- **OS**: Debian Trixie (testing)
- **Security**: Non-root user (`gopher`) for enhanced security
- **Development Tools**: Git pre-installed
- **Working Directory**: `/app`
- **Up-to-date**: Latest security patches applied

## Image Details

- **Go Version**: 1.25
- **User**: gopher (non-root)
- **Working Directory**: /app (owned by gopher user)
- **Pre-installed Tools**:
  - Git
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
git clone <repository-url>
cd golang-docker
docker build -t joukojo/golang:latest .
```

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
