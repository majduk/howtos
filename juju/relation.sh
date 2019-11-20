#!/usr/bin/env bash

ID=$( juju run --unit keystone/leader relation-ids ha )
LIST=$( juju run --unit keystone/leader "relation-list -r  $ID " ) 
juju run --unit keystone/leader "relation-get -r ha:52 - hacluster-keystone/0"


juju run --unit keystone/leader "relation-get -r $ID - $LIST"

#all:
juju run --unit keystone/leader 'ID=$(relation-ids ha); for unit in $(relation-list -r  $ID); do relation-get -r $ID - $unit; done'
