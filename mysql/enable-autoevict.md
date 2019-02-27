# How to enable automatic eviction of a failing node

Requires Galera 3.8+:
- https://packages.ubuntu.com/search?suite=default&section=all&arch=any&keywords=percona-galera-3&searchon=names
Available in Xenial and onwards.

Cereate `/etc/mysql/conf.d/mysql-autoevict.cnf`:
```
[mysqld]
wsrep_provider_options="evs.auto_evict=1; evs.version=1"
```

Restart service.

References:
- http://galeracluster.com/documentation-webpages/autoeviction.html
