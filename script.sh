#!/bin/bash
echo "Install nginx web server"
echo y | sudo amazon-linux-extras install nginx1
echo "Start nginx web server"
sudo systemctl start nginx
echo "check nginx is running"

echo $(ps aux | grep nginx)
