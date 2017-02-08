# Deploying with 6048R nodes

## Node Types
* Controller
* Compute
* CephStorage

## Example deployment commands

Use provided template yamls in this repo for 6048Rs and the following deploy command:

3 6048R Controllers, 1 x 6048R Compute, 1 x 6048R CephStorage
```
# date;time openstack overcloud deploy --templates -r /home/stack/templates/roles_data.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /home/stack/templates/network-environment.yaml -e /homst/stack/templates/storage-environment.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml --libvirt-type=kvm --ntp-server 0.pool.ntp.org --neutron-network-type vxlan --neutron-tunnel-types vxlan -e /home/stack/templates/deploy.yaml ; date
```
