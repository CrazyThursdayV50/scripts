COMPOSE_NAME="jaeger"
DOCKER_SCRIPT_PATH=../../shell/docker/compose

up-docker:
	@echo "Initializing docker ${COMPOSE_NAME}..."
	@${DOCKER_SCRIPT_PATH}/up.sh ${COMPOSE_NAME} compose.yml .env

down-docker:
	@echo "Cleaning docker ${COMPOSE_NAME}..."
	@${DOCKER_SCRIPT_PATH}/down.sh ${COMPOSE_NAME} compose.yml .env

PODMAN_SCRIPT_PATH=../../shell/podman/compose
up-podman:
	@echo "Initializing podman ${COMPOSE_NAME}..."
	@${PODMAN_SCRIPT_PATH}/up.sh ${COMPOSE_NAME} compose.yml .env

down-podman:
	@echo "Cleaning podman ${COMPOSE_NAME}..."
	@${PODMAN_SCRIPT_PATH}/down.sh ${COMPOSE_NAME} compose.yml .env
