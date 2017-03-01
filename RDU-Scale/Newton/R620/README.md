# Templates for deploying overcloud with R620 Node types

These templates can be used for deploying an overcloud with the following deploy
command:
```
 openstack overcloud deploy --templates -e
/usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml
-e templates/network-environment.yaml 
-e templates/deploy.yaml -r templates/roles_data.yaml --ntp-server clock.redhat.com
```

It is assumed that the command is executed from /home/stack and the
configuration files in this directory are all present in /home/stack/templates
on the undercloud.

These templates were built based on the assumption that the undercloud
provioning interface would be over em2. Be sure to set *local_interface = em2*
in the undercloud.conf when deploying the undercloud.

## Hardware Details

Each of the R620 node contains 2 NICs that can be used for an Overcloud
deployment: em1 and em2. These NICs are 10G. We will make use of
both the  NICs in our templates. Internal API and Storage ( along
with Storage Management in the case of controllers) are on one NIC. 
Tenant network is put on a seperate NIC. Note that we will still be 
using OVS brdiges in some cases for compatibility and 
flexibility (to account for VLANed networks in the case of tenant network).

## roles_data.yaml

This is the file where we define our composable *R620Compute* role. We have
basically just replaced the *Compute* role with *R620Compute* role. Nothing else
changes here.

## network-environment.yaml

Since we defined a new role type *R620Compute*, we need to tell the installer
not only where it can find the nic-config templates for that role type, but also 
how the ports on each of the networks in the role needs to be configured. The
section below is the one that does this magic of correctly linking the role to
its network configuration. 

```
OS::TripleO::R620Compute::Net::SoftwareConfig: /home/stack/templates/nic-configs/R620-compute.yaml
OS::TripleO::R620Compute::Ports::ExternalPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
OS::TripleO::R620Compute::Ports::InternalApiPort: /usr/share/openstack-tripleo-heat-templates/network/ports/internal_api.yaml
OS::TripleO::R620Compute::Ports::StoragePort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage.yaml
OS::TripleO::R620Compute::Ports::StorageMgmtPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
OS::TripleO::R620Compute::Ports::TenantPort: /usr/share/openstack-tripleo-heat-templates/network/ports/tenant.yaml
```

## deploy.yaml

This sets the default parameters for node flavor and count. *R620ComputeCount*
sets the number of these composable compute nodes you want in your deplyoment.
*OvercloudR620ComputeFlavor* sets the falvor. We set it to compute in our
example but you could set it to anything you want as long as you have a
corresponding flavor already created and tagged to the nodes you want to use.

