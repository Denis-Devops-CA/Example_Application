#! /usr/bin/env bash
# check if there is an instance running with the image name we are deploying
CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME" --format="{{.ID}}")


#if instance exists stop the instance

if [ "$CURRENT_INSTANCE" ]
then
	echo "container exists"
   docker rm $(docker stop $CURRENT_INSTANCE)
else echo "container does not exist"
fi

#pull down instance from docker hub
docker pull $IMAGE_NAME
echo "image pulled :OK"

IMAGE_EXISTS=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "$IMAGE_NAME")
if [ -n "$IMAGE_EXISTS" ]; then
    echo "Image '$IMAGE_NAME' exists."
else
    echo "Image '$IMAGE_NAME' does not exist."
fi

