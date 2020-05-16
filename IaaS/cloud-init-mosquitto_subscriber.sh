#!/bin/bash

apt-get update
apt-get install -y wget software-properties-common
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
apt-get update
apt-get install -y mosquitto mosquitto-clients
mosquitto_sub -h 172.17.0.2 -p 30000 -t weatherStation

exit 0
