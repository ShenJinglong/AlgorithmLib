#!/bin/bash

usage () {
    echo "Usage:"
    echo "   ./$(basename $0) node1_ip node2_ip ... nodeN_ip"
    exit 1
}

if [ "$#" -lt 1 ]; then
    echo "Missing NFS slave nodes"
    usage
fi

sudo apt-get update
sudo apt-get install -y nfs-kernel-server

sudo mkdir -p /dockerdata-nfs
sudo chmod 777 -R /dockerdata-nfs
sudo chown nobody:nogroup /dockerdata-nfs/

NFS_EXP=""
for i in $@; do
    NFS_EXP+="$i(rw,sync,no_root_squash,no_subtree_check) "
done
echo "/dockerdata-nfs "$NFS_EXP | sudo tee -a /etc/exports

sudo exportfs -a
sudo systemctl restart nfs-kernel-server

echo "Next script 'worker3.sh'"
echo "worker3.sh <master_ip>"