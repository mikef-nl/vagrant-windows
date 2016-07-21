#!/usr/bin/env bash
 
# set proxy variables
#export http_proxy=http://myproxy.com:8080
#export https_proxy=https://myproxy.com:8080
 
# install pip, then use pip to install ansible
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install python-setuptools python-dev build-essential libssl-dev -y
sudo easy_install pip
sudo pip install --upgrade setuptools
sudo pip install ansible
sudo pip install pywinrm==0.2.0
 
# fix permissions on private key file
chmod 600 /home/vagrant/.ssh/id_rsa
 
# add subject host to known_hosts (IP is defined in Vagrantfile)
ssh-keyscan -H 192.168.100.20 >> /home/vagrant/.ssh/known_hosts
chown vagrant:vagrant /home/vagrant/.ssh/known_hosts
 
# create ansible hosts (inventory) file
mkdir -p /etc/ansible/