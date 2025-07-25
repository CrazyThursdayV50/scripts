# /bin/bash
APP=$1
DOCKERFILE=$2

podman build\
	-f ${DOCKERFILE}\
	-t ${APP}:local\
	.
