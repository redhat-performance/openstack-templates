#!/bin/bash

openstack overcloud deploy \
  --timeout 100 \
  --templates /usr/share/openstack-tripleo-heat-templates \
  --libvirt-type kvm \
  --stack overcloud \
  -r /home/stack/ffwd/newton/roles_data.yaml \
  -e /home/stack/ffwd/newton/nodes.yaml \
  -e /home/stack/ffwd/newton/environments/args.yaml  -e /home/stack/ffwd/newton/environments/compute-params.yaml  -e /home/stack/ffwd/newton/environments/controller-params.yaml  -e /home/stack/ffwd/newton/environments/firstboot-env.yaml \
  -e /home/stack/ffwd/newton/r620-storage-environment.yaml \
  -e /home/stack/ffwd/newton/scheduler-hints.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
  -e /home/stack/ffwd/newton/network-environment.yaml \
  --log-file overcloud_deployment_64.log

