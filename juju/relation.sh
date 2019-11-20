#!/usr/bin/env bash

ID=$( juju run --unit keystone/leader relation-ids ha )
LIST=$( juju run --unit keystone/leader "relation-list -r  $ID " ) 
juju run --unit keystone/leader "relation-get -r ha:52 - hacluster-keystone/0"
