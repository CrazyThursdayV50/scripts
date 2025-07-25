#! /bin/bash

COMPOSE_NAME=$1
SERVICE_NAME=$2

podman compose -p ${COMPOSE_NAME} restart ${SERVICE_NAME}
