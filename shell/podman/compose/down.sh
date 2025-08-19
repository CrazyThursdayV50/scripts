#! /bin/bash

PROJECT_NAME=$1
COMPOSE_FILE=$2

echo "project: $PROJECT_NAME"
echo "compose file: $COMPOSE_FILE"
podman compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} down
