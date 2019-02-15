## Add monitor to cluster

### Manually 
Example MONs to add:
10.100.0.11:6789/0 mon.juju-17defc-2-lxd-1

`service ceph-mon stop id=$(hostname)`

`ceph-mon -i $(hostname) --extract-monmap /tmp/monmap`

`monmaptool --print /tmp/monmap`

```
monmaptool: monmap file /tmp/monmap
epoch 3
fsid 3f0cfaaa-308a-11e9-96fc-00163e49b053
last_changed 2019-02-15 09:48:28.263838
created 2019-02-14 19:00:04.995398
0: 10.100.0.8:6789/0 mon.juju-17defc-3-lxd-0
```

`monmaptool /tmp/monmap --add juju-17defc-3-lxd-0 10.100.0.8:6789 --clobber`

`ceph-mon -i $(hostname) --inject-monmap /tmp/monmap`

`service ceph-mon start id=$(hostname)`

Note:
If there is only one node, map dump should be done on the running one, but inject and startup should be done on the one that is being added.

### With JUJU

`juju config ceph-mon monitor-count=3`

Juju will report status:
```
Unit         Workload     Agent       Machine  Public address  Ports  Message
ceph-mon/3*  blocked      idle        2/lxd/1  100.107.1.109          Insufficient peer units to bootstrap cluster (require 3)
```
However Ceph will report OK:
```
    cluster 3f0cfaaa-308a-11e9-96fc-00163e49b053
     health HEALTH_OK
     monmap e5: 1 mons at {juju-17defc-2-lxd-1=10.100.0.11:6789/0}
            election epoch 83, quorum 0 juju-17defc-2-lxd-1
     osdmap e85: 26 osds: 24 up, 24 in
            flags sortbitwise,require_jewel_osds
      pgmap v236: 364 pgs, 3 pools, 8868 MB data, 2219 objects
            29240 MB used, 187 GB / 215 GB avail
                 364 active+clean
```


`juju add-unit ceph-mon --to lxd:0`

`juju add-unit ceph-mon --to lxd:1`

Observe `watch -c juju status --color`

```
Model    Controller      Cloud/Region  Version  SLA
default  lab-controller  maas          2.3.7    unsupported

App       Version  Status   Scale  Charm     Store       Rev  OS      Notes
ceph-mon           blocked    2/3  ceph-mon  jujucharms   23  ubuntu    
ceph-osd  10.2.11  active       6  ceph-osd  jujucharms  257  ubuntu    

Unit         Workload     Agent       Machine  Public address  Ports  Message
ceph-mon/3*  blocked      idle        2/lxd/1  100.107.1.109          Insufficient peer units to bootstrap cluster (require 3)
ceph-mon/4   waiting      allocating  0/lxd/0                         waiting for machine
ceph-mon/5   maintenance  executing   1/lxd/1  100.107.1.110          (install) installing charm software
ceph-osd/0*  active       idle        0        100.107.1.100          Unit is ready (4 OSD)
ceph-osd/1   active       idle        1        100.107.1.101          Unit is ready (4 OSD)
ceph-osd/2   active       idle        2        100.107.1.102          Unit is ready (4 OSD)
ceph-osd/3   active       idle        3        100.107.1.105          Unit is ready (4 OSD)
ceph-osd/4   active       idle        4        100.107.1.103          Unit is ready (4 OSD)
ceph-osd/5   active       idle        5        100.107.1.104          Unit is ready (4 OSD)

Machine  State    DNS            Inst id              Series  AZ       Message
0        started  100.107.1.100  6gwydb               trusty  default  Deployed
0/lxd/0  pending                 pending              trusty           starting
1        started  100.107.1.101  ssx6pe               trusty  default  Deployed
1/lxd/1  started  100.107.1.110  juju-17defc-1-lxd-1  trusty  default  Container started 
2        started  100.107.1.102  4bex74               trusty  default  Deployed
2/lxd/1  started  100.107.1.109  juju-17defc-2-lxd-1  trusty  default  Container started 
3        started  100.107.1.105  xhx4sn               trusty  default  Deployed
4        started  100.107.1.103  4nyafg               trusty  default  Deployed
5        started  100.107.1.104  kwqyk7               trusty  default  Deployed

Relation provider  Requirer      Interface  Type     Message
ceph-mon:mon       ceph-mon:mon  ceph       peer
ceph-mon:osd       ceph-osd:mon  ceph-osd   regular
```
