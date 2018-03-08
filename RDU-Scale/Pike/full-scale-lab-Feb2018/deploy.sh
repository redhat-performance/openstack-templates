date
time openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml -e ~/templates/network-environment.yaml -e ~/templates/deploy.yaml -e ~/templates/ceph.yaml -e /home/stack/rhos12.yaml -r ~/templates/roles_data.yaml --ntp-server clock1.rdu2.redhat.com --timeout 500
#
# No Ceph
#
#time openstack overcloud deploy --templates -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml -e ~/templates/network-environment.yaml -e ~/templates/deploy.yaml -e /home/stack/rhos12.yaml -r ~/templates/roles_data.yaml --ntp-server clock1.rdu2.redhat.com 
date
