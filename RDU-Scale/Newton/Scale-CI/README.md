# Templates for deploying overcloud for Scale CI

These templates can be used for deploying an overcloud with the following deploy
command:
```
openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e templates/network-environment.yaml -e templates/deploy.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml -r templates/roles_data.yaml --ntp-server clock.redhat.comnstack-tripleo-heat-templates/environments/network-isolation.yaml -e templates/network-environment.yaml -e templates/deploy.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/puppet-pacemaker.yaml -r templates/roles_data.yaml --ntp-server clock.redhat.com

```

It is assumed that the command is executed from /home/stack and the
configuration files in this directory are all present in /home/stack/templates
on the undercloud.

These templates were built based on the assumption that the undercloud
provioning interface would be over em2. Be sure to set *local_interface = em2*
in the undercloud.conf when deploying the undercloud.

## Hardware Details

The hardware consists of the following machine types

* R620
* R620
* R720xd
* 1029P
