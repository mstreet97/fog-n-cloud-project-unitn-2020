PROJECTN=mqtt_subscriber

. /home/stack/devstack/openrc
. ${PROJECTN}-openrc.sh

# Server creation
openstack server create \
--flavor micro.ubuntu \
--image ubuntu-bionic-18.04 \
--network subscriber_network \
--key-name eval \
--security-group default \
--user-data cloud-init-mosquitto_subscriber.sh \
subscriber_mqtt

# Floating IP assignment
FLOATING_IP=$(openstack floating ip create public --format json | jq -r -M '.name')
openstack server add floating ip subscriber_mqtt "${FLOATING_IP}"

# Add security groups
openstack server add security group subscriber_mqtt ssh-in
openstack server add security group subscriber_mqtt mqtt-in

echo mqtt_subscriber can be reached at ${FLOATING_IP}
