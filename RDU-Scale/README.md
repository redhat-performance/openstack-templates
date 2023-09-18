# RDUScale openstack-templates

## What version of templates should I deploy?
- If you are deploying OSP10 -> Newton
- If you are deploying OSP11 -> Ocata
- ....

## How do I know what kind of nodes I have?
Review the instackenv.json. A link is typically provided via email if your allocation is managed by [QUADS](http://quads.dev/).   The link should look something like http://quads.subdomain.example.com/cloud/cloud01_somehost.subdomain.example.com_instackenv.json

We will see the following:
- pm_addr": "mgmt-somehost.subdomain.example.com",

Somehost will contain various components.  For example f01-h02-000-r620 indicates location, u-location, blade or standalone, and type.
The important part here is the -r620, which tells us this is a Dell R620, so you should use the R620 templates for that machine time.

## How do I deploy using these templates?
