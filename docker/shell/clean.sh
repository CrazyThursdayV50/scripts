#! /bin/bash
APP=$1

IMAGES=$(docker images|grep ${APP}|grep none|awk '{ print $3}')

for IMAGE in $IMAGES
do
  docker image rm $IMAGE
done
