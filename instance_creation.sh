. /home/stack/devstack/openrc; . /home/stack/devstack/accrc/admin/admin #is sourcing as admin correct in this case? I think so because we are creating the whole project

# Server creation
openstack server create \
--flavor micro.ubuntu \
--image ubuntu-bionic-18.04 \
--network subscriber_network \
--key-name demo_keypair \ # Which keypair in this case? Should we upload our own and add them manually?
--security-group default \
--user-data cloud-init-mosquitto_subscriber.sh # NOTE: MUST be in the same folder
subscriber_mqtt

# Floating IP assignment
openstack floating ip create public
FLOATING_IP=$(openstack floating ip create public --format json | jq -r -M '.name')
openstack server add floating ip subscriber_mqtt "${FLOATING_IP}"

# Add security groups
openstack server add security group subscriber_mqtt ssh-in
openstack server add security group subscriber_mqtt mqtt-in