# RDU-Perf HP nic-configs

## configs details

### HP

#### Controller

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-vlan / bond1      | ens2f0         | InternalApiIpSubnet ,StorageNetwork, StorageMgmtNetwork |
|            | ens2f1         | |
|            | ens1           | TenantIPSubnet |
| br-ex      | eno2           | ControlPlane |

#### Compute

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-vlan / bond1      | ens2f0         | InternalApiIpSubnet ,StorageNetwork|
|            | ens2f1         | |
|            | ens1           | TenantIPSubnet |
| br-ex      | eno2           | ControlPlane |

