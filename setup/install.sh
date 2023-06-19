#!/usr/bin/bash

# install
sudo apt update
sudo apt install -y docker.io docker-compose jq git nano sqlite3 python3-dev python3-pip python3-virtualenv python3-venv python3-scapy samba libpcap-dev

# clone repos
git clone https://github.com/cowrie/cowrie.git
git clone https://github.com/buffer/thug.git
git clone https://github.com/mushorg/snare.git
git clone https://github.com/mushorg/tanner.git
git clone https://github.com/colbyprior/honeypot-workshop.git

# docker permissions
sudo usermod -aG docker ${USER}
newgrp docker

# install opencanary
virtualenv venv/
. venv/bin/activate
pip install opencanary scapy pcapy

mkdir ~/tanner/docker/log
chmod 7777 ~/tanner/docker/log
cp docker-compose_tanner.yml ~/tanner/docker/docker-compose.yml
