# Postgres cluster recovery:

Check if clustered:
```
postgres@ic-defraf1-infra2:~$ pg_lsclusters
Ver Cluster Port Status Owner    Data directory               Log file
9.5 main    5432 online postgres /var/lib/postgresql/9.5/main /var/log/postgresql/postgresql-9.5-main.log
```

On slave for full replication start:
```
systemctl stop postgresql
su - postgres
mv 9.5/main 9.5/main.bck
```
Copy data from master:
```
postgres@ic-defraf1-infra1:~$ pg_basebackup -h 100.102.0.9 -D /var/lib/postgresql/9.5/main  -X stream -v -P -R
pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
transaction log start point: 4/B0000028 on timeline 1
pg_basebackup: starting background WAL receiver
845453/845453 kB (100%), 1/1 tablespace                                         
transaction log end point: 4/B00125D8
pg_basebackup: waiting for background process to finish streaming ...
pg_basebackup: base backup completed
```

check replication conf file, created by `-R` flag:
```
/var/lib/postgresql/9.5/main/recovery.conf
standby_mode = 'on'
primary_conninfo = 'host=100.102.0.9 port=5432 user=postgres application_name=ic-defraf1-infra1 keepalives_idle=60                    keepalives_interval=5                    keepalives_count=5'
restore_command = ''
recovery_target_timeline = 'latest'
```
Start postgres, it will start replication:
```
systemctl start postgresql
```

Check status:

Master:
```
postgres=# select usename,application_name,client_addr,backend_start,state,sync_state from pg_stat_replication ;
 usename | application_name | client_addr | backend_start | state | sync_state 
---------+------------------+-------------+---------------+-------+------------
```

Slave:
```
postgres=# select pg_is_in_recovery();
 pg_is_in_recovery 
-------------------
 t
(1 row)
```
