#! /usr/bin/env bash
sudo apt update && sudo apt install nodejs npm
#install pm2
sudo npm install -g pm2
#stop any instance of the application running
pm2 stop example_app
cd ExampleApp_wk7https/
#install dependencies
npm install
echo $PRIVATE_KEY > privatekey.pem
echo $SERVER > server.crt
#start application
pm2 start ./bin/www -n example_app