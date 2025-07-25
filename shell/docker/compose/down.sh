#! /bin/bash

COMPOSE_NAME=$1

docker compose -p ${COMPOSE_NAME} down
