# Percona Cluster replication

## Status

Corosync status:
```
ubuntu@node$ sudo crm_mon -Af
Last updated: Wed Feb 27 10:52:54 2019
Last change: Wed Feb 27 10:13:04 2019 via cibadmin on juju-df37a6-3
Stack: corosync
Current DC: juju-df37a6-3 (1002) - partition with quorum
Version: 1.1.10-42f2063
3 Nodes configured
4 Resources configured


Online: [ juju-df37a6-3 juju-df37a6-4 juju-df37a6-5 ]

 Resource Group: grp_percona_cluster
     res_mysql_vip      (ocf::heartbeat:IPaddr2):       Started juju-df37a6-3
 Clone Set: cl_mysql_monitor [res_mysql_monitor]
     Started: [ juju-df37a6-3 juju-df37a6-4 juju-df37a6-5 ]

Node Attributes:
* Node juju-df37a6-3:
    + readable                          : 1
    + writable                          : 1
* Node juju-df37a6-4:
    + readable                          : 1
    + writable                          : 1
* Node juju-df37a6-5:
    + readable                          : 1
    + writable                          : 1
```
Replication status:
```
mysql> SHOW GLOBAL STATUS LIKE 'wsrep_%';
+----------------------------+----------------------------------------------------------+
| Variable_name              | Value                                                    |
+----------------------------+----------------------------------------------------------+
| wsrep_local_state_uuid     | 622ef207-3a74-11e9-9232-1f0750d04af6                     |
| wsrep_protocol_version     | 4                                                        |
...
| wsrep_incoming_addresses   | 10.233.148.65:3306,10.233.148.188:3306,10.233.148.5:3306 |
| wsrep_cluster_conf_id      | 11                                                       |
| wsrep_cluster_size         | 3                                                        |
| wsrep_cluster_state_uuid   | 622ef207-3a74-11e9-9232-1f0750d04af6                     |
| wsrep_cluster_status       | Primary                                                  |
| wsrep_connected            | ON                                                       |
| wsrep_local_bf_aborts      | 0                                                        |
| wsrep_local_index          | 2                                                        |
| wsrep_provider_name        | Galera                                                   |
| wsrep_provider_vendor      | Codership Oy <info@codership.com>                        |
| wsrep_provider_version     | 2.8(r165)                                                |
| wsrep_ready                | ON                                                       |
+----------------------------+----------------------------------------------------------+
```
Monitoring send-receive replication queue:
```
ubuntu@juju-df37a6-3:~$ mysql -uroot -p -e "SHOW GLOBAL STATUS LIKE 'wsrep_local%queue';"
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| wsrep_local_send_queue | 0     |
| wsrep_local_recv_queue | 0     |
+------------------------+-------+
```

Reference:
- http://galeracluster.com/documentation-webpages/monitoringthecluster.html

