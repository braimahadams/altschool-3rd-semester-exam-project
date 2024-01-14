#!/bin/bash
    sudo apt-get update -y
    sudo apt-get install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo apt install ansible -y
    sudo usermod -aG docker ubuntu
    docker run -p 8080:80 nginx
    