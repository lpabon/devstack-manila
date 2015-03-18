#!/bin/sh

echo "-- Create VM"
#vagrant up || exit 1
vagrant provision

echo "-- Create Box"
if [ -f package.box ] ; then
    rm -f package.box
fi
vagrant package || exit 1

echo "-- Update Vagrant"
if vagrant box list | grep devstack_manila ; then
    vagrant box remove devstack_manila || exit 1
fi

vagrant box add package.box devstack_manila || exit 1
rm -f package.box

echo "-- Done"
