init-builder:
	@docker buildx create \
  --name multiarch-builder \
  --driver docker-container \
  --use

.PHONY: init-builder build-amd64 build-arm64 run-amd64 run-arm64
build-amd64:
	docker buildx build --pull --platform linux/amd64 --load -t golang-local:amd64 .

build-arm64:
	docker buildx build --pull --platform linux/arm64 --load -t golang-local:arm64 .

run-amd64: build-amd64
	docker run --rm -it --platform linux/amd64 golang-local:amd64

run-arm64: build-arm64
	docker run --rm -it --platform linux/arm64 golang-local:arm64
