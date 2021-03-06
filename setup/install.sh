#!/usr/bin/bash

# install
sudo apt update
sudo apt install -y docker.io docker-compose jq git nano sqlite3 python3-dev python3-pip python3-virtualenv python3-venv python3-scapy samba libpcap-dev

# clone repos
git clone https://github.com/cowrie/docker-cowrie
git clone https://github.com/cowrie/cowrie.git
git clone https://github.com/buffer/thug.git
git clone https://github.com/mushorg/snare.git
git clone https://github.com/mushorg/tanner.git
git clone https://github.com/colbyprior/honeypot-workshop.git
git clone https://github.com/thinkst/opencanary.git

# elasticsearch setup
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.7.0-amd64.deb
sudo dpkg -i filebeat-7.7.0-amd64.deb
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update 
sudo apt-get install elasticsearch kibana -y

# docker permissions
sudo usermod -aG docker ${USER}
newgrp docker

# install opencanary
virtualenv env/
. env/bin/activate
pip install opencanary scapy pcapy

mkdir ~/tanner/docker/log
chmod 7777 ~/tanner/docker/log
cp docker-compose_tanner.yml ~/tanner/docker/docker-compose.yml