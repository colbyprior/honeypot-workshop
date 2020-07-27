#!/usr/bin/bash

# tanner pre-build
cd ~/tanner/docker/
docker-compose build

# thug pre-build
cd ~/thug/docker/
# add to dockerfile apt installs:
#    vim \
#    jq \
#    nano \
#    less \
docker build --tag thug:demo .

# cowrie pre-build
cd ~/docker-cowrie
docker-compose build

cd ~/
ln -s /var/lib/docker/volumes/ ~/volumes
chown -R ubuntu /var/lib/docker/volumes
