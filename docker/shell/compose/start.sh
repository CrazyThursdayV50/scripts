#! /bin/bash

PROJECT_NAME=$1
COMPOSE_FILE=$2
ENV_FILE=$3
SERVICE_NAME=$4

echo "project: $PROJECT_NAME"
echo "compose file: $COMPOSE_FILE"
echo "env file: $ENV_FILE"
echo "service name: $SERVICE_NAME"
docker compose -p ${PROJECT_NAME} -f ${COMPOSE_FILE} --env-file ${ENV_FILE} up -d ${SERVICE_NAME}
