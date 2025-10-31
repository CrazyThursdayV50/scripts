# /bin/bash
APP=$1
REPO_NAME=$2

docker buildx build \
	--output type=docker \
	--platform linux/amd64,linux/arm64 \
	-t ${APP}:local \
	-f ./docker/Dockerfile \
	.

docker tag ${APP}:local ${REPO_NAME}/${APP}:latest
docker push ${REPO_NAME}/${APP}:latest
