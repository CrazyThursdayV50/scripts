# /bin/bash
APP=$1
REMOTE_REPO=$2

docker tag ${APP}:local ${REMOTE_REPO}:latest
docker push ${REMOTE_REPO}:latest
