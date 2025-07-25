# /bin/bash
APP=$1
TAG=$(git describe --tags)

# 获取 id
CONTAINER_ID=$(docker ps -a|grep ${APP}|awk '{print $1}')

# 把符合 name 的所有 container stop，并且 remove
docker stop ${CONTAINER_ID}
docker container rm ${CONTAINER_ID}
