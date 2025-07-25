#! /bin/bash
APP=$1

IMAGES=$(podman images|grep ${APP}|grep none|awk '{ print $3}')

for IMAGE in $IMAGES
do
  podman image rm $IMAGE
done
