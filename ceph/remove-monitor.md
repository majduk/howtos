## Manually remove monitor from monmap

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
1: 10.100.0.9:6789/0 mon.juju-17defc-1-lxd-0
2: 10.100.0.10:6789/0 mon.juju-17defc-2-lxd-0
3: 10.100.0.11:6789/0 mon.juju-17defc-2-lxd-1
```

`monmaptool /tmp/monmap --rm juju-17defc-2-lxd-0`

`ceph-mon -i $(hostname) --inject-monmap /tmp/monmap`

`service ceph-mon start id=$(hostname)`
