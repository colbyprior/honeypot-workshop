#!/usr/bin/bash

# tanner pre-build
cd ~/tanner/docker/
docker-compose build

# thug pre-build
cd ~/thug/docker/
docker build .

# cowrie pre-build
cd ~/docker-cowrie
docker-compose build
