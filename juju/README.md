# JUJU hacks

Collect all relation data:
```
ID=$( juju run --unit keystone/leader relation-ids ha )
LIST=$( juju run --unit keystone/leader "relation-list -r  $ID " ) 
juju run --unit keystone/leader "relation-get -r ha:52 - hacluster-keystone/0" 
```
Relation data that was published by hacluster-keystone/0


Dump database to yaml:
```
export JUJU_DEV_FEATURE_FLAGS=developer-mode
juju dump-db -m <model> > db-dump.yaml
```
