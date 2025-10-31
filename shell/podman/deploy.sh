# /bin/bash
APP=$1
REMOTE_REPO=$2

podman buildx build \
	--output type=docker \
	--platform linux/amd64,linux/arm64 \
	-t ${APP}:local \
	-f ./docker/Dockerfile \
	.

podman tag ${APP}:local ${REPO_NAME}/${APP}:latest
podman push ${REPO_NAME}/${APP}:latest
