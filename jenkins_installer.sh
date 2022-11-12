#!/bin/bash

#this script will help you install jenkins by first installing docker, then downloading and running the jenkins container in docker

#first we install docker

sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

    sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo usermod -aG docker ubuntu
  newgrp docker

#configure docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

docker run hello-world

# get jenkins docker image and run the jenkins container in docker
mkdir -p /var/jenkins_home
chown -R 1000:1000 /var/jenkins_home/
docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -d --name jenkins jenkins/jenkins:lts

# show jenkins endpoint
echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -4 -s ifconfig.co)':8080'
