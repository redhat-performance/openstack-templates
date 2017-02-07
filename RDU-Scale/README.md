# RDUScale openstack-templates

## How do I know what kind of nodes I have?
Review the instackenv.json which is provided via the Scale Lab wiki: http://quads.scalelab.redhat.com/cloud/cloud01_c01-h01-r620.rdu.openstack.engineering.redhat.com_instackenv.json

We will see the following:
- pm_addr": "mgmt-c01-h02-r620.rdu.openstack.engineering.redhat.com",

The important part here is the -r620, which tells us this is a Dell R620, so you should use the R620 templates for that machine time.

## How do I deploy using these templates?
