#! /bin/bash
COMPOSE_FILE=$1
ENV_FILE=$2
IMAGE_NAME=$3

docker compose -f ${COMPOSE_FILE} --env-file ${ENV_FILE} pull ${IMAGE_NAME}
