# How to fix cluster after master node crash

1. Identify node with latest data

You can use VIP location and VIP location history

```
 Resource Group: grp_percona_cluster
     res_mysql_vip      (ocf::heartbeat:IPaddr2):       Started juju-df37a6-3 ---> this is the master
 Clone Set: cl_mysql_monitor [res_mysql_monitor]
     Started: [ juju-df37a6-3 juju-df37a6-4 juju-df37a6-5 ]

```

2. Stop percona on other 2 nodes.

`service mysql stop`

3. Stop percona on master node

4. Bootstrap percona on master node

```
root@juju-df37a6-3:~# service mysql bootstrap-pxc
 * Bootstrapping Percona XtraDB Cluster database server mysqld
   ...done.
```
and check status:
```
root@juju-df37a6-3:~# mysql -uroot -pubuntu -e "show status like 'wsrep%'"
...
| wsrep_incoming_addresses   | 10.233.148.5:3306                    |
| wsrep_cluster_conf_id      | 1                                    |
| wsrep_cluster_size         | 1                                    |
| wsrep_cluster_state_uuid   | 622ef207-3a74-11e9-9232-1f0750d04af6 |
| wsrep_cluster_status       | Primary                              |
...
```
5. Start other 2 nodes:
```
root@juju-df37a6-4:~# service mysql start
 * Starting MySQL (Percona XtraDB Cluster) database server mysqld
 * SST in progress, setting sleep higher mysqld
   ...done.
```





