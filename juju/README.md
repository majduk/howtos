# JUJU hacks

Collect all relation data:
```
UNIT=keystone/leader
RELATION=ha
ID=$( juju run --unit $UNIT relation-ids $RELATION )
LIST=$( juju run --unit $UNIT "relation-list -r  $ID " ) 
for tgt in $LIST; do
    echo $tgt;
    juju run --unit $UNIT "relation-get -r $ID - $tgt";
done

```
Relation data that was published by hacluster-keystone/0

Using script:
```
./relation.sh  landscape-server/leader website
```


Dump database to yaml:
```
export JUJU_DEV_FEATURE_FLAGS=developer-mode
juju dump-db -m <model> > db-dump.yaml
```
