# How to migrate Openstack database cluster

1) Deploy additional cluster using xenial and temporary VIP and wait until deployed.
It is advisible to do it this way instead of first deploying Percona cluster and then adding relation to hacluster because in the latter case the installation of hacluster software takes time and the overall downtime is longer.

- `percona-new.yaml` file:
```
series: xenial
variables:
  mysql-vip:           &mysql-vip           100.86.0.19 #temporary VIP

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

2) identify old master node:
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
- Obtain root password from any node in old cluster
```
export MYSQL_USER=root
export MYSQL_PASSWORD=$( juju run --unit percona-cluster/0 leader-get root-password )
```
- export data for all the databases, except system ones:
```
designate
nova_api
heat
dpm
nova
keystone
cinder
glance
neutron
```

```
mysqldump --user=$MYSQL_USER --password=$MYSQL_PASSWORD  $DATABASE > /tmp/dump_$DATABASE.sql
```

5) import mysql database on new master
- Obtain password from any node in new cluster
```
export MYSQL_USER=root
export MYSQL_PASSWORD=$( juju run --unit percona-cluster-x/0 leader-get root-password )
```
- import all databases:
```
designate
nova_api
heat
dpm
nova
keystone
cinder
glance
neutron
```

```
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -c "CREATE DATABASE $DATABASE;"
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD $DATABASE < /tmp/dump-$DATABASE.sql
```

6) shutdown old cluster's VIP
`juju ssh percona-cluster/0 "sudo crm resource stop res_mysql_vip"`

7) reconfigure VIP for new Cluster
```
juju config percona-cluster-x vip=100.86.0.9 
```
And on any of the cluster node update VIP via `crmsh` (to avoid removing and readding relation with HA-Cluster):
```
crm config 
crm(live)configure# edit
<edit the virtual IP in the config and set it to  100.86.0.9 >
crm(live)configure# quit
There are changes pending. Do you want to commit them? y
bye
```

8) update relations to new cluster for each service:

- check-mk-agent
- nrpe
- cinder
- designate
- glance
- heat
- neutron-api
- nova-cloud-controller
- keystone

```
juju remove-relation $SERVICE percona-cluster
juju add-relation $SERVICE percona-cluster-x
```

9) start keystone: `juju run --application keystone "sudo service apache2 stop"`

10) Remove old cluster.
