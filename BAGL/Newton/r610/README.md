# 5 Node Cloud with 2 Ceph Nodes

## Node Types
* 1 x R610 for Controller
* 2 x R610 for Computes
* 2 x R610 for CephStorage (1 OSDs ea.)

## Example deployment command

Use provided template yamls in this repo with the following deploy command:

```
# date;time openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /home/stack/templates/network-environment.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml -e /home/stack/templates/storage-environment.yaml --libvirt-type=kvm --ntp-server clock.walkabout.com --neutron-network-type vxlan --neutron-tunnel-types vxlan --control-scale 1 --compute-scale 2 --ceph-storage-scale 2  ;date
```
