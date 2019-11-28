# Ceph Howtos

## Ceph cheatsheet 
* Check osd hierarchy
  - ceph osd tree
  - ceph osd find osd.id
* Check mons
  - ceph mon stat
  - ceph mon dump
* Check pools
  - ceph osd pool ls
  - ceph osd dump
* Check PGs
  - ceph pg dump
  - ceph pg <pg_id> query
  - ceph pg dump_stuck unclean | inactive
  - ceph pg map <pgid>
* Check cluster capacity
  - ceph df 
  - ceph osd df
* Check auth
  - ceph auth list
* Admin socket command
  - ceph daemon osd.id help
  - ceph daemon mon.id help
* Check crush map
  - ceph osd crush dump
* Rados command
  - rados --help | less
Powerful, Allows you to manipulate with object (especially, allows you to get an object’s xattr and omap entries), but suggest only use those get or list methods first as those are only “read” commands

## Logging
- We can always enable the debugging at Run time 
  - Login to the osd.0 and run `ceph daemon osd.0 config set debug_ms 1`
  - Login to one of the monitor node and run `ceph tell osd.0 injectargs --debug_ms 1`
- If Require restart the daemon
  - Set `debug ms = 1` at the [global] section of the `/etc/ceph/ceph.conf` or the specific daemon section
  - Restart the daemon
- Log level
  - Between 0 to 30, larger number means more verbose
- Debug option
  - You should enable the debug option based on what is the issue you are looking into. Eg. you might need to set dbeug_osd 10 if you are debugging an osd issue. 


## Upmap for rebalancing

By default distribution is Gauss.
Expected is something like Dirac delta around 60 - 80% of utilisation.

Starting in Luminous v12.2.z there is a new pg-upmap exception table in the OSDMap that allows the cluster to explicitly map specific PGs to specific OSDs. This allows the cluster to fine-tune the data distribution to, in most cases, perfectly distributed PGs across OSDs.

[Upmap docs](https://docs.ceph.com/docs/master/rados/operations/upmap/)

