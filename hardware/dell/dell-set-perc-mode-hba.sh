#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]
set source [lindex $argv 2]
set timeout 10
spawn ssh $host
expect "password: "
send "$pass\r"
expect "> "
send "racadm set Storage.Controller.1.RequestedControllerMode EnhancedHBA \r"
expect "> "
send "racadm jobqueue create RAID.Integrated.1-1\r"
expect "> "
send "racadm serveraction hardreset\n"
expect "> "
