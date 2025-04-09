#! /bin/bash

COMPOSE_NAME=$1
SERVICE_NAME=$2

docker compose -p ${COMPOSE_NAME} stop ${SERVICE_NAME}
docker compose -p ${COMPOSE_NAME} rm -f ${SERVICE_NAME}
