. /home/stack/devstack/openrc; . /home/stack/devstack/accrc/admin/admin #is sourcing as admin correct in this case? I think so because we are creating the whole project

DEMO_USERNAME=stud
DEMO_PASSWORD=stud_password
DEMO_PROJECTN=mqtt_subscriber

# Project creation
openstack project create \
  --description "Mqtt Subscriber for mosquitto broker in paas machine" \
  "${DEMO_NAME}"

# Stud user definition and addition to the project
openstack user create --password "${DEMO_PASSWORD}" "${DEMO_USERNAME}"
openstack role add --project "${DEMO_PROJECTN}" --user "${DEMO_USERNAME}" "member"

# Ubuntu image creation
wget -P /var/tmp -c https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
openstack image create --disk-format qcow2 --container-format bare --public \
--file /var/tmp/bionic-server-cloudimg-amd64.img \
ubuntu-bionic-18.04

# Flavour creation 
openstack flavor create --ram 512 --disk 5  --ephemeral 5 --vcpus 1 --public micro.ubuntu

# Network creation
openstack network create subscriber_network
openstack subnet create --network subscriber_network \
    --subnet-range 10.11.12.0/24 \
    --dns-nameserver 208.67.222.222 \
    --dns-nameserver 208.67.220.220 \
    subscriber_subnet
openstack router create subscriber_router
3.3 External Network
Assuming the existence of an external-subnet named public:
# Add the router to the subnet
openstack router add subnet subscriber_router subscriber_subnet
# Attach the router to the external network (public) as gateway
openstack router set --external-gateway public subscriber_router

# Security group creation
openstack security group rule create ssh-in \
    --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
openstack security group rule create mqtt-in \
    --protocol tcp --dst-port 1883:1883 --remote-ip 0.0.0.0/0

# Finish
echo Preliminary settings established, plese use the instance creation script now.