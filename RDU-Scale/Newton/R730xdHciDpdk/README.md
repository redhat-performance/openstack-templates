Heat Templates for HCI/DPDK Overcloud with R730XD Nodes
=======================================================

These templates can be used for deploying an overcloud with the
following command (see also [deploy.sh](deploy.sh)).

```
openstack overcloud deploy --templates \
  -r ~/custom-templates/custom-roles.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/storage-environment.yaml \
  -e ~/custom-templates/network.yaml \
  -e ~/custom-templates/ceph.yaml \
  -e ~/custom-templates/nova.yaml \
  -e ~/custom-templates/dpdk.yaml \
  -e ~/custom-templates/layout.yaml 
```

It is assumed that the command is executed from `/home/stack` and the
configuration files in this directory are all present in
`/home/stack/custom-templates` on the undercloud.

These templates were used with an undercloud which was deployed using [ops-tools](https://github.com/redhat-performance/ops-tools/tree/master/ansible/undercloud) with [hosts](undercloud/hosts) and [vars/main.yml](undercloud/vars/main.yml) added to set `local_interface = em2`.

Ironic
------

Ironic Metadata Disk Cleaning was used instead of a first-boot zap
disk. This was not via TripleO's "clean_nodes=True" param but purely a
change in Ironic. 

Identify the neutron UUID of the TripleO ctlplane:

```
[stack@c10-h01-r730xd ~]$ neutron net-list
+--------------------------------------+----------+----------------------------------------+
| id                                   | name     | subnets                                |
+--------------------------------------+----------+----------------------------------------+
| 40a26da2-bcc6-47c9-b308-49c8d6911f8d | ctlplane | 5541d13e-3d44-442b-b2c3-1c99bc959861   |
|                                      |          | 192.0.2.0/24                           |
+--------------------------------------+----------+----------------------------------------+
[stack@c10-h01-r730xd ~]$ 
```
Modify ironic.conf:
```
    [conductor]
    automated_clean = True
    [deploy]
    erase_devices_priority = 0
    erase_devices_metadata_priority = 10
    [neutron]
    cleaning_network_uuid = $UUID
```
For example:
```
[root@c10-h01-r730xd ironic]# egrep "clean|erase" /etc/ironic/ironic.conf | egrep -v \#
automated_clean = True
erase_devices_priority = 0
erase_devices_metadata_priority = 10
cleaning_network_uuid = 40a26da2-bcc6-47c9-b308-49c8d6911f8d
[root@c10-h01-r730xd ironic]# 
```
Bounce the ironic conductor service.
```
systemctl restart openstack-ironic-conductor.service
```
Once that's done, merely trying to put the nodes into the ironic state
"available" will put them in the "cleaning" state first and then clean
the disks before they finally get set to the "available" state. I set
the state on my nodes out of available and back with the following:

```
for ironic_id in $(ironic node-list | awk {'print $2'} | grep -v UUID | egrep -v '^$'); do
     ironic node-set-provision-state $ironic_id manage; 
done 

for ironic_id in $(ironic node-list | awk {'print $2'} | grep -v UUID | egrep -v '^$'); do 
     ironic node-set-provision-state $ironic_id provide; 
done
```

Simply by doing the above to bash loops the nodes were booted on a ram
disk and every disk, including the root disk (e.g. /dev/sda), had its
metadata removed. 

Network
-------

The network is defined in [network.yaml](custom-templates/network.yaml).
The [compute node templates](custom-templates/nic-configs/r730-osd-compute.yaml)
use the following NICs for the following purposes:

- em1 10G ceph (storage, storage_mgmt) and cloud (vxlan tenant, internal api)
- em2 10G provisioning OSPd and undercloud control plane 
- em3 1G provisioning foreman (only used to deploy director)
- em4 1G link not detected
- p4p1 10G dpdk0
- p4p2 10G dpdk1

`ovs_bridge` was not mixed with `ovs_user_bridge` for DPDK performance
so traditional VLANs were used to isolate networks and the tenant
network was not used in favor of using provider networks. The Ceph
networks would be more isolated if possible. 

Hyperconverged Compute Nodes
----------------------------

The following templates for Ceph and the overall layout create a
custom role called OSDCompute: 

- [ceph.yaml](custom-templates/ceph.yaml)
- [custom-roles.yaml](custom-templates/custom-roles.yaml)
- [layout.yaml](custom-templates/layout.yaml)

The above are derived works of [templates from an HCI RA](https://github.com/RHsyseng/hci).
Though they were modified for this envirionment and to include
`OS::TripleO::Services::ComputeNeutronOvsDpdkAgent` in place of
`OS::TripleO::Services::ComputeNeutronOvsAgent`. 

The [nova.yaml](custom-templates/nova.yaml) contains the tunings from [nova_mem_cpu_calc.py](https://github.com/RHsyseng/hci/blob/master/scripts/nova_mem_cpu_calc.py).

The [numa-systemd-osd.sh](https://github.com/RHsyseng/hci/blob/master/custom-templates/numa-systemd-osd.sh) was embedded in [post-install.yaml](custom-templates/post-install.yaml)
so that it could co-exist with the DPDK post deployment script. 

DPDK
----

The following templates were used for DPDK configuration: 

- [dpdk.yaml](custom-templates/dpdk.yaml)
- [dpdk-first-boot.yaml](custom-templates/dpdk-first-boot.yaml)
- [post-install.yaml](custom-templates/post-install.yaml)
