# 6048R nic-configs

6048Rs have 4 nics
* ens3f0 - 40G
* ens3f1 - 40G (ctlplane on native vlan)
* enp5s0f0 - 10G/1G (cabled 1G)
* enp5s0f1 - 10G/1G (Not cabled)

## Controller

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-storage | ens3f0         | StorageNetwork |
| br-ex      | ens3f1         | ControlPlane,InternalAPISubnet,StorageMgmtNetwork,TenantNetwork |

## Compute

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-storage | ens3f0         | StorageNetwork |
| br-ex      | ens3f1         | ControlPlane,InternalAPISubnet,TenantNetwork |

## Ceph-Storage

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-storage | ens3f0         | StorageNetwork |
| br-storage-mgmt| ens3f1         | ControlPlane,StorageMgmtNetwork |
