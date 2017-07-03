# RDU-Scale nic-configs

Given the Scale lab has multiple system types, each connected different (some the same). We need to have customized templates per-node to give us greater flexibility and interface utilization.

## configs details

### R630
The R630s have 4 interfaces attached, our templates will deploy the following config:

#### Controller

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-storage | em1            | StorageNetwork, StorageMgmtNetwork |
| br-tenant  | em4            | TenantNetwork   |
| br-ex      | em2            | ControlPlane    |
|            | em3            | InternalAPISubnet |

#### Compute

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-storage | em1            | StorageNetwork |
| br-tenant  | em4            | TenantNetwork  |
| br-ex      | em2            | ControlPlane   |
|            | em3            | InternalAPISubnet |
