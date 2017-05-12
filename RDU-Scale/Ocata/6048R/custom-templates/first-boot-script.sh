#!/usr/bin/env bash
if [[ `hostname` = *"ceph"* ]] || [[ `hostname` = *"osd-compute"* ]]
then
    echo "Number of disks detected: $(lsblk -no NAME,TYPE,MOUNTPOINT | grep "disk" | awk '{print $1}' | wc -l)"
    echo "Not performing any additional actions"
fi
