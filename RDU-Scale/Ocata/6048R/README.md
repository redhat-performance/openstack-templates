# Heat Templates for HCI 6048Rs + R620s + R630s 

## Hardware 

Allocated 52 nodes to test Hyper-converged Infrastructure (HCI) for
OSP11 RC: 

Dell R620s (1 undercloud, 3 controllers + 9 computes)
- 13 nodes (was 14 but c01-h03-r620 has a bad NIC)
- 64G RAM
- 24 vCPUs
- 1TB HDD (1)
- em3 by foreman (em4 no link)
- em{1,2} @ 10G

Dell R630s (10 computes)
- 10 nodes
- 128G RAM
- 56 vCPUs
- 1TB HDD (2)
- p2p1 by foreman 
- em{1,2,3,4} @ 10G 

Supermicro 6048s (30 hci-computes w/ 34 OSDs)
- 30 nodes
- 256GB RAM 
- 56 vCPUs
- 1.8T HDD (34)
- 745G NVMe (2)
- enp5s0f0 @ 1G by foreman (enp5s0f1 - no link light)
- ens3f{0,1} @ 40G

## Deployment

I used [deploy.sh](deploy.sh) to deploy a [33 node overcloud](33nodes.txt) with:

- 30 HCI Compute/OSD servers
- 3 Controller/Mon servers

I did the above in one deploy command: 

```
[stack@b10-h25-r620 ~]$ ./deploy.sh
...
2017-05-12 17:06:44Z [ControllerPostPuppetRestart]: CREATE_IN_PROGRESS  state changed
2017-05-12 17:07:15Z [ControllerPostPuppetRestart]: CREATE_COMPLETE  state changed
2017-05-12 17:07:15Z [overcloud.AllNodesDeploySteps.ControllerPostPuppet]: CREATE_COMPLETE  Stack CREATE completed successfully
2017-05-12 17:07:16Z [overcloud.AllNodesDeploySteps.ControllerPostPuppet]: CREATE_COMPLETE  state changed
2017-05-12 17:07:16Z [overcloud.AllNodesDeploySteps]: CREATE_COMPLETE  Stack CREATE completed successfully
2017-05-12 17:07:17Z [overcloud.AllNodesDeploySteps]: CREATE_COMPLETE  state changed
2017-05-12 17:07:17Z [overcloud]: CREATE_COMPLETE  Stack CREATE completed successfully

 Stack overcloud CREATE_COMPLETE 

/home/stack/.ssh/known_hosts updated.
Original contents retained as /home/stack/.ssh/known_hosts.old
Overcloud Endpoint: http://172.21.0.10:5000/v2.0
Overcloud Deployed

real    166m37.468s
user    0m14.760s
sys     0m1.142s
[stack@b10-h25-r620 ~]$ 
```

1020 OSDs were active:

```
[root@overcloud-controller-2 ~]# ceph -s
    cluster eb2bb192-b1c9-11e6-9205-525400330666
     health HEALTH_WARN
            clock skew detected on mon.overcloud-controller-1, mon.overcloud-controller-0
            Monitor clock skew detected 
     monmap e1: 3 mons at {overcloud-controller-0=172.18.0.17:6789/0,overcloud-controller-1=172.18.0.14:6789/0,overcloud-controller-2=172.18.0.10:6789/0}
            election epoch 6, quorum 0,1,2 overcloud-controller-2,overcloud-controller-1,overcloud-controller-0
     osdmap e527: 1020 osds: 1020 up, 1020 in
            flags sortbitwise,require_jewel_osds
      pgmap v1414: 28736 pgs, 8 pools, 0 bytes data, 0 objects
            220 GB used, 1854 TB / 1854 TB avail
               28736 active+clean
[root@overcloud-controller-2 ~]# 
```

The HCI overcloud had:

- 7.8 TB RAM 
- 1680 Cores
- 1.8 PB raw storage

I then incremented the compute count from 0 to 19
in [layout.yaml](custom-templates/layout.yaml) to add 19 non-HCI
compute nodes and re-ran the same [deploy.sh](deploy.sh) to scale 
to a [52 node overcloud](52nodes.txt) with mixed HCI and non-HCI
computes. 

## Heat Templates

See [custom-templates](custom-templates) to see the TripleO Heat
Templates that were used to do the deployment. 

## Ironic Profiles

I modified the instackenv.json I was issued with the servers in order
to remove the node to be used as the undercloud. I also used a script 
to set the name property for each node so that I could easily look at 
`openstack server list` to know if a server was an R620, R630 or 6048:

```
[stack@b10-h25-r620 ~]$ grep name instackenv.json 
	    "name": "b10-h26-r620",
	    "name": "b10-h27-r620",
	    "name": "c01-h01-r620",
		...
	    "name": "c04-h01-6048r",
	    "name": "c04-h05-6048r",
		...
	    "name": "c09-h27-r630",
[stack@b10-h25-r620 ~]$ 
```

I used these names to set the Ironic profiles with the 
[ironic-assign.sh](ironic-assign.sh) script. 

```
./ironic-assign.sh r6 compute
./ironic-assign.sh b10 control
./ironic-assign.sh c01-h01-r620 control
./ironic-assign.sh 6048 ceph-storage
```

The above names correspond to the their flavors for predictable node
assignment as set in [layout.yaml](custom-templates/layout.yaml). 

## Introspection

- Introspecting in batches of 20 nodes at a time took 40 minutues for the 52 nodes total using [Joe's Introspection Batching Script](https://gist.githubusercontent.com/jtaleric/59a36b959796d33ea507/raw/fab0c0e1e20376fb60fffd39e01539b339e4c440/scale-introspect.sh) 
- Why batch at 20 nodes? See [https://review.openstack.org/#/c/439568/](https://review.openstack.org/#/c/439568/)

## Hard Drives

- Ironic node cleaning was enabled as described in a [Newton deployment](https://github.com/redhat-performance/openstack-templates/tree/master/RDU-Scale/Newton/R730xdHciDpdk)
- For Ocata I only had to set `automated_clean = True` and restart the conductor as the `ironic.conf` had more defaults for cleaning than Newton.
- Set the root device `openstack baremetal configure boot --root-device=smallest`
- Note in [custom-templates/ceph.yaml](custom-templates/ceph.yaml) that disks are assigned by using path names as their simpler device name (e.g. /dev/sdX) is not consistent between re-imagining on this hardware.


## Heat Templates

The Heat templates in [custom-templates](custom-templates/) are a derivative work of the [templates](https://github.com/RHsyseng/hci) provided with the [OSP10 HCI Reference Architecture](https://access.redhat.com/documentation/en-us/reference_architectures/2017/html/hyper-converged_red_hat_openstack_platform_10_and_red_hat_ceph_storage_2/).

```
git clone git@github.com:RHsyseng/hci.git
cp -r hci/custom-templates/ ~/
cd ~/custom-templates
rm custom-roles.yaml.10 
mv custom-roles.yaml.11 custom-roles.yaml
```


