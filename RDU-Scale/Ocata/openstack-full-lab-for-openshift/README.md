# Templates for deploying OSP 11 GA with Composable roles for OpenShift-on-OpenStack Environment

The hosts included were:

* R630 Controllers
* R630 Computes
* R730 Computes
* R620 Computes
* R930 Computes
* R730 Ceph Storage

Telemetry was disabled by default.

Since, there were some manual changes done in the nova configuration file
post-initialy deployment, with every scale up pci-passthroug.yaml neded to be
passed to ensure that puppet doesn't overwrite those changes.


The deployment was done/scaled up in the following order:

1. Controllers + R630 Computes + R730 Ceph + R730 Computes
2. R620 Computes 

