#!/bin/bash
for interface in `ls /sys/kernel/debug/i40e`
do echo "lldp stop" > /sys/kernel/debug/i40e/${interface}/command
done
