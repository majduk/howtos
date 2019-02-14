## How to migrate Ceph MON from LevelDB to RocksDB


1) Install tools: `apt install ceph-test`

2) Edit `ceph.conf` and add KV database:
```
[global]
mon keyvaluedb = rocksdb
```
3) Stop monitor service
`service ceph-mon stop id=$(hostname)`

4) Migrate database
```
mv /var/lib/ceph/mon/ceph-$(hostname)/store.db{,.orig} 
/usr/lib/ceph/bin/ceph-kvstore-tool leveldb /var/lib/ceph/mon/ceph-$(hostname)/store.db.orig store-copy /var/lib/ceph/mon/ceph-$(hostname)/store.db 10000 rocksdb
chown -R ceph:ceph /var/lib/ceph/mon/ceph-$(hostname)/
```
4) Start service
`service ceph-mon start id=$(hostname)`

References:
1. https://bugzilla.redhat.com/show_bug.cgi?id=1628321
2. http://docs.ceph.com/docs/master/releases/luminous/?highlight=backfill 
