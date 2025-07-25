#! /bin/bash

COMPOSE_NAME=$1

podman compose -p ${COMPOSE_NAME} down
