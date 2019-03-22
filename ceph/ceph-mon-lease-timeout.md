# How to change MON election timeout

Show config:
```
ceph --admin-daemon /var/run/ceph/ceph-mon.juju-a2afdd-79-lxd-3.asok config show | less
```

Original, default values:
```
"mon_election_timeout": "5",
"mon_lease_ack_timeout_factor": "2",
"mon_accept_timeout_factor": "2",
```

Set:
```
ceph --admin-daemon /var/run/ceph/ceph-mon.juju-a2afdd-79-lxd-3.asok config set mon_election_timeout 20
ceph --admin-daemon /var/run/ceph/ceph-mon.juju-a2afdd-79-lxd-3.asok config set mon_lease_ack_timeout_factor 10
ceph --admin-daemon /var/run/ceph/ceph-mon.juju-a2afdd-79-lxd-3.asok config set mon_accept_timeout_factor 10
```
