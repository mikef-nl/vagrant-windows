#!/usr/bin/env bash
 
# set proxy variables
#export http_proxy=http://myproxy.com:8080
#export https_proxy=https://myproxy.com:8080
 
# install pip, then use pip to install ansible
sudo yum install epel-release -y
sudo yum install ansible -y
sudo yum install python-pip -y
sudo yum install python-wheel -y
sudo yum install vim -y
sudo pip install pywinrm
 
# fix permissions on private key file
chmod 600 /home/vagrant/.ssh/id_rsa
 
# add subject host to known_hosts (IP is defined in Vagrantfile)
ssh-keyscan -H 192.168.100.20 >> /home/vagrant/.ssh/known_hosts
chown vagrant:vagrant /home/vagrant/.ssh/known_hosts
 
# create ansible hosts (inventory) file
mkdir -p /etc/ansible/
mkdir -p /etc/ansible/group_vars