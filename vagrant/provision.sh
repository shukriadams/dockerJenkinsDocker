#!/usr/bin/env bash
sudo apt-get update

# docker
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker vagrant

# force startup folder to vagrant project
echo "cd /vagrant" >> /home/vagrant/.bashrc
