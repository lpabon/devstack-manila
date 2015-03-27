
fail() {
  echo $1
  exit 1
}

. $HOME/devstack/openrc demo demo

echo "Setup key pair"
nova keypair-add --pub-key ~/.ssh/id_rsa.pub mykey || exit 1

echo "Setup nova security group"
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0 || exit 1
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0 || exit 1

echo "Boot image"
ipnet=`ip netns | grep qdhcp`
nova boot --flavor m1.micro --image ubuntu_1204_nfs_cifs --key-name mykey --security-groups default myvm_ubuntu
sleep 5

echo "Create manila share network"
netid=`neutron net-list | grep -i private | awk '{print $2}'`
subnetid=`neutron subnet-list | grep -i private | awk '{print $2}'`
manila share-network-create --neutron-net-id $netid \
 	--neutron-subnet-id $subnetid \
	--name share_network_for_10xxx \
	--description "Share network for 10.0.0.0/24 subnet"
if [ $? -ne 0 ] ; then
	fail "Unable to create manila share network"
fi


echo "Create network share"
sharenet=`manila share-network-list | grep share_network_for_10 |  awk '{print $2}'`
manila create --name cinder_vol_share_using_nfs --share-network $sharenet  NFS 1
if [ $? -ne 0 ] ; then
	fail "Unable to create manila share"
fi

loop=1
while [ $loop -eq 1 ] ; do
	if manila list | grep available > /dev/null 2>&1 ; then
		echo " "
		loop=0
	fi
	sleep 1
	echo -n "."
done

echo "Allow access"
vmip=`nova list | grep private | awk '{print $12}' | cut -d= -f2`
shareid=`manila list | grep available | awk '{print $2}'`
share=`manila list | grep available | awk '{print $16}'`
manila access-allow $shareid ip $vmip
if [ $? -ne 0 ] ; then
	fail "Unable to allow access to share"
fi

echo "Ready"
echo " "
echo "Now type:"
echo "    sudo ip netns exec $ipnet ssh ubuntu@${vmip}"
echo "then"
echo "    sudo mount -t nfs -o vers=4 $share /mnt"



