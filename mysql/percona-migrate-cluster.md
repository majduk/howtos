# How to migrate Openstack database

1) Deploy additional cluster using xenial and temporary VIP and wait until deployed
- `percona-new.yaml` file:
```
series: xenial
variables:
  mysql-vip:           &mysql-vip           100.86.0.19

relations:
- - percona-cluster-x
  - pxc-hacluster-x
services:
  percona-cluster-x:
    series: xenial
    charm: cs:percona-cluster
    num_units: 3
    options:
      innodb-buffer-pool-size: 10%
      max-connections: 5000
      min-cluster-size: 3
      vip: *mysql-vip
      performance-schema: True
      wait-timeout: 180
  pxc-hacluster-x:
    charm: hacluster
    series: xenial
```
- Run:
`juju deploy --debug percona-new.yaml`

3) identify old master node:
```
root@juju-2f583d-11-lxd-8:~# crm status
Last updated: Fri Mar 15 16:47:23 2019
Last change: Fri Mar 15 11:35:20 2019 via cibadmin on juju-2f583d-10-lxd-12
Stack: corosync
Current DC: juju-2f583d-10-lxd-12 (1001) - partition with quorum
Version: 1.1.10-42f2063
3 Nodes configured
4 Resources configured


Online: [ juju-2f583d-10-lxd-12 juju-2f583d-11-lxd-8 juju-2f583d-9-lxd-12 ]

 Resource Group: grp_percona_cluster
     res_mysql_vip      (ocf::heartbeat:IPaddr2):       Started juju-2f583d-10-lxd-12 ---> master node
 Clone Set: cl_mysql_monitor [res_mysql_monitor]
     Started: [ juju-2f583d-10-lxd-12 juju-2f583d-11-lxd-8 juju-2f583d-9-lxd-12 ]
```
3) stop keystone: `juju run --application keystone "sudo service apache2 stop"`

4) dump mysql database on old master
- Obtain password from any node in old cluster
```
cat /etc/mysql/my.cnf | grep wsrep_sst_auth`
export MYSQL_USER=sstuser
export MYSQL_PASSWORD=<PASSWORD>
```
- dump database:
```
TBD!!
```

5) import mysql database on new master
- Obtain password from any node in new cluster
```
cat /etc/mysql/my.cnf | grep wsrep_sst_auth`
export MYSQL_USER=sstuser
export MYSQL_PASSWORD=<PASSWORD>
```
- import database:
```
TBD!!
```
6) shutdown old cluster `juju run --application percona-cluster "sudo service mysql stop"`

6) reconfigure VIP
```
juju config percona-cluster-x vip=100.86.0.9 
```
And on any of the cluster node update VIP (to avoid removing and readding relation with HA-Cluster):
```
crm config 
crm(live)configure# edit
<edit the config>
crm(live)configure# quit
There are changes pending. Do you want to commit them? y
bye
```

7) update relations to new cluster
```
juju remove-relation keystone percona-cluster
juju remove-relation keystone percona-cluster-x
```

