# RDU-Scale R630 Templates
These templates will work with the Dell R630 machines.

## How do I make these work?
### Assumptions
You have a working undercloud with all the nodes introspected and ready for a deployment, and you are only deploying with R630s.

### How-to
- Tag your compute nodes with the compute profile
`# ironic node-update <ironic-uuid> replace properties/capabilities=boot_option:local,cpu_vt:true,cpu_hugepages:true,cpu_txt:true,cpu_aes:true,cpu_hugepages_1g:true`
- Update deploy with the number of nodes
```
parameter_defaults:
  ControllerCount: 1
  R630ComputeCount: 1

  OvercloudR630ComputeFlavor: compute
```
- Deploy
`time openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e ~/templates/network-environment.yaml -e ~/deploy.yml -r ~/roles_data.yaml --ntp-server clock.redhat.com`

## What will this deploy?
By default they will deploy with 1 controller and 1 compute.
