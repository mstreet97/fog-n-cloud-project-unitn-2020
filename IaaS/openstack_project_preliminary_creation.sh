. /home/stack/devstack/openrc
. /home/stack/devstack/accrc/admin/admin

USERNAME=student
PASSWORD=password
PROJECTN=weather_station

# Project creation
openstack project create \
  --description "Mqtt Subscribers for mosquitto broker in paas machine" \
  "${PROJECTN}"


###################################################################### stud user
# Stud user definition and addition to the project
openstack user create --password "${PASSWORD}" "${USERNAME}"
openstack role add --project "${PROJECTN}" --user "${USERNAME}" "member"

# Create openrc file
echo export OS_PROJECT_DOMAIN_NAME=default >> ${PROJECTN}-openrc.sh
echo export OS_USER_DOMAIN_NAME=default >> ${PROJECTN}-openrc.sh
echo export OS_PROJECT_NAME=${PROJECTN} >> ${PROJECTN}-openrc.sh
echo export OS_USERNAME=${USERNAME} >> ${PROJECTN}-openrc.sh
echo export OS_PASSWORD=${PASSWORD} >> ${PROJECTN}-openrc.sh
echo export OS_AUTH_URL=http://10.235.1.103/identity >> ${PROJECTN}-openrc.sh
echo export OS_IDENTITY_API_VERSION=3 >> ${PROJECTN}-openrc.sh


###################################################################### eval user
# Eval user definition and addition to the project
openstack user create --password "eval" "eval"
openstack role add --project "${PROJECTN}" --user "eval" "reader"

# Create openrc file
echo export OS_PROJECT_DOMAIN_NAME=default >> eval-${PROJECTN}-openrc.sh
echo export OS_USER_DOMAIN_NAME=default >> eval-${PROJECTN}-openrc.sh
echo export OS_PROJECT_NAME=${PROJECTN} >> eval-${PROJECTN}-openrc.sh
echo export OS_USERNAME=eval >> eval-${PROJECTN}-openrc.sh
echo export OS_PASSWORD=eval >> eval-${PROJECTN}-openrc.sh
echo export OS_AUTH_URL=http://10.235.1.103/identity >> eval-${PROJECTN}-openrc.sh
echo export OS_IDENTITY_API_VERSION=3 >> eval-${PROJECTN}-openrc.sh



# Ubuntu image creation
wget -P /var/tmp -c https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
openstack image create --disk-format qcow2 --container-format bare --public \
--file /var/tmp/bionic-server-cloudimg-amd64.img \
ubuntu-bionic-18.04

# Flavour creation
openstack flavor create --ram 512 --disk 5  --ephemeral 5 --vcpus 1 --public micro.ubuntu

# Source openrc file
. ${HOME}/${PROJECTN}-openrc.sh

# Network creation
openstack network create subscriber_network
openstack subnet create --network subscriber_network \
    --subnet-range 10.11.12.0/24 \
    --dns-nameserver 208.67.222.222 \
    --dns-nameserver 208.67.220.220 \
    subscriber_subnet
openstack router create subscriber_router
# Add the router to the subnet
openstack router add subnet subscriber_router subscriber_subnet
# Attach the router to the external network (public) as gateway
openstack router set --external-gateway public subscriber_router

# Security group creation
openstack security group create ssh-in
openstack security group create mqtt-in
openstack security group rule create ssh-in \
    --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
openstack security group rule create mqtt-in \
    --protocol tcp --dst-port 1883:1883 --remote-ip 0.0.0.0/0

# Generate key
 mkdir -p "${HOME}/.ssh"
 ssh-keygen -t rsa -b 4096 -N "" \
 -C "${NAME:=eval}" \
 -f "${HOME}"/.ssh/id_rsa

# Create keypair
openstack keypair create --public-key "${HOME}/.ssh/id_rsa.pub" eval

# Finish
echo Preliminary settings established, plese use the instance creation script now.
