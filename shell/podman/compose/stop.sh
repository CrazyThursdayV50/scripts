#! /bin/bash

COMPOSE_NAME=$1
SERVICE_NAME=$2

podman compose -p ${COMPOSE_NAME} stop ${SERVICE_NAME}
# podman compose -p ${COMPOSE_NAME} rm -f ${SERVICE_NAME}
