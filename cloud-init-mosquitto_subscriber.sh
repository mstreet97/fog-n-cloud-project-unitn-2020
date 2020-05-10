#!/bin/bash
# Example script to run at first boot via Openstack
# using userdata and cloud-init.
# It will install mosquitto mqtt clients and dependancies
# and subscribe to the weather station thread.
#NOTE: do not run by itself, we need to specify the hostname of the mosquitto mqtt broker
#running inside the kubernetes cluster in the paas machine

apt-get update
apt-get install -y wget software-properties-common
apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
apt-get update
apt-get install -y mosquitto mosquitto-clients
ip route add 172.17.0.0/24 via 10.235.1.203 #To reach the paas machine
mosquitto_sub -h HOSTNAME -t weatherStation  

exit 0