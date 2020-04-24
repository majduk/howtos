#!/usr/bin/env bash

UNIT=$1
RELATION=$2
ID=$( juju run --unit $UNIT relation-ids $RELATION )
if [ -z $ID ];then
    echo "No relation $UNIT $RELATION"
    exit 1
fi
LIST=$( juju run --unit $UNIT "relation-list -r  $ID " )
for tgt in $LIST; do
    echo $tgt;
    juju run --unit $UNIT "relation-get -r $ID - $tgt";
done
