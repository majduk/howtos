# How to enable automatic eviction of a failing node

Cereate `/etc/mysql/conf.d/mysql-autoevict.cnf`:
```
[mysqld]
wsrep_provider_options="evs.auto_evict=1; evs.version=1"
```

Restart service.

References:
- http://galeracluster.com/documentation-webpages/autoeviction.html
