#!/bin/bash
# User Data script used to setup the target CA host. This could also be done
# using a configuration management tool such as Chef, Ansible, etc.

echo "Update packages and install vault-ssh-helper"
apt-get update
apt-get install -y unzip

echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config
#this is not working for me need to figure out how to make it work without manual interference
curl -o /etc/ssh/trusted-user-ca-keys.pem https://vault.wendyinsight.com/v1/ssh/public_key
chmod 600 /etc/ssh/trusted-user-ca-keys.pem
service sshd stop
service sshd start
