List approles:
```
export VAULT_TOKEN=s.M7GF5B1Bhj8WDMOFNshRx5c9
export VAULT_ADDR=http://localhost:8220/
root@vault-1:~# vault list /auth/approle/role
Keys
----
charm-ceph-osd-0
charm-ceph-osd-1
charm-ceph-osd-2
charm-nova-compute-kvm-sriov-0
charm-nova-compute-kvm-sriov-1
charm-nova-compute-kvm-sriov-2
charm-nova-compute-kvm-sriov-3
local-charm-access
```
Read approle:
```
root@vault-1:~# vault read /auth/approle/role/charm-ceph-osd-0
WARNING! The following warnings were returned from Vault:

  * The "bound_cidr_list" parameter is deprecated and will be removed in favor
  of "secret_id_bound_cidrs".

Key                      Value
---                      -----
bind_secret_id           true
bound_cidr_list          [172.16.128.108/32]
local_secret_ids         false
period                   0s
policies                 [charm-ceph-osd-0]
secret_id_bound_cidrs    [172.16.128.108/32]
secret_id_num_uses       0
secret_id_ttl            0s
token_bound_cidrs        <nil>
token_max_ttl            1m
token_num_uses           0
token_ttl                1m
token_type               default
```
Read role id:
```
root@vault-1:~# vault read /auth/approle/role/charm-ceph-osd-0/role-id
Key        Value
---        -----
role_id    62c5d743-80fa-11bf-eeb1-675d4edc6ed9
```
Update allowed subnets:
```
root@vault-1:~# vault write /auth/approle/role/charm-ceph-osd-1 bound_cidr_list='172.16.128.0/24'
```
Subnets are also stored in secret ID so only migration from /32 to a bit wider is ok.
