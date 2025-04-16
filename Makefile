gen-certs:
	cd ./cert && sh -c "./gen.sh"

DOCKER_DIR=./docker
DOCKER_SHELL_DIR=${DOCKER_DIR}/shell
DOCKER_SHELL_COMPOSE_DIR=${DOCKER_SHELL_DIR}/compose

DOCKER_NETWORK_DIR=${DOCKER_DIR}/network
NETWORK_COMPOSE_NAME="hello-world"
docker-network-init:
	@echo "Initializing Docker network..."
	@${DOCKER_SHELL_COMPOSE_DIR}/start.sh ${NETWORK_COMPOSE_NAME} ${DOCKER_NETWORK_DIR}/compose.yml ${DOCKER_NETWORK_DIR}/.env
docker-network-clean:
	@echo "Cleaning Docker network..."
	@${DOCKER_SHELL_COMPOSE_DIR}/down-compose.sh ${NETWORK_COMPOSE_NAME} ${DOCKER_NETWORK_DIR}/compose.yml ${DOCKER_NETWORK_DIR}/.env

DOCKER_MYSQL_DIR=${DOCKER_DIR}/mysql
MYSQL_SERVICE_NAME="mysql"
docker-mysql-start:
	@echo "Starting Docker MySQL..."
	@${DOCKER_SHELL_COMPOSE_DIR}/start.sh ${MYSQL_SERVICE_NAME} ${DOCKER_MYSQL_DIR}/compose.yml ${DOCKER_MYSQL_DIR}/.env
docker-mysql-down:
	@echo "Stopping Docker MySQL..."
	@${DOCKER_SHELL_COMPOSE_DIR}/down-compose.sh ${MYSQL_SERVICE_NAME} ${DOCKER_MYSQL_DIR}/compose.yml ${DOCKER_MYSQL_DIR}/.env

DOCKER_REDIS_DIR=${DOCKER_DIR}/redis
REDIS_SERVICE_NAME="redis"
docker-redis-start:
	@echo "Starting Docker Redis..."
	@${DOCKER_SHELL_COMPOSE_DIR}/start.sh ${REDIS_SERVICE_NAME} ${DOCKER_REDIS_DIR}/compose.yml ${DOCKER_REDIS_DIR}/.env
docker-redis-down:
	@echo "Stopping Docker Redis..."
	@${DOCKER_SHELL_COMPOSE_DIR}/down-compose.sh ${REDIS_SERVICE_NAME} ${DOCKER_REDIS_DIR}/compose.yml ${DOCKER_REDIS_DIR}/.env

DOCKER_JAEGER_DIR=${DOCKER_DIR}/jaeger
JAEGER_SERVICE_NAME="jaeger"
docker-jaeger-start:
	@echo "Starting Docker Jaeger..."
	@${DOCKER_SHELL_COMPOSE_DIR}/start.sh ${JAEGER_SERVICE_NAME} ${DOCKER_JAEGER_DIR}/compose.yml ${DOCKER_JAEGER_DIR}/.env
docker-jaeger-down:
	@echo "Stopping Docker Jaeger..."
	@${DOCKER_SHELL_COMPOSE_DIR}/down-compose.sh ${JAEGER_SERVICE_NAME} ${DOCKER_JAEGER_DIR}/compose.yml ${DOCKER_JAEGER_DIR}/.env

DOCKER_ELASTIC_DIR=${DOCKER_DIR}/elastic
ELASTIC_SERVICE_NAME="elastic"
docker-elastic-start:
	@echo "Starting Docker Elastic..."
	@${DOCKER_SHELL_COMPOSE_DIR}/start.sh ${ELASTIC_SERVICE_NAME} ${DOCKER_ELASTIC_DIR}/compose.yml ${DOCKER_ELASTIC_DIR}/.env
docker-elastic-down:
	@echo "Stopping Docker Elastic..."
	@${DOCKER_SHELL_COMPOSE_DIR}/down-compose.sh ${ELASTIC_SERVICE_NAME} ${DOCKER_ELASTIC_DIR}/compose.yml ${DOCKER_ELASTIC_DIR}/.env

DOCKER_CADDY_DIR=${DOCKER_DIR}/caddy
CADDY_SERVICE_NAME="caddy"
docker-caddy-start:
	@echo "Starting Docker Elastic..."
	@${DOCKER_SHELL_COMPOSE_DIR}/start.sh ${CADDY_SERVICE_NAME} ${DOCKER_CADDY_DIR}/compose.yml ${DOCKER_CADDY_DIR}/.env
docker-caddy-down:
	@echo "Stopping Docker Elastic..."
	@${DOCKER_SHELL_COMPOSE_DIR}/down-compose.sh ${CADDY_SERVICE_NAME} ${DOCKER_CADDY_DIR}/compose.yml ${DOCKER_CADDY_DIR}/.env
