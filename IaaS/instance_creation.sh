PROJECTN=mqtt_subscriber

. /home/stack/devstack/openrc
. ${PROJECTN}-openrc.sh

################################################## mosquitto subscriber creation
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

echo subscriber_mqtt can be reached at ${FLOATING_IP}



#################################################### isAlive subscriber creation
openstack server create \
--flavor micro.ubuntu \
--image ubuntu-bionic-18.04 \
--network subscriber_network \
--key-name eval \
--security-group default \
--user-data cloud-init-mosquitto_subscriber_isAlive.sh \
subscriber_mqtt_isAlive

# Floating IP assignment
FLOATING_IP2=$(openstack floating ip create public --format json | jq -r -M '.name')
openstack server add floating ip subscriber_mqtt_isAlive "${FLOATING_IP2}"

# Add security groups
openstack server add security group subscriber_mqtt_isAlive ssh-in
openstack server add security group subscriber_mqtt_isAlive mqtt-in

echo subscriber_mqtt_isAlive can be reached at ${FLOATING_IP2}
