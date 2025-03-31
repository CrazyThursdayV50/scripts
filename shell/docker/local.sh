# /bin/bash
APP=$1
DOCKERFILE=$2

docker build\
	-f ${DOCKERFILE}\
	-t ${APP}:local\
	.
