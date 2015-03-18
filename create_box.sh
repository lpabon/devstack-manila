#!/bin/sh

echo "-- Create VM"
vagrant up || exit 1
sleep 10

echo "-- Create Box"
if [ -f package.box ] ; then
    rm -f package.box
fi
vagrant package || exit 1

echo "-- Update Vagrant"
if vagrant box list | grep devstack_manila ; then
    vagrant box remove devstack_manila || exit 1
fi

vagrant box add devstack_manila package.box || exit 1
rm -f package.box

echo "-- Done"
