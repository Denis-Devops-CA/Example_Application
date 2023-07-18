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
echo "image pulled :OK"

#check if container exists
CONTAINER_EXISTS=$(docker ps -a | grep node_app )
if [ "$CONTAINER_EXISTS" ]
	
then
	echo "container exists -> remove container"
	docker rm node_app
fi

echo "creating new container...."
#create a container called node_app that is available on port 8443 from our docker image
docker create -p 8443:8443 --name node_app $IMAGE_NAME

CONTAINER_EXISTS=$(docker ps -a | grep node_app )
if [ "$CONTAINER_EXISTS" ]
	
then
	echo "container exists...."
	
	
fi


echo "writing private key"
#write private key to a file
echo $PRIVATE_KEY > privatekey.pem

echo "writing server key..."
#write the server key to a file
echo $SERVER > server.crt

echo "add private key  to node-app docker container...."
#add the private key to the node-app docker container
docker cp ./privatekey.pem node_app:/privatekey.pem

echo "add server key"
docker cp ./server.crt node_app:/server.crt

echo "start node_app"
docker start node_app
