FROM golang:1.25-trixie

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y git && \
    useradd -m gopher && \
    chown -R gopher:gopher /app /go 

USER gopher
RUN     go install golang.org/x/vuln/cmd/govulncheck@latest

