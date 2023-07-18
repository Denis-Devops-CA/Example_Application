#! /usr/bin/env bash
# check if there is an instance running with the image name we are deploying
CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME" --format="{{.ID}}")


#if instance exists stop the instance

if [ "$CURRENT_INSTANCE" ]
then
   docker rm $(docker stop $CURRENT_INSTANCE)
fi

#pull down instance from docker hub
docker pull $IMAGE_NAME

#check if container exists
CONTAINER_EXISTS=$(docker ps -a | grep node_app )
if ["$CONTAINER_EXISTS"]
then
	docker rm node_app
fi



#create a container called node_app that is available on port 8443 from our docker image
docker create -p 8443:8443  --name node_app $IMAGE_NAME
#write private key to a file
echo $PRIVATE_KEY > privatekey.pem
#write the server key to a file
echo $SERVER > server.crt
#add the server key to the node-app docker container
docker cp ./privatekey.pem node_app:/privatekey.pem
#docker cp ./server.crt node_app:/server.crt
docker start node_app