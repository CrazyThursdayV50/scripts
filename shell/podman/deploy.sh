# /bin/bash
APP=$1
REMOTE_REPO=$2

podman tag ${APP}:local ${REMOTE_REPO}:latest
podman push ${REMOTE_REPO}:latest
