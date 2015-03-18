#!/bin/sh

. $HOME/devstack/openrc $@

echo "Setup key pair"
nova keypair-add --pub-key ~/.ssh/id_rsa.pub mykey || exit 1

echo "Setup nova security group"
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0 || exit 1
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0 || exit 1
