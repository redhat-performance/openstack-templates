# RDU-Scale nic-configs

Given the Scale lab has multiple system types, each connected different (some the same). We need to have customized templates per-node to give us greater flexibility and interface utilization.

## configs details

### R930
The R930s have 4 interfaces attached, our templates will deploy the following config:

#### Controller

|   Bridge   |  Interface     |   Networks     |
|------------|:--------------:|---------------:|
| br-storage | em2            | StorageNetwork, StorageMgmtNetwork |
| br-tenant  | p1p1           | TenantNetwork   |
| br-ex      | em1            | ControlPlane    |
|            | p1p2           | Carried InternalAPISubnet |

#### Compute
- br-storage - StorageNetwork
- - em2
- br-tenant - TenantNetwork
- - p1p1
- br-ex - ControlPlane
- - em1
- p1p2 - Carried InternalAPISubnet
