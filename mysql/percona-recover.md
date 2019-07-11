## How to recover juju managed percona cluster

1.
```
juju run-action mysql/0 --wait pause
juju run-action mysql/1 --wait pause
juju run-action mysql/2 --wait pause
```

2.
```
juju run cat /var/lib/percona-xtradb-cluster/grastate.dat --unit mysql/0
juju run cat /var/lib/percona-xtradb-cluster/grastate.dat --unit mysql/1
juju run cat /var/lib/percona-xtradb-cluster/grastate.dat --unit mysql/2
```
^ see who has the highest seq no, if it doesn't show go to `/var/log/mysql/error.log` and grep for seqno. Or run: `mysqld_safe –wsrep-recover` # run on the 3 and compare, line will say recovered position uuid,seqno. Take a note of that seqno.

3. On that machine:

Edit `/var/lib/percona-xtradb-cluster/grastate.dat`:
change safe_to_bootstrap to 1


4. On the other 2:

Edit `/var/lib/percona-xtradb-cluster/grastate.dat`:
change safe_to_bootstrap to 0

5. Again, on that machine:
```
sudo mysqld_safe --wsrep_start_position=<seqno> --wsrep_cluster_address=gcomm:// # keep this running (ctrl+z, bg)
```
^ use the seqno you got before

6. On the other two:
```
juju run-action mysql/? --wait resume <- on the 2 units that are not the most ahead
```
7. Again on that machine:
```
juju status # once the remaining nodes are connected
juju run sudo reboot --unit mysql/?
juju run-action mysql/? --wait resume
```
