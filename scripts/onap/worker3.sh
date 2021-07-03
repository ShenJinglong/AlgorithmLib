#!/bin/bash

usage () {
    echo "Usage:"
    echo "   ./$(basename $0) nfs_master_ip"
    exit 1
}

if [ "$#" -ne 1 ]; then
    echo "Missing NFS master node"
    usage
fi

MASTER_IP=$1

sudo apt-get update
sudo apt-get install -y nfs-common

sudo mkdir -p /dockerdata-nfs

sudo mount $MASTER_IP:/dockerdata-nfs /dockerdata-nfs/
echo "$MASTER_IP:/dockerdata-nfs /dockerdata-nfs nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | sudo tee -a /etc/fstab

echo "Next script 'master5.sh'"